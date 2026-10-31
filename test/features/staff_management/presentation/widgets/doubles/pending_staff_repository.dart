import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/repositories/staff_repository.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

final class PendingStaffRepository implements StaffRepository {
  PendingStaffRepository(this.delegate);

  final StaffRepository delegate;
  final Completer<void> completion = Completer<void>();

  @override
  Future<DataResult<Staff>> createStaff(Staff staff) async {
    await completion.future;
    return delegate.createStaff(staff);
  }

  @override
  Future<DataResult<Staff>> updateStaff(Staff staff) =>
      delegate.updateStaff(staff);

  @override
  Stream<DataResult<List<Staff>>> watchStaff() => delegate.watchStaff();
}
