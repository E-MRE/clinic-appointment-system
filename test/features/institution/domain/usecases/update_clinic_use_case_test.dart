import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/update_clinic_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/fake_clinic_repository.dart';

void main() {
  test('trims the updated name and returns the repository result', () async {
    final repository = FakeClinicRepository();
    const updated = Clinic(id: 'c1', name: 'Central');
    const result = DataResult<Clinic>.success(data: updated);
    repository.updateResult = result;
    final useCase = UpdateClinicUseCase(repository);

    expect(
      await useCase(const Clinic(id: 'c1', name: '  Central  ')),
      same(result),
    );
    expect(repository.updatedClinic?.id, updated.id);
    expect(repository.updatedClinic?.name, 'Central');
    expect(repository.updateCalls, 1);
  });

  test('rejects a blank name without calling the repository', () async {
    final repository = FakeClinicRepository();
    final useCase = UpdateClinicUseCase(repository);

    await expectLater(
      useCase(const Clinic(id: 'c1', name: '  ')),
      throwsA(
        isA<InstitutionException>().having(
          (error) => error.code,
          'code',
          InstitutionErrorCode.nameRequired,
        ),
      ),
    );
    expect(repository.updateCalls, 0);
  });
}
