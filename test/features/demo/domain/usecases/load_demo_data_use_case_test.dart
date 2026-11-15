import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/usecases/no_params.dart';
import 'package:clinic_appointment_system/features/demo/domain/enums/demo_error_code.dart';
import 'package:clinic_appointment_system/features/demo/domain/models/demo_accounts.dart';
import 'package:clinic_appointment_system/features/demo/domain/usecases/load_demo_data_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/time/support/fixed_clock.dart';
import '../doubles/demo_use_case_fake_dependencies.dart';

void main() {
  const accounts = DemoAccounts(
    doctorUid: 'doctor-uid',
    doctorFullName: 'Dr. Servet',
    doctorEmail: 'servet@doktor.com',
    patientUid: 'patient-uid',
    patientFullName: 'Remzi Pala',
    patientEmail: 'remzi@pala.com',
  );

  test(
    'resolves, builds relative to the clock, and replaces the scenario',
    () async {
      final dependencies = DemoUseCaseFakeDependencies(
        accountResult: const DataResult.success(data: accounts),
      );
      final useCase = LoadDemoDataUseCase(
        dependencies,
        dependencies,
        FixedClock(DateTime(2026, 11, 15, 12)),
      );

      final result = await useCase.call(const NoParams());

      expect(result.isSuccess, isTrue);
      expect(dependencies.resolveCalls, 1);
      expect(dependencies.replaceCalls, 1);
      expect(
        dependencies.replacedDataSet?.referenceDate,
        CalendarDate(year: 2026, month: 11, day: 15),
      );
      expect(dependencies.replacedDataSet?.staff.first.id, accounts.doctorUid);
    },
  );

  test(
    'returns account resolution error without replacing any records',
    () async {
      final dependencies = DemoUseCaseFakeDependencies(
        accountResult: const DataResult.error(
          errorCode: DemoErrorCode.patientAccountMissing,
        ),
      );
      final useCase = LoadDemoDataUseCase(
        dependencies,
        dependencies,
        FixedClock(DateTime(2026, 11, 15)),
      );

      final result = await useCase.call(const NoParams());

      expect(result.isNotSuccess, isTrue);
      expect(result.errorCode, DemoErrorCode.patientAccountMissing);
      expect(dependencies.replaceCalls, 0);
    },
  );
}
