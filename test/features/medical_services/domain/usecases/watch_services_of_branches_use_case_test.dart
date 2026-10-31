import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/watch_services_of_branches_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/fake_medical_service_repository.dart';

void main() {
  test('forwards all branch ids and the repository stream unchanged', () async {
    final FakeMedicalServiceRepository repository =
        FakeMedicalServiceRepository();
    final List<String> ids = ['b1', 'b2'];
    const DataResult<List<MedicalService>> result = DataResult.success(
      data: [],
    );
    final Stream<DataResult<List<MedicalService>>> stream = Stream.value(
      result,
    );
    repository.servicesStream = stream;
    final WatchServicesOfBranchesUseCase useCase =
        WatchServicesOfBranchesUseCase(repository);
    expect(useCase(ids), same(stream));
    expect(await useCase(ids).single, same(result));
    expect(repository.watchedBranchIds, same(ids));
  });

  test('preserves repository stream errors', () async {
    final FakeMedicalServiceRepository repository =
        FakeMedicalServiceRepository();
    const InstitutionException error = InstitutionException(
      InstitutionErrorCode.unavailable,
    );
    repository.servicesStream = Stream.error(error);
    await expectLater(
      WatchServicesOfBranchesUseCase(repository)([]),
      emitsError(same(error)),
    );
    expect(repository.watchedBranchIds, isEmpty);
  });
}
