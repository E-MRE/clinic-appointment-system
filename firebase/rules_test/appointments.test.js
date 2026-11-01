import { readFileSync } from 'node:fs';
import { assertFails, assertSucceeds, initializeTestEnvironment } from '@firebase/rules-unit-testing';
import { collection, deleteDoc, doc, getDoc, getDocs, query, serverTimestamp, setDoc, updateDoc, where } from 'firebase/firestore';

const rules = readFileSync(new URL('../../firestore.rules', import.meta.url), 'utf8');
const profiles = {
  patient: { role: 'patient' }, other: { role: 'patient' },
  doctor: { role: 'doctor', branchId: 'branch-1', departmentId: 'department-1' },
  technician: { role: 'technician', branchId: 'branch-1', departmentId: 'department-1' },
  doctor2: { role: 'doctor', branchId: 'branch-2', departmentId: 'department-1' },
  doctor3: { role: 'doctor', branchId: 'branch-1', departmentId: 'department-2' },
  admin: { role: 'admin' },
};
let env;
function signedIn(uid) { return env.authenticatedContext(uid).firestore(); }
function ref(db, id = 'a1') { return doc(db, 'appointments', id); }
function entry(status = 'pending', uid = 'patient', role = 'patient', at = new Date()) {
  return { status, byUserId: uid, byRole: role, at };
}
function appointment(change = {}) {
  return { patientId: 'patient', staffId: 'doctor', branchId: 'branch-1', departmentId: 'department-1',
    serviceId: 'service-1', serviceName: 'Consultation', feeMinorUnits: 100, date: '2026-12-01',
    start: '10:00', end: '10:30', status: 'pending', history: [entry()],
    createdAt: serverTimestamp(), updatedAt: serverTimestamp(), ...change };
}
function withChange(base, change) {
  const result = { ...base, ...change };
  for (const [key, value] of Object.entries(change)) if (value === undefined) delete result[key];
  return result;
}
async function seed(change = {}) {
  const base = appointment({ createdAt: new Date(0), updatedAt: new Date(0),
    history: [entry('pending', 'patient', 'patient', new Date(Date.now() - 10000))], ...change });
  await env.withSecurityRulesDisabled(async (context) => setDoc(ref(context.firestore()), base));
  return base;
}
function update(base, status, uid, change = {}) {
  return { status, history: [...base.history, entry(status, uid, profiles[uid].role)],
    updatedAt: serverTimestamp(), ...change };
}
before(async () => { env = await initializeTestEnvironment({ projectId: 'demo-clinic', firestore: { rules } }); });
beforeEach(async () => {
  await env.clearFirestore();
  await env.withSecurityRulesDisabled(async (context) => {
    for (const [uid, profile] of Object.entries(profiles)) await setDoc(doc(context.firestore(), 'users', uid), profile);
  });
});
after(async () => { await env.cleanup(); });

describe('appointments read', () => {
  for (const uid of ['patient', 'doctor', 'admin']) {
    it(`allows ${uid} to read an appointment`, async () => { await seed(); await assertSucceeds(getDoc(ref(signedIn(uid)))); });
  }
  for (const uid of ['other', 'technician', 'doctor2']) {
    it(`denies ${uid} reading another appointment`, async () => { await seed(); await assertFails(getDoc(ref(signedIn(uid)))); });
  }
  for (const [uid, field] of [['patient', 'patientId'], ['doctor', 'staffId']]) {
    it(`allows ${uid} to query their appointments`, async () => {
      await seed(); await assertSucceeds(getDocs(query(collection(signedIn(uid), 'appointments'), where(field, '==', uid))));
      await assertFails(getDocs(collection(signedIn(uid), 'appointments')));
      await assertFails(getDocs(query(collection(signedIn(uid), 'appointments'), where(field, '==', 'other'))));
    });
  }
  it('allows an admin to list appointments', async () => { await seed(); await assertSucceeds(getDocs(collection(signedIn('admin'), 'appointments'))); });
  it('denies signed-out reads', async () => { await seed(); await assertFails(getDoc(ref(env.unauthenticatedContext().firestore()))); });
});

describe('appointments create', () => {
  for (const staffId of ['doctor', 'technician']) {
    it(`allows a patient to book a ${staffId}`, async () => { await assertSucceeds(setDoc(ref(signedIn('patient')), appointment({ staffId }))); });
  }
  for (const offset of [-240000, 240000]) {
    it(`allows creation with a ${offset / 1000} second client clock offset`, async () => {
      await assertSucceeds(setDoc(ref(signedIn('patient')), appointment({
        history: [entry('pending', 'patient', 'patient', new Date(Date.now() + offset))],
      })));
    });
  }
  for (const uid of ['doctor', 'technician', 'admin', 'missing']) {
    it(`denies creation by ${uid}`, async () => { await assertFails(setDoc(ref(signedIn(uid)), appointment())); });
  }
  const invalid = {
    'another patient': { patientId: 'other' }, 'wrong status': { status: 'approved' },
    'extra key': { extra: true }, 'missing key': { serviceId: undefined },
    'blank staff': { staffId: ' ' }, 'blank branch': { branchId: ' ' },
    'blank department': { departmentId: ' ' }, 'blank service': { serviceId: ' ' },
    'blank service name': { serviceName: ' ' }, 'zero fee': { feeMinorUnits: 0 },
    'fractional fee': { feeMinorUnits: 1.5 }, 'bad date': { date: '2026-1-01' },
    'bad start': { start: '9:00' }, 'bad end': { end: '10:0' },
    'wrong branch': { staffId: 'doctor2' }, 'wrong department': { staffId: 'doctor3' },
    'patient as staff': { staffId: 'other' }, 'missing staff': { staffId: 'missing' },
    'empty history': { history: [] }, 'extra history': { history: [entry(), entry()] },
    'wrong history status': { history: [entry('approved')] },
    'wrong history actor': { history: [entry('pending', 'other')] },
    'wrong history role': { history: [entry('pending', 'patient', 'doctor')] },
    'extra history key': { history: [{ ...entry(), extra: true }] },
    'missing history key': { history: [{ status: 'pending', byUserId: 'patient', byRole: 'patient' }] },
    'history time too old': { history: [entry('pending', 'patient', 'patient', new Date(Date.now() - 360000))] },
    'history time too far ahead': { history: [entry('pending', 'patient', 'patient', new Date(Date.now() + 360000))] },
    'client creation time': { createdAt: new Date(0) }, 'client update time': { updatedAt: new Date(0) },
  };
  for (const [label, change] of Object.entries(invalid)) {
    it(`denies ${label}`, async () => { await assertFails(setDoc(ref(signedIn('patient')), withChange(appointment(), change))); });
  }
  it('denies signed-out creation', async () => { await assertFails(setDoc(ref(env.unauthenticatedContext().firestore()), appointment())); });
});

describe('appointments update', () => {
  const allowed = [
    ['patient', 'pending', 'cancelledByPatient'], ['patient', 'approved', 'cancelledByPatient'],
    ...['doctor', 'technician'].flatMap((uid) => [
      [uid, 'pending', 'approved'], [uid, 'pending', 'rejected'],
      [uid, 'approved', 'cancelledByStaff'], [uid, 'approved', 'completed'], [uid, 'approved', 'noShow'],
    ]),
    ['admin', 'pending', 'approved'], ['admin', 'pending', 'rejected'],
    ['admin', 'approved', 'cancelledByStaff'], ['admin', 'approved', 'completed'],
  ];
  for (const [uid, from, to] of allowed) {
    it(`allows ${uid} ${from} to ${to}`, async () => {
      const base = await seed({ status: from, staffId: uid === 'technician' ? uid : 'doctor' });
      await assertSucceeds(updateDoc(ref(signedIn(uid)), update(base, to, uid)));
    });
  }
  const denied = [
    ['other', 'pending', 'cancelledByPatient'], ['doctor2', 'pending', 'approved'],
    ['patient', 'pending', 'approved'], ['patient', 'approved', 'completed'],
    ['doctor', 'pending', 'completed'], ['doctor', 'approved', 'rejected'],
    ['admin', 'approved', 'noShow'], ['admin', 'pending', 'cancelledByStaff'],
    ...['rejected', 'cancelledByPatient', 'cancelledByStaff', 'completed', 'noShow'].map((status) => ['admin', status, 'approved']),
  ];
  for (const [uid, from, to] of denied) {
    it(`denies ${uid} ${from} to ${to}`, async () => {
      const base = await seed({ status: from }); await assertFails(updateDoc(ref(signedIn(uid)), update(base, to, uid)));
    });
  }
  const invalid = {
    'a changed service': (base) => ({ serviceName: 'Changed' }),
    'rewritten history': (base) => ({ history: [entry(), entry('approved', 'doctor', 'doctor')] }),
    'no append': (base) => ({ history: base.history }),
    'two appended entries': (base) => ({ history: [...base.history, entry('approved', 'doctor', 'doctor'), entry('approved', 'doctor', 'doctor')] }),
    'wrong role': (base) => ({ history: [...base.history, entry('approved', 'doctor', 'admin')] }),
    'wrong actor': (base) => ({ history: [...base.history, entry('approved', 'patient', 'doctor')] }),
    'wrong entry status': (base) => ({ history: [...base.history, entry('rejected', 'doctor', 'doctor')] }),
    'extra entry key': (base) => ({ history: [...base.history, { ...entry('approved', 'doctor', 'doctor'), extra: true }] }),
    'old timestamp': (base) => ({ history: [...base.history, entry('approved', 'doctor', 'doctor', new Date(Date.now() - 360000))] }),
    'future timestamp': (base) => ({ history: [...base.history, entry('approved', 'doctor', 'doctor', new Date(Date.now() + 360000))] }),
    'timestamp before previous': (base) => ({ history: [...base.history, entry('approved', 'doctor', 'doctor', new Date(Date.now() - 20000))] }),
    'client update time': () => ({ updatedAt: new Date(0) }),
  };
  for (const [label, change] of Object.entries(invalid)) {
    it(`denies ${label}`, async () => {
      const base = await seed(); await assertFails(updateDoc(ref(signedIn('doctor')), update(base, 'approved', 'doctor', change(base))));
    });
  }
  it('keeps multiple previous entries unchanged when appending', async () => {
    const base = await seed({ status: 'approved', history: [entry('pending', 'patient', 'patient', new Date(Date.now() - 20000)), entry('approved', 'doctor', 'doctor', new Date(Date.now() - 10000))] });
    await assertSucceeds(updateDoc(ref(signedIn('doctor')), update(base, 'completed', 'doctor')));
  });
  it('denies rewriting an earlier entry in a longer history', async () => {
    const base = await seed({ status: 'approved', history: [entry('pending', 'patient', 'patient', new Date(Date.now() - 20000)), entry('approved', 'doctor', 'doctor', new Date(Date.now() - 10000))] });
    const changed = [{ ...base.history[0], byUserId: 'other' }, base.history[1], entry('completed', 'doctor', 'doctor')];
    await assertFails(updateDoc(ref(signedIn('doctor')), update(base, 'completed', 'doctor', { history: changed })));
  });
  it('denies a signed-out update', async () => {
    const base = await seed();
    await assertFails(updateDoc(ref(env.unauthenticatedContext().firestore()), update(base, 'approved', 'doctor')));
  });
});

describe('appointments delete', () => {
  for (const uid of ['patient', 'doctor', 'admin', 'other']) {
    it(`denies ${uid}`, async () => { await seed(); await assertFails(deleteDoc(ref(signedIn(uid)))); });
  }
});
