import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/repositories/staff_repository.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

final class FakeStaffRepository implements StaffRepository {
  Stream<DataResult<List<Staff>>> staffStream = const Stream.empty();
  DataResult<Staff>? updateResult;
  Staff? createdStaff;
  Staff? updatedStaff;
  int createCalls = 0;
  int updateCalls = 0;
  Object? createException;
  Object? updateException;
  Object? watchException;

  @override
  Stream<DataResult<List<Staff>>> watchStaff() {
    if (watchException case final Object error) {
      throw error;
    }
    return staffStream;
  }

  @override
  Future<DataResult<Staff>> createStaff(Staff staff) async {
    createCalls++;
    if (createException case final Object error) {
      throw error;
    }
    createdStaff = staff;
    return DataResult.success(data: staff);
  }

  @override
  Future<DataResult<Staff>> updateStaff(Staff staff) async {
    updateCalls++;
    if (updateException case final Object error) {
      throw error;
    }
    updatedStaff = staff;
    return updateResult ?? DataResult.success(data: staff);
  }
}
