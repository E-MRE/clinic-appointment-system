import { readFileSync } from 'node:fs';
import assert from 'node:assert/strict';
import { assertFails, assertSucceeds, initializeTestEnvironment } from '@firebase/rules-unit-testing';
import { arrayRemove, collection, deleteDoc, doc, getDoc, getDocs, query, serverTimestamp, setDoc, updateDoc, where, writeBatch } from 'firebase/firestore';

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
function slot(data, id = 'a1') {
  return { appointmentId: id, start: data.start, end: data.end };
}
function dayData(slots, id = 'a1') {
  return { slots, lastAppointmentId: id, updatedAt: serverTimestamp() };
}
function dayRefs(db, data) {
  return [doc(db, 'staffBookings', data.staffId, 'days', data.date),
    doc(db, 'patientBookings', data.patientId, 'days', data.date)];
}
function book(db, data = appointment(), changeDays = (days) => days) {
  const batch = writeBatch(db);
  batch.set(ref(db), data);
  const days = dayRefs(db, data).map((ref) => ({ ref, data: dayData([slot(data)]) }));
  for (const day of changeDays(days)) batch.set(day.ref, day.data);
  return batch.commit();
}
function transition(db, base, status, uid, change = {}, changeDays = (days) => days) {
  const batch = writeBatch(db);
  batch.update(ref(db), update(base, status, uid, change));
  if (['rejected', 'cancelledByPatient', 'cancelledByStaff'].includes(status)) {
    const days = dayRefs(db, base).map((ref) => ({ ref, data: dayData(arrayRemove(slot(base))) }));
    for (const day of changeDays(days)) batch.set(day.ref, day.data, { merge: true });
  }
  return batch.commit();
}
function withChange(base, change) {
  const result = { ...base, ...change };
  for (const [key, value] of Object.entries(change)) if (value === undefined) delete result[key];
  return result;
}
async function seed(change = {}) {
  const base = appointment({ createdAt: new Date(0), updatedAt: new Date(0),
    history: [entry('pending', 'patient', 'patient', new Date(Date.now() - 10000))], ...change });
  await env.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(ref(db), base);
    for (const day of dayRefs(db, base)) {
      await setDoc(day, dayData(['pending', 'approved', 'completed', 'noShow'].includes(base.status) ? [slot(base)] : []));
    }
  });
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
    it(`allows a patient to book a ${staffId}`, async () => { await assertSucceeds(book(signedIn('patient'), appointment({ staffId }))); });
  }
  for (const offset of [-240000, 240000]) {
    it(`allows creation with a ${offset / 1000} second client clock offset`, async () => {
      await assertSucceeds(book(signedIn('patient'), appointment({
        history: [entry('pending', 'patient', 'patient', new Date(Date.now() + offset))],
      })));
    });
  }
  for (const uid of ['doctor', 'technician', 'admin', 'missing']) {
    it(`denies creation by ${uid}`, async () => { await assertFails(book(signedIn(uid))); });
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
    it(`denies ${label}`, async () => { await assertFails(book(signedIn('patient'), withChange(appointment(), change))); });
  }
  it('denies signed-out creation', async () => { await assertFails(book(env.unauthenticatedContext().firestore())); });
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
      await assertSucceeds(transition(signedIn(uid), base, to, uid));
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
      const base = await seed({ status: from }); await assertFails(transition(signedIn(uid), base, to, uid));
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

const otherSlots = [
  { appointmentId: 'earlier', start: '08:00', end: '08:30' },
  { appointmentId: 'later', start: '12:00', end: '12:30' },
];
async function seedDays(data, slots = otherSlots) {
  await env.withSecurityRulesDisabled(async (context) => {
    for (const day of dayRefs(context.firestore(), data)) await setDoc(day, dayData(slots));
  });
}

describe('busy-slot booking projection', () => {
  it('appends to both existing day lists and preserves their distinct entries in order', async () => {
    const data = appointment();
    await env.withSecurityRulesDisabled(async (context) => {
      const [staff, patient] = dayRefs(context.firestore(), data);
      await setDoc(staff, dayData(otherSlots));
      await setDoc(patient, dayData([...otherSlots].reverse()));
    });
    await assertSucceeds(book(signedIn('patient'), data, (days) => days.map((day, index) => ({
      ...day, data: dayData([...(index === 0 ? otherSlots : [...otherSlots].reverse()), slot(data)]),
    }))));
  });
  it('appends to existing empty day lists', async () => {
    const data = appointment(); await seedDays(data, []);
    await assertSucceeds(book(signedIn('patient'), data));
  });
  for (const index of [0, 1]) {
    const collection = index === 0 ? 'staff' : 'patient';
    it(`denies booking without the ${collection} day write`, async () => {
      await assertFails(book(signedIn('patient'), appointment(), (days) => days.filter((_, i) => i !== index)));
    });
    const invalidSlots = {
      'missing entry': () => [],
      'wrong appointment id': (data) => [{ ...slot(data), appointmentId: 'wrong' }],
      'wrong start': (data) => [{ ...slot(data), start: '09:00' }],
      'wrong end': (data) => [{ ...slot(data), end: '11:00' }],
      'missing slot field': () => [{ appointmentId: 'a1', start: '10:00' }],
      'extra slot field': (data) => [{ ...slot(data), extra: true }],
      'extra entry': (data) => [slot(data), otherSlots[0]],
      'duplicate entry': (data) => [slot(data), slot(data)],
    };
    for (const [label, slots] of Object.entries(invalidSlots)) {
      it(`denies ${label} in the ${collection} day`, async () => {
        const data = appointment();
        await assertFails(book(signedIn('patient'), data, (days) => days.map((day, i) => i === index
          ? { ...day, data: dayData(slots(data)) } : day)));
      });
    }
    const wrongAppends = {
      'entry at the start': (data) => [slot(data), ...otherSlots],
      'entry in the middle': (data) => [otherSlots[0], slot(data), otherSlots[1]],
      'lost previous entry': (data) => [otherSlots[0], slot(data)],
      'reordered previous entries': (data) => [...otherSlots].reverse().concat([slot(data)]),
    };
    for (const [label, slots] of Object.entries(wrongAppends)) {
      it(`denies ${label} in an existing ${collection} day`, async () => {
        const data = appointment(); await seedDays(data);
        await assertFails(book(signedIn('patient'), data, (days) => days.map((day, i) => ({
          ...day, data: dayData(i === index ? slots(data) : [...otherSlots, slot(data)]),
        }))));
      });
    }
    for (const wrong of ['owner', 'date']) {
      it(`denies an extra ${collection} day for another ${wrong} alongside a valid booking`, async () => {
        const db = signedIn('patient');
        await assertFails(book(db, appointment(), (days) => [...days, {
          ...days[index], ref: doc(db, index === 0 ? 'staffBookings' : 'patientBookings',
            wrong === 'owner' ? 'other' : index === 0 ? 'doctor' : 'patient',
            'days', wrong === 'date' ? '2026-12-02' : '2026-12-01'),
        }]));
      });
    }
    const invalidDay = {
      'wrong lastAppointmentId': { lastAppointmentId: 'wrong' },
      'blank lastAppointmentId': { lastAppointmentId: ' ' },
      'non-string lastAppointmentId': { lastAppointmentId: 42 },
      'extra day field': { extra: true },
      'missing day field': { lastAppointmentId: undefined },
      'client day timestamp': { updatedAt: new Date(0) },
      'slots as a map': { slots: {} },
    };
    for (const [label, change] of Object.entries(invalidDay)) {
      it(`denies ${label} on the ${collection} day`, async () => {
        await assertFails(book(signedIn('patient'), appointment(), (days) => days.map((day, i) => i === index
          ? { ...day, data: withChange(day.data, change) } : day)));
      });
    }
  }
  it('denies an appointment-only booking', async () => {
    await assertFails(setDoc(ref(signedIn('patient')), appointment()));
  });
});

describe('busy-slot transition projection', () => {
  const releases = [
    ['doctor', 'pending', 'rejected'], ['technician', 'pending', 'rejected'],
    ['admin', 'pending', 'rejected'], ['patient', 'pending', 'cancelledByPatient'],
    ['patient', 'approved', 'cancelledByPatient'], ['doctor', 'approved', 'cancelledByStaff'],
    ['technician', 'approved', 'cancelledByStaff'], ['admin', 'approved', 'cancelledByStaff'],
  ];
  for (const [uid, from, to] of releases) {
    it(`allows ${uid} ${to} using merge and arrayRemove, retaining the other entries in order`, async () => {
      const base = await seed({ status: from, staffId: uid === 'technician' ? uid : 'doctor' });
      await seedDays(base, [otherSlots[0], slot(base), otherSlots[1]]);
      const db = signedIn(uid);
      if (uid === 'doctor' || uid === 'technician') {
        await assertFails(getDoc(dayRefs(db, base)[1]));
      }
      await assertSucceeds(transition(db, base, to, uid));
      for (const day of dayRefs(signedIn('patient'), base)) {
        const snapshot = await assertSucceeds(getDoc(day));
        assert.deepEqual(snapshot.data().slots, otherSlots);
        assert.equal(snapshot.data().lastAppointmentId, 'a1');
      }
    });
    for (const omitted of [0, 1, 'both']) {
      it(`denies ${uid} ${from} to ${to} without ${omitted === 'both' ? 'both' : omitted === 0 ? 'staff' : 'patient'} day writes`, async () => {
        const base = await seed({ status: from, staffId: uid === 'technician' ? uid : 'doctor' });
        await assertFails(transition(signedIn(uid), base, to, uid, {},
          (days) => omitted === 'both' ? [] : days.filter((_, index) => index !== omitted)));
      });
    }
  }
  for (const index of [0, 1]) {
    for (const [label, removed] of [
      ['another entry', () => otherSlots[0]],
      ['a wrong start', (base) => ({ ...slot(base), start: '09:00' })],
      ['a wrong end', (base) => ({ ...slot(base), end: '11:00' })],
    ]) {
      it(`denies removing ${label} from day ${index}`, async () => {
        const base = await seed(); await seedDays(base, [otherSlots[0], slot(base), otherSlots[1]]);
        await assertFails(transition(signedIn('doctor'), base, 'rejected', 'doctor', {}, (days) => days.map((day, i) => i === index
          ? { ...day, data: dayData(arrayRemove(removed(base))) } : day)));
      });
    }
    it(`denies removing an extra entry from day ${index}`, async () => {
      const base = await seed(); await seedDays(base, [otherSlots[0], slot(base), otherSlots[1]]);
      await assertFails(transition(signedIn('doctor'), base, 'rejected', 'doctor', {}, (days) => days.map((day, i) => i === index
        ? { ...day, data: dayData(arrayRemove(slot(base), otherSlots[0])) } : day)));
    });
    it(`denies reordering retained entries in day ${index}`, async () => {
      const base = await seed(); await seedDays(base, [otherSlots[0], slot(base), otherSlots[1]]);
      await assertFails(transition(signedIn('doctor'), base, 'rejected', 'doctor', {}, (days) => days.map((day, i) => i === index
        ? { ...day, data: dayData([...otherSlots].reverse()) } : day)));
    });
    it(`denies the wrong lastAppointmentId on removal from day ${index}`, async () => {
      const base = await seed();
      await assertFails(transition(signedIn('doctor'), base, 'rejected', 'doctor', {}, (days) => days.map((day, i) => i === index
        ? { ...day, data: { ...day.data, lastAppointmentId: 'wrong' } } : day)));
    });
  }
  for (const [from, to] of [['pending', 'approved'], ['approved', 'completed'], ['approved', 'noShow']]) {
    it(`allows ${to} without day writes and preserves both complete day documents`, async () => {
      const base = await seed({ status: from });
      const db = signedIn('patient');
      const before = await Promise.all(dayRefs(db, base).map((day) => getDoc(day)));
      await assertSucceeds(transition(signedIn('doctor'), base, to, 'doctor'));
      const after = await Promise.all(dayRefs(db, base).map((day) => getDoc(day)));
      after.forEach((snapshot, index) => assert.deepEqual(snapshot.data(), before[index].data()));
    });
    for (const index of [0, 1]) {
      for (const [label, slots] of [
        ['removing', (base) => arrayRemove(slot(base))],
        ['appending', (base) => [slot(base), otherSlots[0]]],
        ['rewriting metadata without changing', (base) => [slot(base)]],
      ]) {
        it(`denies ${label} day ${index} slots during ${to}`, async () => {
          const base = await seed({ status: from });
          const db = signedIn('doctor'); const batch = writeBatch(db);
          batch.update(ref(db), update(base, to, 'doctor'));
          batch.set(dayRefs(db, base)[index], dayData(slots(base)), { merge: true });
          await assertFails(batch.commit());
        });
      }
    }
  }
});

describe('busy-slot standalone writes and access', () => {
  for (const index of [0, 1]) {
    const collection = index === 0 ? 'staff' : 'patient';
    it(`denies creating a ${collection} day without an appointment`, async () => {
      const data = appointment(); const db = signedIn('patient');
      await assertFails(setDoc(dayRefs(db, data)[index], dayData([slot(data)])));
    });
    it(`denies creating a ${collection} day for an unchanged existing appointment`, async () => {
      const base = await seed();
      await env.withSecurityRulesDisabled(async (context) => deleteDoc(dayRefs(context.firestore(), base)[index]));
      await assertFails(setDoc(dayRefs(signedIn('patient'), base)[index], dayData([slot(base)])));
    });
    for (const uid of ['patient', 'doctor', 'admin']) {
      it(`denies ${uid} appending to a ${collection} day without an appointment write`, async () => {
        const base = await seed();
        await assertFails(setDoc(dayRefs(signedIn(uid), base)[index], dayData([slot(base), otherSlots[0]])));
      });
      it(`denies ${uid} removing from a ${collection} day without an appointment write`, async () => {
        const base = await seed();
        await assertFails(setDoc(dayRefs(signedIn(uid), base)[index], dayData(arrayRemove(slot(base))), { merge: true }));
      });
      it(`denies ${uid} deleting a ${collection} day`, async () => {
        const base = await seed(); await assertFails(deleteDoc(dayRefs(signedIn(uid), base)[index]));
      });
    }
    it(`denies writing a ${collection} day for an unchanged non-occupying appointment`, async () => {
      const base = await seed({ status: 'rejected' });
      await assertFails(setDoc(dayRefs(signedIn('admin'), base)[index], dayData([])));
    });
    it(`denies signed-out ${collection} day reads and writes`, async () => {
      const base = await seed(); const day = dayRefs(env.unauthenticatedContext().firestore(), base)[index];
      await assertFails(getDoc(day)); await assertFails(setDoc(day, dayData([])));
    });
    for (const uid of ['patient', 'other', 'doctor', 'technician', 'admin', 'missing']) {
      it(`${index === 0 || ['patient', 'admin'].includes(uid) ? 'allows' : 'denies'} ${uid} reading a ${collection} day`, async () => {
        const base = await seed(); const result = getDoc(dayRefs(signedIn(uid), base)[index]);
        if (index === 0 || ['patient', 'admin'].includes(uid)) await assertSucceeds(result);
        else await assertFails(result);
      });
    }
  }
});
