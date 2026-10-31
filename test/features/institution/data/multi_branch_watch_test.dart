import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/data/repositories/firestore_department_repository.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../staff_management/data/doubles/mock_collection.dart';
import '../../staff_management/data/doubles/mock_firestore.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late FirestoreDepartmentRepository repository;
  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = FirestoreDepartmentRepository(firestore);
  });

  test('watches two branches, excludes others and sorts by name', () async {
    for (final (String id, String branchId, String name) in [
      ('z', 'b1', 'Zulu'),
      ('a', 'b2', 'Alpha'),
      ('outside', 'b3', 'Other'),
    ]) {
      await firestore.collection('departments').doc(id).set({
        'branchId': branchId,
        'name': name,
      });
    }
    final DataResult<List<Department>> result = await repository
        .watchDepartmentsOfBranches(['b1', 'b2'])
        .first;
    expect(result.isSuccess, isTrue);
    expect(result.data?.map((Department value) => value.id), ['a', 'z']);
  });

  test(
    'empty branch list emits one successful empty list without querying',
    () async {
      final MockFirestore db = MockFirestore();
      final FirestoreDepartmentRepository guarded =
          FirestoreDepartmentRepository(db);
      await expectLater(
        guarded.watchDepartmentsOfBranches([]),
        emitsInOrder([
          isA<DataResult<List<Department>>>()
              .having(
                (DataResult<List<Department>> value) => value.isSuccess,
                'success',
                true,
              )
              .having(
                (DataResult<List<Department>> value) => value.data,
                'data',
                isEmpty,
              ),
          emitsDone,
        ]),
      );
      verifyZeroInteractions(db);
    },
  );

  test('31 branches emit unavailable without querying', () async {
    final MockFirestore db = MockFirestore();
    final FirestoreDepartmentRepository guarded = FirestoreDepartmentRepository(
      db,
    );
    await expectLater(
      guarded.watchDepartmentsOfBranches(
        List<String>.generate(31, (int index) => 'b$index'),
      ),
      emitsInOrder([
        emitsError(
          isA<InstitutionException>().having(
            (InstitutionException error) => error.code,
            'code',
            InstitutionErrorCode.unavailable,
          ),
        ),
        emitsDone,
      ]),
    );
    verifyZeroInteractions(db);
  });

  test('30 branches are accepted', () async {
    final DataResult<List<Department>> result = await repository
        .watchDepartmentsOfBranches(
          List<String>.generate(30, (int index) => 'b$index'),
        )
        .first;
    expect(result.isSuccess, isTrue);
    expect(result.data, isEmpty);
  });

  test('malformed matching document emits invalidRecord', () async {
    await firestore.collection('departments').doc('bad').set({
      'branchId': 'b1',
    });
    await expectLater(
      repository.watchDepartmentsOfBranches(['b1', 'b2']),
      emitsError(
        isA<InstitutionException>().having(
          (InstitutionException error) => error.code,
          'code',
          InstitutionErrorCode.invalidRecord,
        ),
      ),
    );
  });

  test('Firebase query stream error maps to unavailable', () async {
    final MockFirestore db = MockFirestore();
    final MockCollection query = MockCollection();
    when(() => db.collection('departments')).thenReturn(query);
    when(
      () => query.where('branchId', whereIn: ['b1', 'b2']),
    ).thenReturn(query);
    when(() => query.snapshots()).thenAnswer(
      (_) => Stream.error(
        FirebaseException(plugin: 'firestore', code: 'unavailable'),
      ),
    );
    await expectLater(
      FirestoreDepartmentRepository(
        db,
      ).watchDepartmentsOfBranches(['b1', 'b2']),
      emitsError(
        isA<InstitutionException>().having(
          (InstitutionException error) => error.code,
          'code',
          InstitutionErrorCode.unavailable,
        ),
      ),
    );
  });
}
