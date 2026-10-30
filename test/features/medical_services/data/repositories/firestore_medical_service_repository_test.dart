import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/medical_service_model_factory.dart';
import 'package:clinic_appointment_system/features/medical_services/data/repositories/firestore_medical_service_repository.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/lab_test.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/lab_result_time.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/radiology_modality.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/fasting_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFirestore extends Mock implements FirebaseFirestore {}

// ignore: subtype_of_sealed_class
class _MockCollection extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

// ignore: subtype_of_sealed_class
class _MockDocument extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

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

  group('createService', () {
    test(
      'creates examination service, writes frozen fields, and returns entity with id',
      () async {
        final draft = Examination(
          id: MedicalService.unsavedId,
          name: 'General Consultation',
          departmentId: 'dept-1',
          branchId: 'branch-1',
          duration: ServiceDuration(30),
          fee: Money.kurus(60000),
        );

        final result = await repository.createService(draft);
        final created = result.data;

        expect(created, isA<Examination>());
        expect(created?.id, isNotEmpty);
        expect(created?.name, 'General Consultation');

        final snapshot = await firestore
            .collection('services')
            .doc(created?.id)
            .get();
        final data = snapshot.data();

        expect(data, {
          'name': 'General Consultation',
          'departmentId': 'dept-1',
          'branchId': 'branch-1',
          'kind': 'examination',
          'durationMinutes': 30,
          'feeKurus': 60000,
        });
        expect(data?.containsKey('id'), isFalse);
      },
    );

    test(
      'creates radiology service with and without preparation note',
      () async {
        final withNote = RadiologyService(
          id: MedicalService.unsavedId,
          name: 'Chest X-Ray',
          departmentId: 'dept-2',
          branchId: 'branch-1',
          duration: ServiceDuration(15),
          fee: Money.kurus(80000),
          modality: RadiologyModality.xRay,
          preparationNote: 'Remove metallic items.',
        );

        final resultWithNote = await repository.createService(withNote);
        final snapshotWithNote = await firestore
            .collection('services')
            .doc(resultWithNote.data?.id)
            .get();
        expect(snapshotWithNote.data(), {
          'name': 'Chest X-Ray',
          'departmentId': 'dept-2',
          'branchId': 'branch-1',
          'kind': 'radiology',
          'durationMinutes': 15,
          'feeKurus': 80000,
          'modality': 'xRay',
          'preparationNote': 'Remove metallic items.',
        });
        expect(snapshotWithNote.data()?.containsKey('id'), isFalse);

        final noNote = RadiologyService(
          id: MedicalService.unsavedId,
          name: 'Abdominal CT',
          departmentId: 'dept-2',
          branchId: 'branch-1',
          duration: ServiceDuration(25),
          fee: Money.kurus(150000),
          modality: RadiologyModality.ct,
          preparationNote: null,
        );

        final resultNoNote = await repository.createService(noNote);
        final snapshotNoNote = await firestore
            .collection('services')
            .doc(resultNoNote.data?.id)
            .get();
        expect(snapshotNoNote.data(), {
          'name': 'Abdominal CT',
          'departmentId': 'dept-2',
          'branchId': 'branch-1',
          'kind': 'radiology',
          'durationMinutes': 25,
          'feeKurus': 150000,
          'modality': 'ct',
        });
        expect(snapshotNoNote.data()?.containsKey('preparationNote'), isFalse);
        expect(snapshotNoNote.data()?.containsKey('id'), isFalse);
      },
    );

    test('creates lab test with and without fasting', () async {
      final withFasting = LabTest(
        id: MedicalService.unsavedId,
        name: 'Fasting Blood Sugar',
        departmentId: 'dept-3',
        branchId: 'branch-1',
        duration: ServiceDuration(10),
        fee: Money.kurus(25000),
        resultTime: LabResultTime.sameDay,
        fastingHours: FastingHours(min: 8, max: 12),
      );

      final resultWithFasting = await repository.createService(withFasting);
      final snapshotWithFasting = await firestore
          .collection('services')
          .doc(resultWithFasting.data?.id)
          .get();
      expect(snapshotWithFasting.data(), {
        'name': 'Fasting Blood Sugar',
        'departmentId': 'dept-3',
        'branchId': 'branch-1',
        'kind': 'lab',
        'durationMinutes': 10,
        'feeKurus': 25000,
        'resultTime': 'sameDay',
        'fastingHours': {'min': 8, 'max': 12},
        'requiresFasting': true,
      });
      expect(snapshotWithFasting.data()?.containsKey('id'), isFalse);

      final noFasting = LabTest(
        id: MedicalService.unsavedId,
        name: 'Urinalysis',
        departmentId: 'dept-3',
        branchId: 'branch-1',
        duration: ServiceDuration(10),
        fee: Money.kurus(20000),
        resultTime: LabResultTime.oneDay,
        fastingHours: null,
      );

      final resultNoFasting = await repository.createService(noFasting);
      final snapshotNoFasting = await firestore
          .collection('services')
          .doc(resultNoFasting.data?.id)
          .get();
      expect(snapshotNoFasting.data(), {
        'name': 'Urinalysis',
        'departmentId': 'dept-3',
        'branchId': 'branch-1',
        'kind': 'lab',
        'durationMinutes': 10,
        'feeKurus': 20000,
        'resultTime': 'oneDay',
        'requiresFasting': false,
      });
      expect(snapshotNoFasting.data()?.containsKey('fastingHours'), isFalse);
      expect(snapshotNoFasting.data()?['requiresFasting'], isFalse);
      expect(snapshotNoFasting.data()?.containsKey('id'), isFalse);
    });
  });

  group('watchServices', () {
    test(
      'returns only target branch services, sorted by name with matching subclasses',
      () async {
        await firestore.collection('services').doc('svc-1').set({
          'name': 'Z-Ray Chest Imaging',
          'departmentId': 'dept-2',
          'branchId': 'branch-a',
          'kind': 'radiology',
          'durationMinutes': 20,
          'feeKurus': 85000,
          'modality': 'xRay',
        });
        await firestore.collection('services').doc('svc-2').set({
          'name': 'Alpha Consultation',
          'departmentId': 'dept-1',
          'branchId': 'branch-a',
          'kind': 'examination',
          'durationMinutes': 30,
          'feeKurus': 50000,
        });
        await firestore.collection('services').doc('svc-3').set({
          'name': 'Beta Blood Test',
          'departmentId': 'dept-3',
          'branchId': 'branch-a',
          'kind': 'lab',
          'durationMinutes': 10,
          'feeKurus': 30000,
          'resultTime': 'sameDay',
          'requiresFasting': false,
        });
        await firestore.collection('services').doc('svc-other').set({
          'name': 'Other Branch Checkup',
          'departmentId': 'dept-1',
          'branchId': 'branch-b',
          'kind': 'examination',
          'durationMinutes': 20,
          'feeKurus': 50000,
        });

        final streamResult = await repository.watchServices('branch-a').first;
        final services = streamResult.data;

        expect(services, isNotNull);
        expect(services?.length, 3);

        expect(services?.map((service) => service.name).toList(), [
          'Alpha Consultation',
          'Beta Blood Test',
          'Z-Ray Chest Imaging',
        ]);

        final first = services?[0];
        final second = services?[1];
        final third = services?[2];

        expect(first, isA<Examination>());
        expect(first?.kind, MedicalServiceKind.examination);

        expect(second, isA<LabTest>());
        expect(second?.kind, MedicalServiceKind.lab);

        expect(third, isA<RadiologyService>());
        expect(third?.kind, MedicalServiceKind.radiology);

        expect(services?.every((s) => s.branchId == 'branch-a'), isTrue);
      },
    );

    test(
      'malformed stored document emits InstitutionException(invalidRecord)',
      () async {
        await firestore.collection('services').doc('bad-service').set({
          'name': 'Bad Duration Service',
          'departmentId': 'dept-1',
          'branchId': 'branch-a',
          'kind': 'examination',
          'durationMinutes': 3,
          'feeKurus': 50000,
        });

        await expectLater(
          repository.watchServices('branch-a'),
          emitsError(
            isA<InstitutionException>().having(
              (e) => e.code,
              'code',
              InstitutionErrorCode.invalidRecord,
            ),
          ),
        );
      },
    );
  });

  group('updateService', () {
    test('writes updated fields and preserves unchanged structure', () async {
      final initial = Examination(
        id: MedicalService.unsavedId,
        name: 'Initial Checkup',
        departmentId: 'dept-1',
        branchId: 'branch-1',
        duration: ServiceDuration(20),
        fee: Money.kurus(40000),
      );

      final createResult = await repository.createService(initial);
      final createdId = createResult.data?.id ?? '';

      final updated = Examination(
        id: createdId,
        name: 'Updated Checkup',
        departmentId: 'dept-1',
        branchId: 'branch-1',
        duration: ServiceDuration(45),
        fee: Money.kurus(70000),
      );

      final updateResult = await repository.updateService(updated);
      expect(updateResult.data?.name, 'Updated Checkup');
      expect(updateResult.data?.duration.minutes, 45);
      expect(updateResult.data?.fee.kurus, 70000);

      final snapshot = await firestore
          .collection('services')
          .doc(createdId)
          .get();
      final data = snapshot.data();

      expect(data?['name'], 'Updated Checkup');
      expect(data?['durationMinutes'], 45);
      expect(data?['feeKurus'], 70000);
      expect(data?.containsKey('id'), isFalse);
    });

    test('removes fasting hours when a lab test stops fasting', () async {
      await firestore.collection('services').doc('lab-1').set({
        'kind': 'lab',
        'branchId': 'branch-1',
        'departmentId': 'dept-1',
        'name': 'Lipid Panel',
        'durationMinutes': 10,
        'feeKurus': 42000,
        'requiresFasting': true,
        'fastingHours': {'min': 8, 'max': 12},
        'resultTime': 'oneDay',
      });

      await repository.updateService(
        LabTest(
          id: 'lab-1',
          name: 'Lipid Panel',
          departmentId: 'dept-1',
          branchId: 'branch-1',
          duration: ServiceDuration(10),
          fee: Money.kurus(42000),
          resultTime: LabResultTime.oneDay,
        ),
      );

      final data = (await firestore.collection('services').doc('lab-1').get())
          .data();
      expect(data?['requiresFasting'], isFalse);
      expect(data?.containsKey('fastingHours'), isFalse);
      expect(data?.containsKey('preparationNote'), isFalse);
    });

    test('removes a cleared radiology preparation note', () async {
      await firestore.collection('services').doc('xray-1').set({
        'kind': 'radiology',
        'branchId': 'branch-1',
        'departmentId': 'dept-1',
        'name': 'Chest X-ray',
        'durationMinutes': 15,
        'feeKurus': 65000,
        'modality': 'xRay',
        'preparationNote': 'Remove metal items.',
      });

      await repository.updateService(
        RadiologyService(
          id: 'xray-1',
          name: 'Chest X-ray',
          departmentId: 'dept-1',
          branchId: 'branch-1',
          duration: ServiceDuration(15),
          fee: Money.kurus(65000),
          modality: RadiologyModality.xRay,
        ),
      );

      final data = (await firestore.collection('services').doc('xray-1').get())
          .data();
      expect(data?.containsKey('preparationNote'), isFalse);
      expect(data?.containsKey('fastingHours'), isFalse);
      expect(data?['modality'], 'xRay');
    });
  });

  group('FirebaseException handling', () {
    test(
      'create write failure throws InstitutionException(unavailable)',
      () async {
        final mockFirestore = _MockFirestore();
        final mockCollection = _MockCollection();
        when(
          () => mockFirestore.collection('services'),
        ).thenReturn(mockCollection);
        when(() => mockCollection.add(any())).thenThrow(
          FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
        );

        final mockRepo = FirestoreMedicalServiceRepository(
          mockFirestore,
          const MedicalServiceModelFactory(),
        );

        final service = Examination(
          id: MedicalService.unsavedId,
          name: 'Checkup',
          departmentId: 'dept-1',
          branchId: 'branch-1',
          duration: ServiceDuration(20),
          fee: Money.kurus(50000),
        );

        await expectLater(
          mockRepo.createService(service),
          throwsA(
            isA<InstitutionException>().having(
              (e) => e.code,
              'code',
              InstitutionErrorCode.unavailable,
            ),
          ),
        );
      },
    );

    test(
      'update write failure throws InstitutionException(unavailable)',
      () async {
        final mockFirestore = _MockFirestore();
        final mockCollection = _MockCollection();
        final mockDocument = _MockDocument();
        when(
          () => mockFirestore.collection('services'),
        ).thenReturn(mockCollection);
        when(() => mockCollection.doc('svc-1')).thenReturn(mockDocument);
        when(() => mockDocument.update(any())).thenThrow(
          FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
        );

        final mockRepo = FirestoreMedicalServiceRepository(
          mockFirestore,
          const MedicalServiceModelFactory(),
        );

        final service = Examination(
          id: 'svc-1',
          name: 'Checkup',
          departmentId: 'dept-1',
          branchId: 'branch-1',
          duration: ServiceDuration(20),
          fee: Money.kurus(50000),
        );

        await expectLater(
          mockRepo.updateService(service),
          throwsA(
            isA<InstitutionException>().having(
              (e) => e.code,
              'code',
              InstitutionErrorCode.unavailable,
            ),
          ),
        );
      },
    );
  });
}
