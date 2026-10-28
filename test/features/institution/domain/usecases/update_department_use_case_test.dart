import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/update_department_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/fake_department_repository.dart';

void main() {
  test('trims the updated name and returns the repository result', () async {
    final repository = FakeDepartmentRepository();
    const updated = Department(id: 'd1', branchId: 'b1', name: 'Cardiology');
    const result = DataResult<Department>.success(data: updated);
    repository.updateResult = result;
    final useCase = UpdateDepartmentUseCase(repository);

    expect(
      await useCase(
        const Department(id: 'd1', branchId: 'b1', name: ' Cardiology '),
      ),
      same(result),
    );
    expect(repository.updatedDepartment?.id, updated.id);
    expect(repository.updatedDepartment?.name, 'Cardiology');
    expect(repository.updateCalls, 1);
  });

  test('rejects a blank name without calling the repository', () async {
    final repository = FakeDepartmentRepository();
    final useCase = UpdateDepartmentUseCase(repository);

    await expectLater(
      useCase(const Department(id: 'd1', branchId: 'b1', name: ' ')),
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
