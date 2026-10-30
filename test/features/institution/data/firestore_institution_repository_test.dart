import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/data/converters/working_hours_converter.dart';
import 'package:clinic_appointment_system/features/institution/data/repositories/firestore_branch_repository.dart';
import 'package:clinic_appointment_system/features/institution/data/repositories/firestore_clinic_repository.dart';
import 'package:clinic_appointment_system/features/institution/data/repositories/firestore_department_repository.dart';
import 'package:clinic_appointment_system/features/institution/data/repositories/firestore_institution_repository.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/branch_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/clinic_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/department_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFirestore extends Mock implements FirebaseFirestore {}

// ignore: subtype_of_sealed_class
class _MockCollection extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

void main() {
  late FakeFirebaseFirestore firestore;
  late FirestoreClinicRepository clinicRepository;
  late FirestoreBranchRepository branchRepository;
  late FirestoreDepartmentRepository departmentRepository;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    clinicRepository = FirestoreClinicRepository(firestore);
    branchRepository = FirestoreBranchRepository(firestore);
    departmentRepository = FirestoreDepartmentRepository(firestore);
  });

  test('clinic watch emits name-sorted records and later writes', () async {
    await firestore.collection('clinics').doc('z').set({'name': 'Zulu'});
    await firestore.collection('clinics').doc('a').set({'name': 'Alpha'});

    final expectation = expectLater(
      clinicRepository.watchClinics().map(
        (result) => result.data!.map((clinic) => clinic.name).toList(),
      ),
      emitsInOrder([
        ['Alpha', 'Zulu'],
        ['Alpha', 'Beta', 'Zulu'],
      ]),
    );
    await Future<void>.delayed(Duration.zero);
    await firestore.collection('clinics').doc('b').set({'name': 'Beta'});
    await expectation;
  });

  test('branch watch filters by clinic id and sorts by name', () async {
    await firestore.collection('branches').doc('z').set({
      'clinicId': 'clinic-a',
      'name': 'Zulu',
      'address': '200 North Street',
      'workingHours': _closedWeek(),
    });
    await firestore.collection('branches').doc('a').set({
      'clinicId': 'clinic-a',
      'name': 'Alpha',
      'address': '100 Main Street',
      'workingHours': _closedWeek(),
    });
    await firestore.collection('branches').doc('other').set({
      'clinicId': 'clinic-b',
      'name': 'Other Clinic Branch',
      'address': '300 South Street',
      'workingHours': _closedWeek(),
    });

    final result = await branchRepository.watchBranches('clinic-a').first;
    expect(result.data!.map((branch) => branch.name), ['Alpha', 'Zulu']);
    expect(
      result.data!.every((branch) => branch.clinicId == 'clinic-a'),
      isTrue,
    );
  });

  test('department watch filters by branch id and sorts by name', () async {
    await firestore.collection('departments').doc('z').set({
      'branchId': 'branch-a',
      'name': 'Neurology',
    });
    await firestore.collection('departments').doc('a').set({
      'branchId': 'branch-a',
      'name': 'Cardiology',
    });
    await firestore.collection('departments').doc('other').set({
      'branchId': 'branch-b',
      'name': 'Other Branch Department',
    });

    final result = await departmentRepository
        .watchDepartments('branch-a')
        .first;
    expect(result.data!.map((department) => department.name), [
      'Cardiology',
      'Neurology',
    ]);
    expect(
      result.data!.every((department) => department.branchId == 'branch-a'),
      isTrue,
    );
  });

  test(
    'creates each entity with a generated id and exact stored schema',
    () async {
      final clinicResult = await clinicRepository.createClinic(
        const ClinicDraft(name: 'North Clinic'),
      );
      final clinic = clinicResult.data!;
      expect(clinic.id, isNotEmpty);
      expect(
        (await firestore.collection('clinics').doc(clinic.id).get()).data(),
        {'name': 'North Clinic'},
      );

      final hours = WorkingHours.closed();
      final branchResult = await branchRepository.createBranch(
        BranchDraft(
          clinicId: clinic.id,
          name: 'Central Branch',
          address: '100 Main Street',
          workingHours: hours,
        ),
      );
      final branch = branchResult.data!;
      expect(branch.id, isNotEmpty);
      expect(
        (await firestore.collection('branches').doc(branch.id).get()).data(),
        {
          'clinicId': clinic.id,
          'name': 'Central Branch',
          'address': '100 Main Street',
          'workingHours': const WorkingHoursConverter().toJson(hours),
        },
      );

      final departmentResult = await departmentRepository.createDepartment(
        DepartmentDraft(branchId: branch.id, name: 'Cardiology'),
      );
      final department = departmentResult.data!;
      expect(department.id, isNotEmpty);
      expect(
        (await firestore.collection('departments').doc(department.id).get())
            .data(),
        {'branchId': branch.id, 'name': 'Cardiology'},
      );
    },
  );

  test('updates clinic, branch, and department documents', () async {
    await firestore.collection('clinics').doc('clinic-a').set({
      'name': 'Old Clinic Name',
    });
    const clinic = Clinic(id: 'clinic-a', name: 'New Clinic Name');
    expect((await clinicRepository.updateClinic(clinic)).data, same(clinic));
    expect(
      (await firestore.collection('clinics').doc('clinic-a').get()).data(),
      {'name': 'New Clinic Name'},
    );

    await firestore.collection('branches').doc('branch-a').set({
      'clinicId': 'clinic-a',
      'name': 'Old Branch Name',
      'address': '100 Main Street',
      'workingHours': _closedWeek(),
    });
    final branch = Branch(
      id: 'branch-a',
      clinicId: 'clinic-a',
      name: 'New Branch Name',
      address: '200 North Street',
      workingHours: WorkingHours.closed(),
    );
    expect((await branchRepository.updateBranch(branch)).data, same(branch));
    expect(
      (await firestore.collection('branches').doc('branch-a').get()).data(),
      {
        'clinicId': 'clinic-a',
        'name': 'New Branch Name',
        'address': '200 North Street',
        'workingHours': const WorkingHoursConverter().toJson(
          branch.workingHours,
        ),
      },
    );

    await firestore.collection('departments').doc('department-a').set({
      'branchId': 'branch-a',
      'name': 'Old Department Name',
    });
    const department = Department(
      id: 'department-a',
      branchId: 'branch-a',
      name: 'New Department Name',
    );
    expect(
      (await departmentRepository.updateDepartment(department)).data,
      same(department),
    );
    expect(
      (await firestore.collection('departments').doc('department-a').get())
          .data(),
      {'branchId': 'branch-a', 'name': 'New Department Name'},
    );
  });

  test('updating a missing document throws unavailable', () async {
    await expectLater(
      clinicRepository.updateClinic(
        const Clinic(id: 'missing', name: 'Clinic'),
      ),
      throwsA(_institutionError(InstitutionErrorCode.unavailable)),
    );
  });

  for (final (description, malformedHours) in <(String, Map<String, dynamic>)>[
    (
      'overlapping ranges',
      _closedWeek()
        ..['monday'] = [
          {'start': '09:00', 'end': '12:00'},
          {'start': '11:00', 'end': '13:00'},
        ],
    ),
    (
      'inverted ranges',
      _closedWeek()
        ..['monday'] = [
          {'start': '12:00', 'end': '09:00'},
        ],
    ),
    (
      'invalid clock values',
      _closedWeek()
        ..['monday'] = [
          {'start': '9:00', 'end': '17:00'},
        ],
    ),
    (
      'unknown weekday keys',
      _closedWeek()..['holiday'] = <Map<String, String>>[],
    ),
  ]) {
    test(
      'malformed $description emit invalidRecord through the stream',
      () async {
        final malformedFirestore = FakeFirebaseFirestore();
        final malformedRepository = FirestoreBranchRepository(
          malformedFirestore,
        );
        await malformedFirestore.collection('branches').doc('branch-a').set({
          'clinicId': 'clinic-a',
          'name': 'Malformed Branch',
          'address': '100 Main Street',
          'workingHours': malformedHours,
        });

        await expectLater(
          malformedRepository.watchBranches('clinic-a'),
          emitsError(_institutionError(InstitutionErrorCode.invalidRecord)),
        );
      },
    );
  }

  test('Firebase write failures throw unavailable', () async {
    final mockedFirestore = _MockFirestore();
    final collection = _MockCollection();
    when(() => mockedFirestore.collection('clinics')).thenReturn(collection);
    when(() => collection.add(any())).thenThrow(
      FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
    );

    await expectLater(
      FirestoreClinicRepository(
        mockedFirestore,
      ).createClinic(const ClinicDraft(name: 'Clinic')),
      throwsA(_institutionError(InstitutionErrorCode.unavailable)),
    );
  });

  test('unexpected non-parsing stream errors propagate unchanged', () async {
    final unexpectedRepository = _UnexpectedErrorRepository(firestore);
    await firestore.collection('clinics').doc('clinic-a').set({
      'name': 'Central Clinic',
    });

    await expectLater(
      unexpectedRepository.watch(),
      emitsError(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          'unexpected parser failure',
        ),
      ),
    );
  });
}

final class _UnexpectedErrorRepository
    extends FirestoreInstitutionRepository<Clinic, ClinicDraft> {
  const _UnexpectedErrorRepository(super.firestore);

  @override
  String get collectionName => 'clinics';

  @override
  Clinic entityFromJson(Map<String, dynamic> json) {
    throw StateError('unexpected parser failure');
  }

  @override
  Map<String, dynamic> fieldsFromDraft(ClinicDraft draft) {
    return {'name': draft.name};
  }

  @override
  Map<String, dynamic> fieldsFromEntity(Clinic entity) {
    return {'name': entity.name};
  }

  Stream<DataResult<List<Clinic>>> watch() => watchAll();
}

Map<String, dynamic> _closedWeek() {
  return {
    'monday': <Map<String, String>>[],
    'tuesday': <Map<String, String>>[],
    'wednesday': <Map<String, String>>[],
    'thursday': <Map<String, String>>[],
    'friday': <Map<String, String>>[],
    'saturday': <Map<String, String>>[],
    'sunday': <Map<String, String>>[],
  };
}

Matcher _institutionError(InstitutionErrorCode code) {
  return isA<InstitutionException>().having(
    (error) => error.code,
    'code',
    code,
  );
}
