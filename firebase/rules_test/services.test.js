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
  deleteField,
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

function common(kind) {
  return {
    kind,
    branchId: 'branch-1',
    departmentId: 'department-1',
    name: 'Service',
    durationMinutes: 20,
    feeKurus: 85000,
  };
}

const validServices = {
  examination: () => common('examination'),
  radiology: () => ({
    ...common('radiology'),
    modality: 'ultrasound',
    preparationNote: 'Drink one litre of water.',
  }),
  radiologyWithoutNote: () => ({ ...common('radiology'), modality: 'xRay' }),
  fastingLab: () => ({
    ...common('lab'),
    requiresFasting: true,
    fastingHours: { min: 8, max: 12 },
    resultTime: 'oneDay',
  }),
  lab: () => ({
    ...common('lab'),
    requiresFasting: false,
    resultTime: 'sameDay',
  }),
};

function withChange(base, change) {
  const data = { ...base(), ...change };
  for (const [key, value] of Object.entries(change)) {
    if (value === undefined) delete data[key];
  }
  return data;
}

const invalidServices = {
  'a missing name': withChange(validServices.examination, { name: undefined }),
  'a blank name': withChange(validServices.examination, { name: '   ' }),
  'a missing kind': withChange(validServices.examination, { kind: undefined }),
  'an unknown kind': withChange(validServices.examination, { kind: 'surgery' }),
  'a 4 minute duration': withChange(validServices.examination, { durationMinutes: 4 }),
  'a 241 minute duration': withChange(validServices.examination, { durationMinutes: 241 }),
  'a fractional duration': withChange(validServices.examination, { durationMinutes: 20.5 }),
  'a string duration': withChange(validServices.examination, { durationMinutes: '20' }),
  'a 99 kuruş fee': withChange(validServices.examination, { feeKurus: 99 }),
  'a fee above 100,000 ₺': withChange(validServices.examination, { feeKurus: 10000001 }),
  'a fractional fee': withChange(validServices.examination, { feeKurus: 850.5 }),
  'an extra field': withChange(validServices.examination, { id: 'service-1' }),
  'an examination with a modality': withChange(validServices.examination, { modality: 'mri' }),
  'a missing department': withChange(validServices.examination, { departmentId: 'missing' }),
  'a department of another branch': withChange(validServices.examination, {
    departmentId: 'department-2',
  }),
  'a branch other than the department branch': withChange(validServices.examination, {
    branchId: 'branch-2',
  }),
  'radiology without a modality': withChange(validServices.radiology, { modality: undefined }),
  'an unknown modality': withChange(validServices.radiology, { modality: 'pet' }),
  'a blank preparation note': withChange(validServices.radiology, { preparationNote: '  ' }),
  'a 201 character note': withChange(validServices.radiology, {
    preparationNote: 'a'.repeat(201),
  }),
  'radiology with lab fields': withChange(validServices.radiology, { resultTime: 'oneDay' }),
  'fasting without hours': withChange(validServices.fastingLab, { fastingHours: undefined }),
  'hours without fasting': withChange(validServices.lab, {
    fastingHours: { min: 8, max: 12 },
  }),
  'a non-bool fasting flag': withChange(validServices.lab, { requiresFasting: 'no' }),
  'a missing fasting flag': withChange(validServices.lab, { requiresFasting: undefined }),
  'minimum hours above maximum': withChange(validServices.fastingLab, {
    fastingHours: { min: 12, max: 8 },
  }),
  'zero fasting hours': withChange(validServices.fastingLab, {
    fastingHours: { min: 0, max: 8 },
  }),
  '25 fasting hours': withChange(validServices.fastingLab, {
    fastingHours: { min: 8, max: 25 },
  }),
  'fractional fasting hours': withChange(validServices.fastingLab, {
    fastingHours: { min: 8.5, max: 12 },
  }),
  'extra fasting hour keys': withChange(validServices.fastingLab, {
    fastingHours: { min: 8, max: 12, typical: 10 },
  }),
  'fasting hours as a number': withChange(validServices.fastingLab, { fastingHours: 8 }),
  'an unknown result time': withChange(validServices.lab, { resultTime: 'twoWeeks' }),
  'a missing result time': withChange(validServices.lab, { resultTime: undefined }),
  'a lab test with a modality': withChange(validServices.lab, { modality: 'ct' }),
  'a lab test with a preparation note': withChange(validServices.lab, {
    preparationNote: 'Rest before the test.',
  }),
  'an examination with a fasting flag': withChange(validServices.examination, {
    requiresFasting: false,
  }),
  'a non-string kind': withChange(validServices.examination, { kind: 1 }),
  'a null name': withChange(validServices.examination, { name: null }),
  'a null modality': withChange(validServices.radiology, { modality: null }),
  'a null preparation note': withChange(validServices.radiology, { preparationNote: null }),
  'a non-string preparation note': withChange(validServices.radiology, { preparationNote: 5 }),
  'null fasting hours': withChange(validServices.fastingLab, { fastingHours: null }),
  'fasting hours as a list': withChange(validServices.fastingLab, { fastingHours: [8, 12] }),
  'a fractional maximum fasting hour': withChange(validServices.fastingLab, {
    fastingHours: { min: 8, max: 12.5 },
  }),
};

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-clinic',
    firestore: { rules },
  });
});

after(async () => {
  await env.cleanup();
});

describe('service rules', () => {
  beforeEach(async () => {
    await env.clearFirestore();
    await env.withSecurityRulesDisabled(async (context) => {
      const db = context.firestore();
      for (const [uid, profile] of Object.entries(profiles)) {
        await setDoc(doc(db, 'users', uid), profile);
      }
      await setDoc(doc(db, 'departments', 'department-1'), {
        branchId: 'branch-1',
        name: 'Radiology',
      });
      await setDoc(doc(db, 'departments', 'department-3'), {
        branchId: 'branch-1',
        name: 'Cardiology',
      });
      await setDoc(doc(db, 'departments', 'department-2'), {
        branchId: 'branch-2',
        name: 'Laboratory',
      });
      await setDoc(
        doc(db, 'services', 'service-1'),
        validServices.fastingLab(),
      );
    });
  });

  describe('reads', () => {
    for (const role of Object.keys(profiles)) {
      it(`lets ${role} get and list services`, async () => {
        const db = signedIn(role);
        const snapshot = await assertSucceeds(
          getDoc(doc(db, 'services', 'service-1')),
        );
        assert.equal(snapshot.exists(), true);
        const list = await assertSucceeds(getDocs(collection(db, 'services')));
        assert.equal(list.empty, false);
      });
    }

    it('denies signed-out get and list', async () => {
      const db = signedOut();
      await assertFails(getDoc(doc(db, 'services', 'service-1')));
      await assertFails(getDocs(collection(db, 'services')));
    });
  });

  describe('creates', () => {
    for (const [label, build] of Object.entries(validServices)) {
      it(`lets an admin create a valid ${label} service`, async () => {
        await assertSucceeds(
          setDoc(doc(signedIn('admin'), 'services', 'new-service'), build()),
        );
      });
    }

    for (const role of ['patient', 'doctor']) {
      it(`denies ${role} creating a valid service`, async () => {
        await assertFails(
          setDoc(
            doc(signedIn(role), 'services', 'new-service'),
            validServices.examination(),
          ),
        );
      });
    }

    it('denies a signed-out create', async () => {
      await assertFails(
        setDoc(doc(signedOut(), 'services', 'new-service'),
          validServices.examination()),
      );
    });

    for (const [label, data] of Object.entries(invalidServices)) {
      it(`denies an admin creating a service with ${label}`, async () => {
        await assertFails(
          setDoc(doc(signedIn('admin'), 'services', 'new-service'), data),
        );
      });
    }

    it('accepts boundary values', async () => {
      const db = signedIn('admin');
      await assertSucceeds(setDoc(doc(db, 'services', 'low'), {
        ...validServices.fastingLab(),
        durationMinutes: 5,
        feeKurus: 100,
        fastingHours: { min: 1, max: 1 },
      }));
      await assertSucceeds(setDoc(doc(db, 'services', 'high'), {
        ...validServices.radiology(),
        durationMinutes: 240,
        feeKurus: 10000000,
        preparationNote: 'a'.repeat(200),
      }));
      await assertSucceeds(setDoc(doc(db, 'services', 'day'), {
        ...validServices.fastingLab(),
        fastingHours: { min: 24, max: 24 },
      }));
    });
  });

  describe('updates', () => {
    it('lets an admin change the editable fields', async () => {
      await assertSucceeds(
        updateDoc(doc(signedIn('admin'), 'services', 'service-1'), {
          name: 'Lipid Panel',
          durationMinutes: 10,
          feeKurus: 42000,
          requiresFasting: false,
          fastingHours: deleteField(),
          resultTime: 'twoDays',
        }),
      );
    });

    const fixedFields = {
      kind: 'examination',
      branchId: 'branch-2',
      departmentId: 'department-2',
    };
    for (const [field, value] of Object.entries(fixedFields)) {
      it(`denies changing ${field}`, async () => {
        await assertFails(
          updateDoc(doc(signedIn('admin'), 'services', 'service-1'), {
            [field]: value,
          }),
        );
      });
    }

    it('denies moving a service to another department of its branch', async () => {
      await assertFails(
        updateDoc(doc(signedIn('admin'), 'services', 'service-1'), {
          departmentId: 'department-3',
        }),
      );
    });

    it('denies replacing a lab test with a valid examination', async () => {
      await assertFails(
        setDoc(
          doc(signedIn('admin'), 'services', 'service-1'),
          validServices.examination(),
        ),
      );
    });

    it('denies replacing a lab test with a valid radiology service', async () => {
      await assertFails(
        setDoc(
          doc(signedIn('admin'), 'services', 'service-1'),
          validServices.radiology(),
        ),
      );
    });

    it('lets an admin add fasting hours to a lab test that starts fasting', async () => {
      const db = signedIn('admin');
      await env.withSecurityRulesDisabled(async (context) => {
        await setDoc(
          doc(context.firestore(), 'services', 'service-2'),
          validServices.lab(),
        );
      });
      await assertSucceeds(
        updateDoc(doc(db, 'services', 'service-2'), {
          requiresFasting: true,
          fastingHours: { min: 10, max: 10 },
        }),
      );
    });

    it('denies turning fasting on without hours', async () => {
      await env.withSecurityRulesDisabled(async (context) => {
        await setDoc(
          doc(context.firestore(), 'services', 'service-2'),
          validServices.lab(),
        );
      });
      await assertFails(
        updateDoc(doc(signedIn('admin'), 'services', 'service-2'), {
          requiresFasting: true,
        }),
      );
    });

    it('denies a signed-out update', async () => {
      await assertFails(
        updateDoc(doc(signedOut(), 'services', 'service-1'), { name: 'Changed' }),
      );
    });

    it('denies moving a service to both another branch and department', async () => {
      await assertFails(
        updateDoc(doc(signedIn('admin'), 'services', 'service-1'), {
          branchId: 'branch-2',
          departmentId: 'department-2',
        }),
      );
    });

    it('denies an update that breaks the schema', async () => {
      await assertFails(
        updateDoc(doc(signedIn('admin'), 'services', 'service-1'), {
          fastingHours: deleteField(),
        }),
      );
    });

    for (const role of ['patient', 'doctor']) {
      it(`denies ${role} updating a service`, async () => {
        await assertFails(
          updateDoc(doc(signedIn(role), 'services', 'service-1'), {
            name: 'Changed',
          }),
        );
      });
    }
  });

  describe('deletes', () => {
    for (const role of Object.keys(profiles)) {
      it(`denies ${role} deleting a service`, async () => {
        await assertFails(deleteDoc(doc(signedIn(role), 'services', 'service-1')));
      });
    }

    it('denies a signed-out delete', async () => {
      await assertFails(deleteDoc(doc(signedOut(), 'services', 'service-1')));
    });
  });
});
