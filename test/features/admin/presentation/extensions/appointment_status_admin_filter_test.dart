import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_status_filter.dart';
import 'package:clinic_appointment_system/features/admin/presentation/extensions/appointment_status_admin_filter.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every status maps to one group; both cancellations share one', () {
    const expected = {
      AppointmentStatus.pending: AdminStatusFilter.pending,
      AppointmentStatus.approved: AdminStatusFilter.approved,
      AppointmentStatus.rejected: AdminStatusFilter.rejected,
      AppointmentStatus.completed: AdminStatusFilter.completed,
      AppointmentStatus.noShow: AdminStatusFilter.noShow,
      AppointmentStatus.cancelledByPatient: AdminStatusFilter.cancelled,
      AppointmentStatus.cancelledByStaff: AdminStatusFilter.cancelled,
    };
    for (final status in AppointmentStatus.values) {
      expect(status.adminFilter, expected[status], reason: status.name);
    }
  });
}
