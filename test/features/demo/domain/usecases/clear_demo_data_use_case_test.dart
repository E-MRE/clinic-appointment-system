import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/usecases/no_params.dart';
import 'package:clinic_appointment_system/features/demo/domain/enums/demo_error_code.dart';
import 'package:clinic_appointment_system/features/demo/domain/models/demo_accounts.dart';
import 'package:clinic_appointment_system/features/demo/domain/usecases/clear_demo_data_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/demo_use_case_fake_dependencies.dart';

void main() {
  test('passes through a successful clear result', () async {
    final dependencies = DemoUseCaseFakeDependencies(
      accountResult: const DataResult.success(
        data: DemoAccounts(
          doctorUid: 'doctor-uid',
          doctorFullName: 'Dr. Servet',
          doctorEmail: 'servet@doktor.com',
          patientUid: 'patient-uid',
          patientFullName: 'Remzi Pala',
          patientEmail: 'remzi@pala.com',
        ),
      ),
    );
    final useCase = ClearDemoDataUseCase(dependencies);

    final result = await useCase.call(const NoParams());

    expect(result.isSuccess, isTrue);
    expect(dependencies.clearCalls, 1);
  });

  test('passes through a clear failure result', () async {
    final dependencies = DemoUseCaseFakeDependencies(
      accountResult: const DataResult.success(
        data: DemoAccounts(
          doctorUid: 'doctor-uid',
          doctorFullName: 'Dr. Servet',
          doctorEmail: 'servet@doktor.com',
          patientUid: 'patient-uid',
          patientFullName: 'Remzi Pala',
          patientEmail: 'remzi@pala.com',
        ),
      ),
      clearResult: const DataResult.error(errorCode: DemoErrorCode.unavailable),
    );
    final useCase = ClearDemoDataUseCase(dependencies);

    final result = await useCase.call(const NoParams());

    expect(result.isNotSuccess, isTrue);
    expect(result.errorCode, DemoErrorCode.unavailable);
    expect(dependencies.clearCalls, 1);
  });
}
