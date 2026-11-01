import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/core/states/watch_state.dart';
import 'package:clinic_appointment_system/features/availability/domain/usecases/watch_staff_service_durations_use_case.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/staff_service_durations_cubit.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../medical_services/domain/doubles/fake_medical_service_repository.dart';
import '../../../staff_management/domain/doubles/staff_fixtures.dart';

void main() {
  const fixtures = StaffFixtures();
  late FakeMedicalServiceRepository repository;
  late StaffServiceDurationsCubit cubit;

  setUp(() {
    repository = FakeMedicalServiceRepository();
    cubit = StaffServiceDurationsCubit(
      WatchStaffServiceDurationsUseCase(repository),
    );
    addTearDown(cubit.close);
  });

  test('watch emits loaded durations of assigned services', () async {
    repository.servicesStream = Stream.value(
      DataResult.success(data: fixtures.services()),
    );
    expect(
      cubit.state,
      const WatchLoading<List<ServiceDuration>, InstitutionErrorCode>(),
    );
    await cubit.watch(fixtures.doctor(serviceIds: ['exam', 'radiology']));
    await Future<void>.delayed(Duration.zero);
    expect(
      cubit.state,
      WatchLoaded<List<ServiceDuration>, InstitutionErrorCode>([
        ServiceDuration(15),
        ServiceDuration(30),
      ]),
    );
  });

  test('maps institution code and falls back to unavailable', () async {
    final cases =
        <(Stream<DataResult<List<MedicalService>>>, InstitutionErrorCode)>[
          (
            Stream.error(
              const InstitutionException(InstitutionErrorCode.invalidRecord),
            ),
            InstitutionErrorCode.invalidRecord,
          ),
          (
            Stream.error(StateError('provider')),
            InstitutionErrorCode.unavailable,
          ),
          (
            Stream.value(const DataResult.error()),
            InstitutionErrorCode.unavailable,
          ),
        ];
    for (final (stream, code) in cases) {
      repository.servicesStream = stream;
      await cubit.watch(fixtures.doctor());
      await Future<void>.delayed(Duration.zero);
      expect(
        cubit.state,
        WatchFailure<List<ServiceDuration>, InstitutionErrorCode>(code),
      );
    }
  });
}
