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
    specialty: 'Cardiology',
    serviceIds: ['service-1'],
    createdAt: new Date(0),
  },
  technician: {
    role: 'technician',
    fullName: 'Technician',
    email: 'technician@example.com',
    branchId: 'branch-1',
    departmentId: 'department-1',
    serviceIds: ['service-1'],
    createdAt: new Date(0),
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

function newStaff(role = 'doctor', overrides = {}) {
  return { ...profiles[role], createdAt: serverTimestamp(), ...overrides };
}

function withChange(base, change) {
  const data = { ...base, ...change };
  for (const [key, value] of Object.entries(change)) {
    if (value === undefined) delete data[key];
  }
  return data;
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
    await setDoc(doc(db, 'branches', 'branch-1'), { name: 'Branch' });
    await setDoc(doc(db, 'departments', 'department-1'), { branchId: 'branch-1' });
    await setDoc(doc(db, 'departments', 'department-2'), { branchId: 'branch-2' });
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

  for (const role of ['doctor', 'technician']) {
    it(`lets an admin create a valid ${role} profile`, async () => {
      await assertSucceeds(setDoc(doc(signedIn('admin'), 'users', 'staff-new'), newStaff(role)));
    });
  }

  for (const count of [0, 20]) {
    it(`lets an admin create staff with ${count} services`, async () => {
      await assertSucceeds(setDoc(doc(signedIn('admin'), 'users', 'staff-new'),
        newStaff('doctor', { serviceIds: Array(count).fill('service-1') })));
    });
  }

  for (const role of ['patient', 'doctor']) {
    it(`denies ${role} creating staff`, async () => {
      await assertFails(setDoc(doc(signedIn(role), 'users', 'staff-new'), newStaff()));
    });
  }

  it('denies signed-out staff creation', async () => {
    await assertFails(setDoc(doc(env.unauthenticatedContext().firestore(), 'users', 'staff-new'), newStaff()));
  });

  const invalidStaff = {
    'an admin role': { role: 'admin' },
    'a patient role': { role: 'patient' },
    'a missing key': { email: undefined },
    'an extra key': { unknown: true },
    'a missing specialty': { specialty: undefined },
    'a blank specialty': { specialty: '  ' },
    'a blank name': { fullName: '  ' },
    'a malformed email': { email: 'bad@example' },
    'a non-string email': { email: 42 },
    'a blank branch': { branchId: ' ' },
    'a blank department': { departmentId: ' ' },
    'a department from another branch': { departmentId: 'department-2' },
    'a non-existent department': { departmentId: 'missing' },
    'services that are not a list': { serviceIds: 'service-1' },
    '21 services': { serviceIds: Array(21).fill('service-1') },
    'a client-chosen creation time': { createdAt: new Date(0) },
  };
  for (const [label, change] of Object.entries(invalidStaff)) {
    it(`denies an admin creating staff with ${label}`, async () => {
      await assertFails(setDoc(doc(signedIn('admin'), 'users', 'staff-new'),
        withChange(newStaff(), change)));
    });
  }

  it('denies creating a technician with a specialty', async () => {
    await assertFails(setDoc(doc(signedIn('admin'), 'users', 'staff-new'),
      newStaff('technician', { specialty: 'Radiology' })));
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

  it('lets an admin update doctor assignments', async () => {
    await assertSucceeds(updateDoc(doc(signedIn('admin'), 'users', 'doctor'), {
      fullName: 'New Name', specialty: 'Neurology', serviceIds: ['service-2'],
    }));
  });

  it('lets an admin update technician services', async () => {
    await assertSucceeds(updateDoc(doc(signedIn('admin'), 'users', 'technician'), {
      serviceIds: [],
    }));
  });

  const invalidUpdates = {
    role: { role: 'technician' },
    email: { email: 'changed@example.com' },
    branchId: { branchId: 'branch-2' },
    departmentId: { departmentId: 'department-2' },
    createdAt: { createdAt: new Date(1) },
    'an unknown key': { unknown: true },
    'a blank specialty': { specialty: '  ' },
    'a blank name': { fullName: ' ' },
    'services that are not a list': { serviceIds: 'service-1' },
    '21 services': { serviceIds: Array(21).fill('service-1') },
  };
  for (const [label, change] of Object.entries(invalidUpdates)) {
    it(`denies an admin changing doctor ${label}`, async () => {
      await assertFails(updateDoc(doc(signedIn('admin'), 'users', 'doctor'), change));
    });
  }

  it('denies an admin adding a specialty to a technician', async () => {
    await assertFails(updateDoc(doc(signedIn('admin'), 'users', 'technician'), {
      specialty: 'Radiology',
    }));
  });

  for (const field of ['serviceIds', 'specialty']) {
    it(`denies a doctor changing their own ${field}`, async () => {
      const value = field === 'serviceIds' ? ['service-2'] : 'Neurology';
      await assertFails(updateDoc(doc(signedIn('doctor'), 'users', 'doctor'), {
        [field]: value,
      }));
    });
  }

  for (const role of ['doctor', 'patient']) {
    it(`denies ${role} editing another staff profile`, async () => {
      await assertFails(updateDoc(doc(signedIn(role), 'users', 'technician'), {
        serviceIds: ['service-2'],
      }));
    });
  }

  it('denies an admin editing a patient name', async () => {
    await assertFails(updateDoc(doc(signedIn('admin'), 'users', 'patient'), {
      fullName: 'Changed',
    }));
  });

  it('lets an admin change their own name', async () => {
    await assertSucceeds(updateDoc(doc(signedIn('admin'), 'users', 'admin'), {
      fullName: 'Changed',
    }));
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
