import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/fake_department_repository.dart';

void main() {
  test('forwards the branch department stream unchanged', () async {
    final repository = FakeDepartmentRepository();
    const departments = [
      Department(id: 'd1', branchId: 'b1', name: 'Cardiology'),
    ];
    const result = DataResult<List<Department>>.success(data: departments);
    final stream = Stream<DataResult<List<Department>>>.value(result);
    repository.departmentsStream = stream;
    final useCase = WatchDepartmentsUseCase(repository);

    expect(useCase('b1'), same(stream));
    expect(await useCase('b1').single, same(result));
    expect(repository.watchedBranchId, 'b1');
  });
}
