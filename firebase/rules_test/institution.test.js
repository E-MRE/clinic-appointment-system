import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  collection,
  deleteDoc,
  doc,
  getDoc,
  getDocs,
  setDoc,
  updateDoc,
} from 'firebase/firestore';

const rules = readFileSync(
  new URL('../../firestore.rules', import.meta.url),
  'utf8',
);

const profiles = {
  patient: { role: 'patient', fullName: 'Elif Kaya', email: 'patient@example.com' },
  doctor: { role: 'doctor', fullName: 'Dr. Ayşe Yılmaz', email: 'doctor@example.com' },
  admin: { role: 'admin', fullName: 'Admin', email: 'admin@example.com' },
};

const collections = ['clinics', 'branches', 'departments'];
const collectionLabels = {
  clinics: 'clinic',
  branches: 'branch',
  departments: 'department',
};
const actors = ['patient', 'doctor', 'admin'];
const actorLabels = {
  patient: 'a patient',
  doctor: 'a doctor',
  admin: 'an admin',
};

let env;

/** Firestore for a signed-in user whose token carries their profile email. */
function signedIn(uid) {
  return env
    .authenticatedContext(uid, { email: profiles[uid].email })
    .firestore();
}

function signedOut() {
  return env.unauthenticatedContext().firestore();
}

function validWorkingHours() {
  return {
    monday: [
      { start: '09:00', end: '12:00' },
      { start: '13:00', end: '17:00' },
    ],
    tuesday: [],
    wednesday: [{ start: '09:00', end: '17:00' }],
    thursday: [],
    friday: [{ start: '09:00', end: '17:00' }],
    saturday: [],
    sunday: [],
  };
}

function validData(collectionName) {
  if (collectionName === 'clinics') {
    return { name: 'Central Clinic' };
  }
  if (collectionName === 'branches') {
    return {
      clinicId: 'clinic-1',
      name: 'Main Branch',
      address: '100 Main Street',
      workingHours: validWorkingHours(),
    };
  }
  return { branchId: 'branch-1', name: 'Cardiology' };
}

async function seedInstitutions(db) {
  await setDoc(doc(db, 'clinics', 'clinic-1'), { name: 'Central Clinic' });
  await setDoc(doc(db, 'clinics', 'clinic-2'), { name: 'North Clinic' });
  await setDoc(doc(db, 'branches', 'branch-1'), {
    clinicId: 'clinic-1',
    name: 'Main Branch',
    address: '100 Main Street',
    workingHours: validWorkingHours(),
  });
  await setDoc(doc(db, 'branches', 'branch-2'), {
    clinicId: 'clinic-1',
    name: 'North Branch',
    address: '200 North Street',
    workingHours: validWorkingHours(),
  });
  await setDoc(doc(db, 'departments', 'department-1'), {
    branchId: 'branch-1',
    name: 'Cardiology',
  });
}

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-clinic',
    firestore: { rules },
  });
});

after(async () => {
  await env.cleanup();
});

describe('institution rules', () => {
  beforeEach(async () => {
    await env.clearFirestore();
    await env.withSecurityRulesDisabled(async (context) => {
      const db = context.firestore();
      for (const [uid, profile] of Object.entries(profiles)) {
        await setDoc(doc(db, 'users', uid), profile);
      }
      await seedInstitutions(db);
    });
  });

  describe('institution reads', () => {
    for (const role of actors) {
      for (const collectionName of collections) {
        const label = collectionLabels[collectionName];
        it(`lets ${actorLabels[role]} get a ${label} document`, async () => {
          const id = collectionName === 'departments' ? 'department-1' :
            collectionName === 'branches' ? 'branch-1' : 'clinic-1';
          const snapshot = await assertSucceeds(
            getDoc(doc(signedIn(role), collectionName, id)),
          );
          assert.equal(snapshot.exists(), true);
        });

        it(`lets ${actorLabels[role]} list ${collectionName}`, async () => {
          const snapshot = await assertSucceeds(
            getDocs(collection(signedIn(role), collectionName)),
          );
          assert.equal(snapshot.empty, false);
        });
      }
    }

    for (const collectionName of collections) {
      it(`denies signed-out get and list on ${collectionName}`, async () => {
        const db = signedOut();
        const id = collectionName === 'departments' ? 'department-1' :
          collectionName === 'branches' ? 'branch-1' : 'clinic-1';
        await assertFails(getDoc(doc(db, collectionName, id)));
        await assertFails(getDocs(collection(db, collectionName)));
      });
    }
  });

  describe('institution creates', () => {
    for (const collectionName of collections) {
      const label = collectionLabels[collectionName];
      it(`lets an admin create a valid ${label}`, async () => {
        await assertSucceeds(
          setDoc(doc(signedIn('admin'), collectionName, 'new-record'),
            validData(collectionName)),
        );
      });

      for (const role of ['patient', 'doctor']) {
        it(`denies ${actorLabels[role]} creating a ${label} document`, async () => {
          await assertFails(
            setDoc(doc(signedIn(role), collectionName, 'new-record'),
              validData(collectionName)),
          );
        });
      }

      it(`denies a signed-out user creating a ${label} document`, async () => {
        await assertFails(
          setDoc(doc(signedOut(), collectionName, 'new-record'),
            validData(collectionName)),
        );
      });

      it(`denies an admin creating a ${label} with an extra field`, async () => {
        await assertFails(
          setDoc(doc(signedIn('admin'), collectionName, 'extra-field'), {
            ...validData(collectionName),
            unexpected: 'value',
          }),
        );
      });

      it(`denies an admin creating a ${label} with a missing field`, async () => {
        const data = validData(collectionName);
        const missingField = Object.keys(data)[0];
        delete data[missingField];
        await assertFails(
          setDoc(doc(signedIn('admin'), collectionName, 'missing-field'), data),
        );
      });

      it(`denies an admin creating a ${label} with a blank name`, async () => {
        await assertFails(
          setDoc(doc(signedIn('admin'), collectionName, 'blank-name'), {
            ...validData(collectionName),
            name: '  ',
          }),
        );
      });
    }

    it('denies an admin creating a branch for an unknown clinic', async () => {
      await assertFails(
        setDoc(doc(signedIn('admin'), 'branches', 'unknown-clinic'), {
          ...validData('branches'),
          clinicId: 'missing-clinic',
        }),
      );
    });

    it('denies an admin creating a branch without an address', async () => {
      const data = validData('branches');
      delete data.address;
      await assertFails(
        setDoc(doc(signedIn('admin'), 'branches', 'missing-address'), data),
      );
    });

    it('denies an admin creating a branch with a blank address', async () => {
      await assertFails(
        setDoc(doc(signedIn('admin'), 'branches', 'blank-address'), {
          ...validData('branches'),
          address: '  ',
        }),
      );
    });

    it('denies an admin creating a department for an unknown branch', async () => {
      await assertFails(
        setDoc(doc(signedIn('admin'), 'departments', 'unknown-branch'), {
          ...validData('departments'),
          branchId: 'missing-branch',
        }),
      );
    });

    it('denies a branch with a missing weekday', async () => {
      const workingHours = validWorkingHours();
      delete workingHours.thursday;
      await assertFails(
        setDoc(doc(signedIn('admin'), 'branches', 'missing-weekday'), {
          ...validData('branches'),
          workingHours,
        }),
      );
    });

    it('denies a branch with an unknown working-hours key', async () => {
      const workingHours = { ...validWorkingHours(), funday: [] };
      await assertFails(
        setDoc(doc(signedIn('admin'), 'branches', 'unknown-weekday'), {
          ...validData('branches'),
          workingHours,
        }),
      );
    });

    it('denies a branch with a non-list weekday value', async () => {
      const workingHours = { ...validWorkingHours(), monday: 'closed' };
      await assertFails(
        setDoc(doc(signedIn('admin'), 'branches', 'non-list-weekday'), {
          ...validData('branches'),
          workingHours,
        }),
      );
    });
  });

  describe('institution updates', () => {
    for (const collectionName of collections) {
      const label = collectionLabels[collectionName];
      const id = collectionName === 'departments' ? 'department-1' :
        collectionName === 'branches' ? 'branch-1' : 'clinic-1';

      it(`lets an admin update a ${label} name`, async () => {
        await assertSucceeds(
          updateDoc(doc(signedIn('admin'), collectionName, id), {
            name: 'Updated Name',
          }),
        );
      });

      for (const role of ['patient', 'doctor']) {
        it(`denies ${actorLabels[role]} updating a ${label} document`, async () => {
          await assertFails(
            updateDoc(doc(signedIn(role), collectionName, id), {
              name: 'Updated Name',
            }),
          );
        });
      }

      it(`denies a signed-out user updating a ${label} document`, async () => {
        await assertFails(
          updateDoc(doc(signedOut(), collectionName, id), {
            name: 'Updated Name',
          }),
        );
      });

      it(`denies an admin updating a ${label} to a blank name`, async () => {
        await assertFails(
          updateDoc(doc(signedIn('admin'), collectionName, id), { name: '  ' }),
        );
      });
    }

    it('denies an admin changing a branch clinicId', async () => {
      await assertFails(
        updateDoc(doc(signedIn('admin'), 'branches', 'branch-1'), {
          clinicId: 'clinic-2',
        }),
      );
    });

    it('denies an admin changing a department branchId', async () => {
      await assertFails(
        updateDoc(doc(signedIn('admin'), 'departments', 'department-1'), {
          branchId: 'branch-2',
        }),
      );
    });

    it('denies an admin updating a branch with invalid working hours', async () => {
      await assertFails(
        updateDoc(doc(signedIn('admin'), 'branches', 'branch-1'), {
          workingHours: { monday: [] },
        }),
      );
    });

    it('denies an admin updating a department to an unknown branch', async () => {
      await assertFails(
        updateDoc(doc(signedIn('admin'), 'departments', 'department-1'), {
          branchId: 'missing-branch',
        }),
      );
    });
  });

  describe('institution deletes', () => {
    for (const collectionName of collections) {
      const label = collectionLabels[collectionName];
      const id = collectionName === 'departments' ? 'department-1' :
        collectionName === 'branches' ? 'branch-1' : 'clinic-1';

      for (const role of actors) {
        it(`denies ${actorLabels[role]} deleting a ${label} document`, async () => {
          await assertFails(deleteDoc(doc(signedIn(role), collectionName, id)));
        });
      }

      it(`denies a signed-out user deleting a ${collectionName} document`, async () => {
        await assertFails(deleteDoc(doc(signedOut(), collectionName, id)));
      });
    }
  });
});
