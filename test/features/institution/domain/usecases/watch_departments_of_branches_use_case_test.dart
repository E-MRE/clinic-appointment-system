import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_of_branches_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/fake_department_repository.dart';

void main() {
  test('forwards all branch ids and the repository stream unchanged', () async {
    final FakeDepartmentRepository repository = FakeDepartmentRepository();
    final List<String> ids = ['b1', 'b2'];
    const DataResult<List<Department>> result = DataResult.success(data: []);
    final Stream<DataResult<List<Department>>> stream = Stream.value(result);
    repository.departmentsStream = stream;
    final WatchDepartmentsOfBranchesUseCase useCase =
        WatchDepartmentsOfBranchesUseCase(repository);
    expect(useCase(ids), same(stream));
    expect(await useCase(ids).single, same(result));
    expect(repository.watchedBranchIds, same(ids));
  });

  test('preserves repository stream errors', () async {
    final FakeDepartmentRepository repository = FakeDepartmentRepository();
    const InstitutionException error = InstitutionException(
      InstitutionErrorCode.unavailable,
    );
    repository.departmentsStream = Stream.error(error);
    await expectLater(
      WatchDepartmentsOfBranchesUseCase(repository)([]),
      emitsError(same(error)),
    );
    expect(repository.watchedBranchIds, isEmpty);
  });
}
