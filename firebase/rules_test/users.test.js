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
  query,
  serverTimestamp,
  setDoc,
  updateDoc,
  where,
} from 'firebase/firestore';

const rules = readFileSync(
  new URL('../../firestore.rules', import.meta.url),
  'utf8',
);

const profiles = {
  patient: { role: 'patient', fullName: 'Elif Kaya', email: 'patient@example.com' },
  other: { role: 'patient', fullName: 'Ali Demir', email: 'other@example.com' },
  doctor: {
    role: 'doctor',
    fullName: 'Dr. Ayşe Yılmaz',
    email: 'doctor@example.com',
    branchId: 'branch-1',
    departmentId: 'department-1',
  },
  admin: { role: 'admin', fullName: 'Admin', email: 'admin@example.com' },
};

let env;

/** Firestore for a signed-in user whose token carries their profile email. */
function signedIn(uid) {
  return env
    .authenticatedContext(uid, { email: profiles[uid]?.email ?? `${uid}@example.com` })
    .firestore();
}

function newPatient(overrides = {}) {
  return {
    role: 'patient',
    fullName: 'Yeni Hasta',
    email: 'new@example.com',
    createdAt: serverTimestamp(),
    ...overrides,
  };
}

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-clinic',
    firestore: { rules },
  });
});

beforeEach(async () => {
  await env.clearFirestore();
  await env.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    for (const [uid, profile] of Object.entries(profiles)) {
      await setDoc(doc(db, 'users', uid), profile);
    }
  });
});

after(async () => {
  await env.cleanup();
});

describe('users read', () => {
  it('lets a user read their own profile', async () => {
    await assertSucceeds(getDoc(doc(signedIn('patient'), 'users', 'patient')));
  });

  it('lets a user read their own missing profile', async () => {
    await assertSucceeds(getDoc(doc(signedIn('new'), 'users', 'new')));
  });

  it('denies reading another patient', async () => {
    await assertFails(getDoc(doc(signedIn('patient'), 'users', 'other')));
  });

  it('lets signed-in users read staff profiles', async () => {
    await assertSucceeds(getDoc(doc(signedIn('patient'), 'users', 'doctor')));
  });

  it('lets signed-in users list staff profiles', async () => {
    const staff = query(
      collection(signedIn('patient'), 'users'),
      where('role', 'in', ['doctor', 'technician']),
    );
    await assertSucceeds(getDocs(staff));
  });

  it('denies listing every profile to a patient', async () => {
    await assertFails(getDocs(collection(signedIn('patient'), 'users')));
  });

  it('denies signed-out reads', async () => {
    const db = env.unauthenticatedContext().firestore();
    await assertFails(getDoc(doc(db, 'users', 'doctor')));
  });

  it('lets an admin read any profile', async () => {
    await assertSucceeds(getDoc(doc(signedIn('admin'), 'users', 'patient')));
    await assertSucceeds(getDocs(collection(signedIn('admin'), 'users')));
  });
});

describe('users create', () => {
  it('lets a user create their own patient profile', async () => {
    await assertSucceeds(setDoc(doc(signedIn('new'), 'users', 'new'), newPatient()));
  });

  it('denies creating a profile for another user', async () => {
    await assertFails(
      setDoc(doc(signedIn('new'), 'users', 'someone'), newPatient()),
    );
  });

  for (const role of ['doctor', 'technician', 'admin']) {
    it(`denies creating an own ${role} profile`, async () => {
      await assertFails(
        setDoc(doc(signedIn('new'), 'users', 'new'), newPatient({ role })),
      );
    });
  }

  it('denies extra fields', async () => {
    await assertFails(
      setDoc(
        doc(signedIn('new'), 'users', 'new'),
        newPatient({ branchId: 'branch-1' }),
      ),
    );
  });

  it('denies missing fields', async () => {
    const { createdAt, ...withoutCreatedAt } = newPatient();
    await assertFails(
      setDoc(doc(signedIn('new'), 'users', 'new'), withoutCreatedAt),
    );
  });

  it('denies an email other than the signed-in one', async () => {
    await assertFails(
      setDoc(
        doc(signedIn('new'), 'users', 'new'),
        newPatient({ email: 'someone@example.com' }),
      ),
    );
  });

  it('denies a client-chosen creation time', async () => {
    await assertFails(
      setDoc(
        doc(signedIn('new'), 'users', 'new'),
        newPatient({ createdAt: new Date(0) }),
      ),
    );
  });

  it('denies a blank name', async () => {
    await assertFails(
      setDoc(doc(signedIn('new'), 'users', 'new'), newPatient({ fullName: '  ' })),
    );
  });

  it('denies signed-out creation', async () => {
    const db = env.unauthenticatedContext().firestore();
    await assertFails(setDoc(doc(db, 'users', 'new'), newPatient()));
  });

  it('lets an admin create a staff profile', async () => {
    await assertSucceeds(
      setDoc(doc(signedIn('admin'), 'users', 'doctor-2'), {
        ...profiles.doctor,
        email: 'doctor2@example.com',
      }),
    );
  });
});

describe('users update', () => {
  it('lets a user change their own name', async () => {
    await assertSucceeds(
      updateDoc(doc(signedIn('patient'), 'users', 'patient'), {
        fullName: 'Elif Kaya Demir',
      }),
    );
  });

  it('denies a user changing their own role', async () => {
    await assertFails(
      updateDoc(doc(signedIn('patient'), 'users', 'patient'), { role: 'admin' }),
    );
  });

  it('denies a user changing their own email', async () => {
    await assertFails(
      updateDoc(doc(signedIn('patient'), 'users', 'patient'), {
        email: 'changed@example.com',
      }),
    );
  });

  it('denies a blank name', async () => {
    await assertFails(
      updateDoc(doc(signedIn('patient'), 'users', 'patient'), { fullName: '' }),
    );
  });

  it('denies changing another user', async () => {
    await assertFails(
      updateDoc(doc(signedIn('patient'), 'users', 'other'), { fullName: 'X' }),
    );
  });

  it('denies a doctor changing their own role', async () => {
    await assertFails(
      updateDoc(doc(signedIn('doctor'), 'users', 'doctor'), { role: 'admin' }),
    );
  });

  it('lets an admin change a role', async () => {
    await assertSucceeds(
      updateDoc(doc(signedIn('admin'), 'users', 'patient'), { role: 'doctor' }),
    );
  });
});

describe('users delete', () => {
  it('denies a user deleting their own profile', async () => {
    await assertFails(deleteDoc(doc(signedIn('patient'), 'users', 'patient')));
  });

  it('lets an admin delete a profile', async () => {
    await assertSucceeds(deleteDoc(doc(signedIn('admin'), 'users', 'other')));
  });
});

describe('other paths', () => {
  it('denies reads and writes outside matched collections', async () => {
    const db = signedIn('admin');
    await assertFails(getDoc(doc(db, 'appointments', 'a1')));
    await assertFails(setDoc(doc(db, 'appointments', 'a1'), { status: 'x' }));
  });
});
