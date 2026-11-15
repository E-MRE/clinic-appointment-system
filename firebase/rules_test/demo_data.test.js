import { readFileSync } from 'node:fs';
import { assertFails, assertSucceeds, initializeTestEnvironment } from '@firebase/rules-unit-testing';
import { deleteDoc, doc, serverTimestamp, setDoc, updateDoc, writeBatch } from 'firebase/firestore';

const rules = readFileSync(new URL('../../firestore.rules', import.meta.url), 'utf8');
const profileData = {
  admin: { role: 'admin', fullName: 'Admin', email: 'admin@example.com' },
  patient: { role: 'patient', fullName: 'Real Patient', email: 'patient@example.com' },
  doctor: {
    role: 'doctor', fullName: 'Real Doctor', email: 'doctor@example.com',
    branchId: 'branch-1', departmentId: 'department-1', specialty: 'Cardiology',
    serviceIds: ['service-1'], createdAt: new Date(0),
  },
  'demo-patient': {
    role: 'patient', fullName: 'Demo Patient', email: 'demo-patient@example.com',
    createdAt: new Date(0), isDemo: true,
  },
  'demo-doctor': {
    role: 'doctor', fullName: 'Demo Doctor', email: 'demo-doctor@example.com',
    branchId: 'branch-1', departmentId: 'department-1', specialty: 'Cardiology',
    serviceIds: ['service-1'], createdAt: new Date(0), isDemo: true,
  },
  'demo-new-doctor': {
    role: 'doctor', fullName: 'New Demo Doctor', email: 'new-demo-doctor@example.com',
    branchId: 'branch-1', departmentId: 'department-1', specialty: 'Cardiology',
    serviceIds: ['service-1'], createdAt: new Date(0), isDemo: true,
  },
};

const weekdays = {
  monday: [], tuesday: [], wednesday: [], thursday: [],
  friday: [], saturday: [], sunday: [],
};

function demoPatient(overrides = {}) {
  return {
    role: 'patient', fullName: 'Demo Patient', email: 'demo@example.com',
    createdAt: serverTimestamp(), isDemo: true, ...overrides,
  };
}

function demoDoctor(overrides = {}) {
  return {
    role: 'doctor', fullName: 'Demo Doctor', email: 'demo-doctor@example.com',
    branchId: 'branch-1', departmentId: 'department-1', serviceIds: ['service-1'],
    specialty: 'Cardiology', createdAt: serverTimestamp(), isDemo: true, ...overrides,
  };
}

function demoAvailability(overrides = {}) {
  return {
    branchId: 'branch-1', weekly: weekdays, oneOff: [],
    updatedAt: serverTimestamp(), isDemo: true, ...overrides,
  };
}

function demoProjection(overrides = {}) {
  return {
    slots: [{ appointmentId: 'demo-appointment', start: '10:00', end: '10:30' }],
    lastAppointmentId: 'demo-appointment',
    updatedAt: serverTimestamp(),
    isDemo: true,
    ...overrides,
  };
}

function demoAppointment(overrides = {}) {
  return {
    patientId: 'demo-patient', patientName: 'Demo Patient', staffId: 'demo-doctor',
    branchId: 'branch-1', departmentId: 'department-1', serviceId: 'service-1',
    serviceName: 'Consultation', feeMinorUnits: 100, date: '2026-12-01',
    start: '10:00', end: '10:30', status: 'completed',
    history: [{
      status: 'completed', byUserId: 'demo-doctor', byRole: 'doctor', at: new Date(0),
    }],
    createdAt: new Date(0), updatedAt: new Date(0), isDemo: true, ...overrides,
  };
}

function clinic(overrides = {}) {
  return { name: 'Demo Clinic', isDemo: true, ...overrides };
}

function branch(overrides = {}) {
  return {
    clinicId: 'clinic-1', name: 'Demo Branch', address: '1 Main Street',
    workingHours: weekdays, isDemo: true, ...overrides,
  };
}

function department(overrides = {}) {
  return { branchId: 'branch-1', name: 'Demo Department', isDemo: true, ...overrides };
}

function service(overrides = {}) {
  return {
    kind: 'examination', branchId: 'branch-1', departmentId: 'department-1',
    name: 'Demo Consultation', durationMinutes: 30, feeMinorUnits: 100,
    isDemo: true, ...overrides,
  };
}

const demoSpecs = [
  { name: 'clinics', baseId: 'demo-clinic', createId: 'demo-new-clinic', data: clinic },
  { name: 'branches', baseId: 'demo-branch', createId: 'demo-new-branch', data: branch },
  { name: 'departments', baseId: 'demo-department', createId: 'demo-new-department', data: department },
  { name: 'services', baseId: 'demo-service', createId: 'demo-new-service', data: service },
  { name: 'users', baseId: 'demo-extra-patient', createId: 'demo-new-patient', data: demoPatient },
  {
    name: 'staffAvailability', baseId: 'demo-doctor', createId: 'demo-new-doctor',
    data: demoAvailability,
  },
  {
    name: 'appointments', baseId: 'demo-appointment', createId: 'demo-new-appointment',
    data: demoAppointment,
  },
];
const institutionDocumentIds = {
  clinics: 'clinic-1',
  branches: 'branch-1',
  departments: 'department-1',
  services: 'service-1',
};

let env;
function signedIn(uid) { return env.authenticatedContext(uid).firestore(); }
function reference(db, collection, id) { return doc(db, collection, id); }
function bookingDayReference(db, collection, ownerId, date) {
  return doc(db, collection, ownerId, 'days', date);
}

async function seedFixtures() {
  await env.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    for (const [uid, profile] of Object.entries(profileData)) {
      await setDoc(reference(db, 'users', uid), profile);
    }
    await setDoc(reference(db, 'users', 'demo-extra-patient'), demoPatient({
      createdAt: new Date(0),
    }));
    await setDoc(reference(db, 'clinics', 'clinic-1'), { name: 'Main Clinic' });
    await setDoc(reference(db, 'branches', 'branch-1'), {
      clinicId: 'clinic-1', name: 'Main Branch', address: '1 Main Street',
      workingHours: weekdays,
    });
    await setDoc(reference(db, 'departments', 'department-1'), {
      branchId: 'branch-1', name: 'General Medicine',
    });
    await setDoc(reference(db, 'branches', 'branch-2'), {
      clinicId: 'clinic-1', name: 'Second Branch', address: '2 Main Street',
      workingHours: weekdays,
    });
    await setDoc(reference(db, 'departments', 'department-2'), {
      branchId: 'branch-2', name: 'Second Department',
    });
    await setDoc(reference(db, 'services', 'service-1'), {
      kind: 'examination', branchId: 'branch-1', departmentId: 'department-1',
      name: 'Real Consultation', durationMinutes: 30, feeMinorUnits: 100,
    });
    await setDoc(reference(db, 'staffAvailability', 'doctor'), {
      branchId: 'branch-1', weekly: weekdays, oneOff: [], updatedAt: new Date(0),
    });
    for (const spec of demoSpecs) {
      const data = spec.data();
      if (spec.name === 'users') data.createdAt = new Date(0);
      if (spec.name === 'staffAvailability') data.updatedAt = new Date(0);
      await setDoc(reference(db, spec.name, spec.baseId), data);
    }
    await setDoc(
      bookingDayReference(db, 'staffBookings', 'demo-doctor', '2026-12-01'),
      demoProjection(),
    );
    await setDoc(
      bookingDayReference(db, 'patientBookings', 'demo-patient', '2026-12-01'),
      demoProjection(),
    );
    const realProjection = demoProjection();
    delete realProjection.isDemo;
    await setDoc(
      bookingDayReference(db, 'patientBookings', 'patient', '2026-12-01'),
      realProjection,
    );
  });
}

describe('demo data rules', () => {
before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-clinic', firestore: { rules },
  });
});

beforeEach(async () => {
  await env.clearFirestore();
  await seedFixtures();
});

after(async () => { await env.cleanup(); });

describe('admin demo-data writes', () => {
  for (const spec of demoSpecs) {
    it(`lets an admin create a demo ${spec.name} document`, async () => {
      const db = signedIn('admin');
      const data = spec.name === 'users' ? demoPatient() : spec.data();
      await assertSucceeds(setDoc(reference(db, spec.name, spec.createId), data));
    });

    it(`lets an admin update a demo ${spec.name} document`, async () => {
      const db = signedIn('admin');
      const data = spec.name === 'users'
        ? demoPatient({ fullName: 'Updated Demo Patient' })
        : spec.data();
      await assertSucceeds(setDoc(reference(db, spec.name, spec.baseId), data));
    });

    it(`lets an admin delete a demo ${spec.name} document`, async () => {
      await assertSucceeds(deleteDoc(
        reference(signedIn('admin'), spec.name, spec.baseId),
      ));
    });
  }

  it('lets an admin create a demo staff profile without an Auth account', async () => {
    await assertSucceeds(setDoc(
      reference(signedIn('admin'), 'users', 'demo-created-doctor'),
      demoDoctor(),
    ));
  });

  it('lets an admin update a demo staff profile', async () => {
    await assertSucceeds(setDoc(
      reference(signedIn('admin'), 'users', 'demo-doctor'),
      demoDoctor({ fullName: 'Updated Demo Doctor' }),
    ));
  });

  it('lets an admin delete a demo staff profile', async () => {
    await assertSucceeds(deleteDoc(
      reference(signedIn('admin'), 'users', 'demo-doctor'),
    ));
  });

  it('lets an admin batch-write related demo records and appointments', async () => {
    const db = signedIn('admin');
    const batch = writeBatch(db);
    const batchDoctorId = 'demo-batch-doctor';
    const batchPatientId = 'demo-batch-patient';
    const batchBranchId = 'demo-batch-branch';
    const batchDepartmentId = 'demo-batch-department';
    const batchServiceId = 'demo-batch-service';
    batch.set(reference(db, 'clinics', 'demo-batch-clinic'), clinic());
    batch.set(reference(db, 'branches', batchBranchId), branch({
      clinicId: 'demo-batch-clinic',
    }));
    batch.set(reference(db, 'departments', batchDepartmentId), department({
      branchId: batchBranchId,
    }));
    batch.set(reference(db, 'services', batchServiceId), service({
      branchId: batchBranchId, departmentId: batchDepartmentId,
    }));
    batch.set(reference(db, 'users', batchDoctorId), demoDoctor({
      branchId: batchBranchId, departmentId: batchDepartmentId,
    }));
    batch.set(reference(db, 'users', batchPatientId), demoPatient());
    batch.set(reference(db, 'staffAvailability', batchDoctorId), demoAvailability({
      branchId: batchBranchId,
    }));
    batch.set(reference(db, 'appointments', 'demo-batch-appointment'), demoAppointment({
      patientId: batchPatientId, staffId: batchDoctorId,
      branchId: batchBranchId, departmentId: batchDepartmentId,
      serviceId: batchServiceId,
    }));
    batch.set(
      bookingDayReference(db, 'staffBookings', batchDoctorId, '2026-12-01'),
      demoProjection({
        slots: [{
          appointmentId: 'demo-batch-appointment', start: '10:00', end: '10:30',
        }],
        lastAppointmentId: 'demo-batch-appointment',
      }),
    );
    batch.set(
      bookingDayReference(db, 'patientBookings', batchPatientId, '2026-12-01'),
      demoProjection({
        slots: [{
          appointmentId: 'demo-batch-appointment', start: '10:00', end: '10:30',
        }],
        lastAppointmentId: 'demo-batch-appointment',
      }),
    );
    await assertSucceeds(batch.commit());
  });
});

for (const collection of ['clinics', 'branches', 'departments', 'services']) {
  it(`lets an admin delete a non-demo ${collection} document`, async () => {
    await assertSucceeds(deleteDoc(
      reference(signedIn('admin'), collection, institutionDocumentIds[collection]),
    ));
  });

  it(`denies a non-admin deleting a non-demo ${collection} document`, async () => {
    await assertFails(deleteDoc(reference(
      signedIn('patient'), collection, institutionDocumentIds[collection],
    )));
  });
}

it('lets an admin update the linked doctor assignment and availability together', async () => {
  const db = signedIn('admin');
  const batch = writeBatch(db);
  batch.update(reference(db, 'users', 'doctor'), {
    branchId: 'branch-2', departmentId: 'department-2', serviceIds: ['service-2'],
  });
  batch.update(reference(db, 'staffAvailability', 'doctor'), {
    branchId: 'branch-2', weekly: weekdays, oneOff: [], updatedAt: serverTimestamp(),
  });
  await assertSucceeds(batch.commit());
});

it('keeps linked doctor profile updates limited to assignment fields', async () => {
  await assertFails(updateDoc(
    reference(signedIn('admin'), 'users', 'doctor'),
    { email: 'replacement@example.com' },
  ));
});

for (const [collection, ownerId] of [
  ['staffBookings', 'demo-doctor'],
  ['patientBookings', 'demo-patient'],
]) {
  it(`lets an admin create, update, and delete a demo ${collection} projection`, async () => {
    const projection = bookingDayReference(
      signedIn('admin'), collection, ownerId, '2026-12-01',
    );
    await env.withSecurityRulesDisabled(async (context) => {
      await deleteDoc(bookingDayReference(
        context.firestore(), collection, ownerId, '2026-12-01',
      ));
    });
    await assertSucceeds(setDoc(projection, demoProjection()));
    await assertSucceeds(updateDoc(projection, { updatedAt: serverTimestamp() }));
    await assertSucceeds(deleteDoc(projection));
  });

  it(`denies non-admin create, update, and delete of a demo ${collection} projection`, async () => {
    await env.withSecurityRulesDisabled(async (context) => {
      await deleteDoc(bookingDayReference(
        context.firestore(), collection, ownerId, '2026-12-01',
      ));
    });
    const db = signedIn('patient');
    const patientProjection = bookingDayReference(
      db, collection, ownerId, '2026-12-01',
    );
    await assertFails(setDoc(patientProjection, demoProjection()));
    await env.withSecurityRulesDisabled(async (context) => {
      await setDoc(bookingDayReference(
        context.firestore(), collection, ownerId, '2026-12-01',
      ), demoProjection());
    });
    await assertFails(updateDoc(patientProjection, { updatedAt: serverTimestamp() }));
    await assertFails(deleteDoc(patientProjection));
  });
}

it('denies an admin deleting a non-demo booking projection', async () => {
  await assertFails(deleteDoc(bookingDayReference(
    signedIn('admin'), 'patientBookings', 'patient', '2026-12-01',
  )));
});

describe('non-admin demo-data writes', () => {
  for (const [role, uid] of [['patient', 'patient'], ['staff', 'demo-doctor']]) {
    for (const spec of demoSpecs) {
      it(`denies ${role} creating, updating, or deleting demo ${spec.name}`, async () => {
        const db = signedIn(uid);
        const createData = spec.name === 'users' ? demoPatient() : spec.data();
        const createId = spec.name === 'staffAvailability' && role === 'staff'
          ? 'demo-new-doctor'
          : `demo-${role}-new`;
        const targetId = spec.name === 'users'
          ? (role === 'staff' ? 'demo-doctor' : 'demo-patient')
          : spec.baseId;
        await assertFails(setDoc(
          reference(db, spec.name, createId), createData,
        ));
        if (spec.name === 'users') {
          await assertFails(setDoc(
            reference(db, 'users', 'demo-new-staff'), demoDoctor(),
          ));
        }
        await assertFails(updateDoc(
          reference(db, spec.name, targetId), { isDemo: true },
        ));
        await assertFails(deleteDoc(reference(db, spec.name, targetId)));
      });
    }
  }
});

describe('demo marker cannot be added to existing real data', () => {
  for (const spec of demoSpecs) {
    it(`denies an admin changing a non-demo ${spec.name} document to demo`, async () => {
      await env.withSecurityRulesDisabled(async (context) => {
        const db = context.firestore();
        const data = spec.name === 'users'
          ? demoPatient({ fullName: 'Real Patient', email: 'real@example.com', createdAt: new Date(0) })
          : spec.data();
        delete data.isDemo;
        await setDoc(reference(db, spec.name, 'real-record'), data);
      });
      await assertFails(updateDoc(
        reference(signedIn('admin'), spec.name, 'real-record'), { isDemo: true },
      ));
    });
  }
});

it('denies an admin deleting a non-demo appointment', async () => {
  await env.withSecurityRulesDisabled(async (context) => {
    const appointment = demoAppointment();
    delete appointment.isDemo;
    await setDoc(reference(context.firestore(), 'appointments', 'real-appointment'), appointment);
  });
  await assertFails(deleteDoc(
    reference(signedIn('admin'), 'appointments', 'real-appointment'),
  ));
});
});
