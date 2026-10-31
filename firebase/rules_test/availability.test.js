import { readFileSync } from 'node:fs';
import { assertFails, assertSucceeds, initializeTestEnvironment } from '@firebase/rules-unit-testing';
import { deleteDoc, doc, getDoc, serverTimestamp, setDoc } from 'firebase/firestore';

const rules = readFileSync(new URL('../../firestore.rules', import.meta.url), 'utf8');
const profiles = {
  doctor: { role: 'doctor', branchId: 'branch-1' },
  doctor2: { role: 'doctor', branchId: 'branch-1' },
  technician: { role: 'technician', branchId: 'branch-1' },
  patient: { role: 'patient' },
  admin: { role: 'admin' },
};
let env;
function signedIn(uid) { return env.authenticatedContext(uid).firestore(); }
function weekly() {
  return { monday: [], tuesday: [], wednesday: [], thursday: [], friday: [], saturday: [], sunday: [] };
}
function availability(change = {}) {
  return { branchId: 'branch-1', weekly: weekly(), oneOff: [], updatedAt: serverTimestamp(), ...change };
}
function withChange(base, change) {
  const result = { ...base, ...change };
  for (const [key, value] of Object.entries(change)) if (value === undefined) delete result[key];
  return result;
}
function ref(db, uid = 'doctor') { return doc(db, 'staffAvailability', uid); }
before(async () => {
  env = await initializeTestEnvironment({ projectId: 'demo-clinic', firestore: { rules } });
});
describe('staff availability rules', () => {
  beforeEach(async () => {
    await env.clearFirestore();
    await env.withSecurityRulesDisabled(async (context) => {
      for (const [uid, profile] of Object.entries(profiles)) {
        await setDoc(doc(context.firestore(), 'users', uid), profile);
      }
      await setDoc(ref(context.firestore()), availability({ updatedAt: new Date(0) }));
    });
  });
  after(async () => { await env.cleanup(); });
  it('allows a doctor to create and update their own document', async () => {
    const db = signedIn('doctor2');
    await assertSucceeds(setDoc(ref(db, 'doctor2'), availability()));
    await assertSucceeds(setDoc(ref(db, 'doctor2'), availability()));
  });
  it('allows a technician to write their own document', async () => {
    await assertSucceeds(setDoc(ref(signedIn('technician'), 'technician'), availability()));
  });
  it('allows an admin to write a doctor document', async () => {
    await assertSucceeds(setDoc(ref(signedIn('admin')), availability()));
  });
  for (const uid of ['patient', 'doctor', 'new']) {
    it(`allows ${uid} to read`, async () => { await assertSucceeds(getDoc(ref(signedIn(uid)))); });
  }
  it('denies signed-out reads and writes', async () => {
    const db = env.unauthenticatedContext().firestore();
    await assertFails(getDoc(ref(db)));
    await assertFails(setDoc(ref(db), availability()));
  });
  for (const [actor, target] of [['doctor', 'doctor2'], ['patient', 'patient'], ['admin', 'admin'], ['admin', 'missing']]) {
    it(`denies ${actor} writing ${target}`, async () => {
      await assertFails(setDoc(ref(signedIn(actor), target), availability()));
    });
  }
  const invalid = {
    'a missing key': { oneOff: undefined },
    'an extra key': { extra: true },
    'another branch': { branchId: 'branch-2' },
    'six weekdays': { weekly: withChange(weekly(), { sunday: undefined }) },
    'an eighth weekday': { weekly: { ...weekly(), extra: [] } },
    'a non-list day': { weekly: { ...weekly(), monday: 'bad' } },
    '13 daily windows': { weekly: { ...weekly(), monday: Array(13).fill({}) } },
    '61 one-off windows': { oneOff: Array(61).fill({}) },
    'a client timestamp': { updatedAt: new Date(0) },
  };
  for (const [label, change] of Object.entries(invalid)) {
    it(`denies ${label}`, async () => {
      await assertFails(setDoc(ref(signedIn('doctor')), withChange(availability(), change)));
    });
  }
  it('allows the maximum number of windows', async () => {
    await assertSucceeds(setDoc(ref(signedIn('doctor')), availability({
      weekly: { ...weekly(), monday: Array(12).fill({}) }, oneOff: Array(60).fill({}),
    })));
  });
  for (const uid of ['doctor', 'admin']) {
    it(`denies deletion by ${uid}`, async () => { await assertFails(deleteDoc(ref(signedIn(uid)))); });
  }
});
