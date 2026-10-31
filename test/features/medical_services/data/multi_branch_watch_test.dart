import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/medical_service_model_factory.dart';
import 'package:clinic_appointment_system/features/medical_services/data/repositories/firestore_medical_service_repository.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../staff_management/data/doubles/mock_collection.dart';
import '../../staff_management/data/doubles/mock_firestore.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late FirestoreMedicalServiceRepository repository;
  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = FirestoreMedicalServiceRepository(
      firestore,
      const MedicalServiceModelFactory(),
    );
  });

  test('watches two branches, excludes others and sorts by name', () async {
    for (final (String id, String branchId, String name) in [
      ('z', 'b1', 'Zulu'),
      ('a', 'b2', 'Alpha'),
      ('outside', 'b3', 'Other'),
    ]) {
      await firestore.collection('services').doc(id).set({
        'branchId': branchId,
        'name': name,
        'departmentId': 'd',
        'kind': 'examination',
        'durationMinutes': 30,
        'feeMinorUnits': 50000,
      });
    }
    final DataResult<List<MedicalService>> result = await repository
        .watchServicesOfBranches(['b1', 'b2'])
        .first;
    expect(result.isSuccess, isTrue);
    expect(result.data?.map((MedicalService value) => value.id), ['a', 'z']);
  });

  test(
    'empty branch list emits one successful empty list without querying',
    () async {
      final MockFirestore db = MockFirestore();
      final FirestoreMedicalServiceRepository guarded =
          FirestoreMedicalServiceRepository(
            db,
            const MedicalServiceModelFactory(),
          );
      await expectLater(
        guarded.watchServicesOfBranches([]),
        emitsInOrder([
          isA<DataResult<List<MedicalService>>>()
              .having(
                (DataResult<List<MedicalService>> value) => value.isSuccess,
                'success',
                true,
              )
              .having(
                (DataResult<List<MedicalService>> value) => value.data,
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
    final FirestoreMedicalServiceRepository guarded =
        FirestoreMedicalServiceRepository(
          db,
          const MedicalServiceModelFactory(),
        );
    await expectLater(
      guarded.watchServicesOfBranches(
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
    final DataResult<List<MedicalService>> result = await repository
        .watchServicesOfBranches(
          List<String>.generate(30, (int index) => 'b$index'),
        )
        .first;
    expect(result.isSuccess, isTrue);
    expect(result.data, isEmpty);
  });

  test('malformed matching document emits invalidRecord', () async {
    await firestore.collection('services').doc('bad').set({'branchId': 'b1'});
    await expectLater(
      repository.watchServicesOfBranches(['b1', 'b2']),
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
    when(() => db.collection('services')).thenReturn(query);
    when(
      () => query.where('branchId', whereIn: ['b1', 'b2']),
    ).thenReturn(query);
    when(() => query.snapshots()).thenAnswer(
      (_) => Stream.error(
        FirebaseException(plugin: 'firestore', code: 'unavailable'),
      ),
    );
    await expectLater(
      FirestoreMedicalServiceRepository(
        db,
        const MedicalServiceModelFactory(),
      ).watchServicesOfBranches(['b1', 'b2']),
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
