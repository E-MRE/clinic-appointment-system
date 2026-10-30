import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/department_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/create_department_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/fake_department_repository.dart';

void main() {
  test('trims a valid name and returns the repository result', () async {
    final repository = FakeDepartmentRepository();
    const department = Department(id: 'd1', branchId: 'b1', name: 'Cardiology');
    const result = DataResult<Department>.success(data: department);
    repository.createResult = result;
    final useCase = CreateDepartmentUseCase(repository);

    expect(
      await useCase(
        const DepartmentDraft(branchId: 'b1', name: '  Cardiology  '),
      ),
      same(result),
    );
    expect(repository.createdDraft?.name, 'Cardiology');
    expect(repository.createdDraft?.branchId, 'b1');
    expect(repository.createCalls, 1);
  });

  test('rejects a blank name without calling the repository', () async {
    final repository = FakeDepartmentRepository();
    final useCase = CreateDepartmentUseCase(repository);

    await expectLater(
      useCase(const DepartmentDraft(branchId: 'b1', name: '  ')),
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
