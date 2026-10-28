import 'package:clinic_appointment_system/features/institution/data/models/department_model.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const department = Department(
    id: 'department-1',
    branchId: 'branch-1',
    name: 'Cardiology',
  );

  test('fromEntity writes exactly the department schema without its id', () {
    expect(DepartmentModel.fromEntity(department).toJson(), {
      'branchId': 'branch-1',
      'name': 'Cardiology',
    });
  });

  test('fromJson rebuilds the department values using the document id', () {
    final restored = DepartmentModel.fromJson({
      'id': 'department-1',
      'branchId': 'branch-1',
      'name': 'Cardiology',
    });

    expect(restored, isA<Department>());
    expect(restored.id, department.id);
    expect(restored.branchId, department.branchId);
    expect(restored.name, department.name);
  });
}
