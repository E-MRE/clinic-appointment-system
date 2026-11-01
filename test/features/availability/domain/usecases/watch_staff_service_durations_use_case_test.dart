import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/availability/domain/usecases/watch_staff_service_durations_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../medical_services/domain/doubles/fake_medical_service_repository.dart';
import '../../../staff_management/domain/doubles/staff_fixtures.dart';

void main() {
  const fixtures = StaffFixtures();
  late FakeMedicalServiceRepository repository;
  late WatchStaffServiceDurationsUseCase useCase;

  setUp(() {
    repository = FakeMedicalServiceRepository();
    useCase = WatchStaffServiceDurationsUseCase(repository);
  });

  test(
    'filters assigned ids, deduplicates 20/20/30 and sorts ascending',
    () async {
      const durations = {
        'long': 30,
        'short-a': 20,
        'short-b': 20,
        'unassigned': 10,
      };
      repository.servicesStream = Stream.value(
        DataResult.success(
          data: [
            for (final entry in durations.entries)
              Examination(
                id: entry.key,
                name: entry.key,
                branchId: 'branch',
                departmentId: 'department',
                duration: ServiceDuration(entry.value),
                fee: Money.minorUnits(1000),
              ),
          ],
        ),
      );
      final result = await useCase(
        fixtures.doctor(serviceIds: ['long', 'short-a', 'short-b', 'missing']),
      ).first;
      expect(repository.watchedBranchId, 'branch');
      expect(result.data, [ServiceDuration(20), ServiceDuration(30)]);
    },
  );

  test('empty services and no assigned ids each emit an empty list', () async {
    repository.servicesStream = Stream.value(
      const DataResult.success(data: []),
    );
    final empty = await useCase(fixtures.doctor(serviceIds: ['missing'])).first;
    expect(empty.isSuccess, isTrue);
    expect(empty.data, isEmpty);
    repository.servicesStream = Stream.value(
      DataResult.success(data: fixtures.services()),
    );
    final unassigned = await useCase(fixtures.doctor()).first;
    expect(unassigned.data, isEmpty);
  });

  test(
    'non-success passes through as error without exposing stale services',
    () async {
      repository.servicesStream = Stream.value(
        DataResult.error(data: fixtures.services(), message: 'unavailable'),
      );
      final result = await useCase(fixtures.doctor(serviceIds: ['exam'])).first;
      expect(result.isNotSuccess, isTrue);
      expect(result.data, isNull);
      expect(result.message, 'unavailable');
    },
  );

  test('null successful data becomes an error', () async {
    repository.servicesStream = Stream.value(
      const DataResult.success(data: null),
    );
    final result = await useCase(fixtures.doctor()).first;
    expect(result.isNotSuccess, isTrue);
  });

  test('preserves provider-independent stream errors', () async {
    const error = InstitutionException(InstitutionErrorCode.invalidRecord);
    repository.servicesStream = Stream<DataResult<List<MedicalService>>>.error(
      error,
    );
    await expectLater(useCase(fixtures.doctor()), emitsError(same(error)));
  });
}
