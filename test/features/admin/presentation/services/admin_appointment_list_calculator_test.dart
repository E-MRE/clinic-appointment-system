import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/admin/presentation/cubit/admin_appointments_state.dart';
import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_status_filter.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_appointment_filter.dart';
import 'package:clinic_appointment_system/features/admin/presentation/services/admin_appointment_list_calculator.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/services/appointment_start_comparator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../appointments/domain/support/appointment_fixture.dart';

void main() {
  const fixture = AppointmentFixture();
  const calculator = AdminAppointmentListCalculator(
    AppointmentStartComparator(),
  );
  final date = fixture.date;

  test('filters, sorts, clamps the page and counts the matching statuses', () {
    final appointments = [
      _appointment(
        fixture,
        id: 'late',
        startMinutes: 700,
        status: AppointmentStatus.pending,
      ),
      for (int index = 10; index >= 0; index--)
        _appointment(
          fixture,
          id: 'pending-${index.toString().padLeft(2, '0')}',
          startMinutes: 540 + index,
          status: AppointmentStatus.pending,
        ),
      _appointment(
        fixture,
        id: 'approved',
        startMinutes: 500,
        status: AppointmentStatus.approved,
      ),
      _appointment(
        fixture,
        id: 'other-branch',
        startMinutes: 480,
        status: AppointmentStatus.pending,
        branchId: 'branch-b',
      ),
    ];
    final filter = AdminAppointmentFilter(
      from: date,
      through: date,
      branchId: 'branch-a',
      statuses: const {AdminStatusFilter.pending},
    );

    final loaded = calculator.calculate(
      filter: filter,
      allAppointmentsInRange: appointments,
      currentPage: 99,
    );

    expect(loaded, isA<AdminAppointmentsLoaded>());
    expect(loaded.allAppointmentsInRange, hasLength(14));
    expect(loaded.filteredAppointments, hasLength(12));
    expect(loaded.filteredAppointments.first.id, 'pending-00');
    expect(loaded.filteredAppointments.last.id, 'late');
    expect(loaded.currentPage, 2);
    expect(loaded.pageCount, 2);
    expect(loaded.currentPageAppointments, hasLength(2));
    expect(loaded.statusCounts[AdminStatusFilter.pending], 12);
    expect(loaded.statusCounts[AdminStatusFilter.approved], 0);
    expect(loaded.statusCounts.keys, AdminStatusFilter.values);
  });

  test('zero-fills all status groups when no appointment matches', () {
    final loaded = calculator.calculate(
      filter: AdminAppointmentFilter(
        from: date,
        through: date,
        statuses: const {AdminStatusFilter.rejected},
      ),
      allAppointmentsInRange: [
        _appointment(
          fixture,
          id: 'pending',
          startMinutes: 600,
          status: AppointmentStatus.pending,
        ),
      ],
      currentPage: 7,
    );

    expect(loaded.filteredAppointments, isEmpty);
    expect(loaded.currentPage, 1);
    expect(loaded.pageCount, 0);
    expect(loaded.rangeLabel, '0–0 / 0');
    expect(loaded.statusCounts.keys, AdminStatusFilter.values);
    expect(loaded.statusCounts.values, everyElement(0));
  });
}

Appointment _appointment(
  AppointmentFixture fixture, {
  required String id,
  required int startMinutes,
  required AppointmentStatus status,
  String branchId = 'branch-a',
}) {
  return Appointment.restore(
    id: id,
    patientId: 'patient',
    patientName: 'Patient',
    staffId: 'staff-a',
    branchId: branchId,
    departmentId: 'department-a',
    serviceId: 'service',
    serviceName: 'Service',
    fee: fixture.fee,
    date: CalendarDate(year: 2026, month: 11, day: 1),
    range: TimeRange(
      start: ClockTime.fromMinutes(startMinutes),
      end: ClockTime.fromMinutes(startMinutes + 30),
    ),
    status: status,
    history: [fixture.change(status)],
  );
}
