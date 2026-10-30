import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/clinic_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/create_clinic_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/fake_clinic_repository.dart';

void main() {
  test('trims a valid name and returns the repository result', () async {
    final repository = FakeClinicRepository();
    const clinic = Clinic(id: 'c1', name: 'Central');
    const result = DataResult<Clinic>.success(data: clinic);
    repository.createResult = result;
    final useCase = CreateClinicUseCase(repository);

    expect(await useCase(const ClinicDraft(name: '  Central  ')), same(result));
    expect(repository.createdDraft?.name, 'Central');
    expect(repository.createCalls, 1);
  });

  test('rejects a blank name without calling the repository', () async {
    final repository = FakeClinicRepository();
    final useCase = CreateClinicUseCase(repository);

    await expectLater(
      useCase(const ClinicDraft(name: '   ')),
      throwsA(
        isA<InstitutionException>().having(
          (error) => error.code,
          'code',
          InstitutionErrorCode.nameRequired,
        ),
      ),
    );
    expect(repository.createCalls, 0);
  });
}
