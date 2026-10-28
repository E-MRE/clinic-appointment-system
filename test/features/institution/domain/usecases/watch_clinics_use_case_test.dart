import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/usecases/no_params.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_clinics_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/fake_clinic_repository.dart';

void main() {
  test('forwards the clinic stream unchanged', () async {
    final repository = FakeClinicRepository();
    final clinics = [const Clinic(id: 'c1', name: 'Central')];
    final result = DataResult<List<Clinic>>.success(data: clinics);
    final stream = Stream<DataResult<List<Clinic>>>.value(result);
    repository.clinicsStream = stream;
    final useCase = WatchClinicsUseCase(repository);

    expect(useCase(const NoParams()), same(stream));
    expect(await useCase(const NoParams()).single, same(result));
  });
}
