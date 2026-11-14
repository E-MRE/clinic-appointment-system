import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_status_filter.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_dashboard_summary.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/admin_dashboard_fixture.dart';

void main() {
  const fixture = AdminDashboardFixture();

  final todaysAppointments = [
    fixture.appointment(
      id: 'complete-a',
      status: AppointmentStatus.completed,
      staffId: 'staff-z',
    ),
    fixture.appointment(
      id: 'approved-a',
      status: AppointmentStatus.approved,
      departmentId: 'department-b',
      staffId: 'staff-a',
      branchId: 'branch-b',
    ),
    fixture.appointment(id: 'pending-a', status: AppointmentStatus.pending),
    fixture.appointment(
      id: 'no-show-b',
      status: AppointmentStatus.noShow,
      departmentId: 'department-b',
      staffId: 'staff-b',
      branchId: 'branch-b',
    ),
    fixture.appointment(
      id: 'cancel-patient-b',
      status: AppointmentStatus.cancelledByPatient,
      departmentId: 'department-b',
      staffId: 'staff-b',
      branchId: 'branch-b',
    ),
    fixture.appointment(
      id: 'cancel-staff-a',
      status: AppointmentStatus.cancelledByStaff,
      staffId: 'staff-a',
    ),
    fixture.appointment(
      id: 'rejected-b',
      status: AppointmentStatus.rejected,
      departmentId: 'department-b',
      staffId: 'staff-b',
      branchId: 'branch-b',
    ),
    fixture.appointment(
      id: 'not-today',
      status: AppointmentStatus.completed,
      date: DateTime(2026, 11, 13),
    ),
  ];

  final pendingAppointments = [
    fixture.appointment(
      id: 'pending-today',
      status: AppointmentStatus.pending,
      startMinutes: 17 * 60,
      createdAt: DateTime(2026, 11, 14, 8),
    ),
    fixture.appointment(
      id: 'pending-tomorrow-late',
      status: AppointmentStatus.pending,
      date: DateTime(2026, 11, 15),
      startMinutes: 11 * 60,
      createdAt: DateTime(2026, 11, 13, 18),
    ),
    fixture.appointment(
      id: 'pending-tomorrow-early',
      status: AppointmentStatus.pending,
      date: DateTime(2026, 11, 15),
      startMinutes: 9 * 60,
      createdAt: DateTime(2026, 11, 13, 19),
    ),
    fixture.appointment(
      id: 'pending-past',
      status: AppointmentStatus.pending,
      date: DateTime(2026, 11, 13),
      createdAt: DateTime(2026, 11, 12, 12),
    ),
    fixture.appointment(
      id: 'rejected-future',
      status: AppointmentStatus.rejected,
      date: DateTime(2026, 11, 15),
    ),
    fixture.appointment(
      id: 'pending-other-branch',
      status: AppointmentStatus.pending,
      date: DateTime(2026, 11, 16),
      branchId: 'branch-b',
      departmentId: 'department-b',
      staffId: 'staff-b',
      createdAt: DateTime(2026, 11, 13, 17),
    ),
  ];

  test('computes all unfiltered today and pending figures', () {
    final summary = AdminDashboardSummary.fromAppointments(
      todayAppointments: todaysAppointments,
      pendingAppointments: pendingAppointments,
      today: fixture.calendarDay,
      catalog: fixture.catalog,
    );

    expect(summary.todayAppointmentCount, 7);
    expect(summary.distinctBranchCount, 2);
    expect(summary.distinctStaffCount, 3);
    expect(summary.pendingCount, 4);
    expect(summary.oldestPendingCreatedAt, DateTime(2026, 11, 13, 17));
    expect(summary.completedCount, 1);
    expect(summary.noShowCount, 1);
    expect(
      summary.statusCounts.map((row) => (row.status, row.count)).toList(),
      [
        (AdminStatusFilter.completed, 1),
        (AdminStatusFilter.approved, 1),
        (AdminStatusFilter.pending, 1),
        (AdminStatusFilter.noShow, 1),
        (AdminStatusFilter.cancelled, 2),
        (AdminStatusFilter.rejected, 1),
      ],
    );
    expect(
      summary.departmentRows.map((row) => (row.name, row.count)).toList(),
      [('Neurology', 4), ('Cardiology', 3)],
    );
    expect(
      summary.departmentRows.map((row) => row.fractionOfMaximum).toList(),
      [1, 0.75],
    );
    expect(
      summary.staffRows
          .map((row) => (row.fullName, row.caption, row.count))
          .toList(),
      [
        ('Burak Kaya', 'Neurology · South Branch', 3),
        ('Ali Demir', 'Cardiology · North Branch', 2),
        ('Zeynep Aydın', 'Cardiology · North Branch', 2),
      ],
    );
    expect(summary.staffRows.map((row) => row.fractionOfMaximum).toList(), [
      1,
      2 / 3,
      2 / 3,
    ]);
    expect(summary.pendingAppointments.map((appointment) => appointment.id), [
      'pending-today',
      'pending-tomorrow-early',
      'pending-tomorrow-late',
      'pending-other-branch',
    ]);
  });

  test('filters every figure to the selected branch', () {
    final summary = AdminDashboardSummary.fromAppointments(
      todayAppointments: todaysAppointments,
      pendingAppointments: pendingAppointments,
      today: fixture.calendarDay,
      catalog: fixture.catalog,
      selectedBranchId: 'branch-a',
    );

    expect(summary.selectedBranchId, 'branch-a');
    expect(summary.todayAppointmentCount, 3);
    expect(summary.distinctBranchCount, 1);
    expect(summary.distinctStaffCount, 2);
    expect(summary.pendingCount, 3);
    expect(summary.oldestPendingCreatedAt, DateTime(2026, 11, 13, 18));
    expect(summary.completedCount, 1);
    expect(summary.noShowCount, 0);
    expect(summary.statusCounts.map((row) => row.status), [
      AdminStatusFilter.completed,
      AdminStatusFilter.pending,
      AdminStatusFilter.cancelled,
    ]);
    expect(
      summary.departmentRows.map((row) => (row.name, row.count)).toList(),
      [('Cardiology', 3)],
    );
    expect(summary.staffRows.map((row) => (row.fullName, row.count)).toList(), [
      ('Zeynep Aydın', 2),
      ('Ali Demir', 1),
    ]);
    expect(summary.pendingAppointments.map((appointment) => appointment.id), [
      'pending-today',
      'pending-tomorrow-early',
      'pending-tomorrow-late',
    ]);
  });

  test(
    'sorts equal counts by Turkish name and gives maximum bars full length',
    () {
      final summary = AdminDashboardSummary.fromAppointments(
        todayAppointments: [
          fixture.appointment(
            id: 'zeynep',
            status: AppointmentStatus.approved,
            departmentId: 'department-b',
            branchId: 'branch-b',
            staffId: 'staff-z',
          ),
          fixture.appointment(
            id: 'ali',
            status: AppointmentStatus.approved,
            staffId: 'staff-a',
          ),
        ],
        pendingAppointments: const [],
        today: fixture.calendarDay,
        catalog: fixture.catalog,
      );

      expect(summary.departmentRows.map((row) => row.name), [
        'Cardiology',
        'Neurology',
      ]);
      expect(summary.staffRows.map((row) => row.fullName), [
        'Ali Demir',
        'Zeynep Aydın',
      ]);
      expect(summary.departmentRows.map((row) => row.fractionOfMaximum), [
        1,
        1,
      ]);
      expect(summary.staffRows.map((row) => row.fractionOfMaximum), [1, 1]);
    },
  );

  test('returns empty figures and null oldest request for an empty day', () {
    final summary = AdminDashboardSummary.fromAppointments(
      todayAppointments: const [],
      pendingAppointments: [
        fixture.appointment(
          id: 'past-pending',
          status: AppointmentStatus.pending,
          date: DateTime(2026, 11, 13),
        ),
      ],
      today: fixture.calendarDay,
      catalog: fixture.catalog,
    );

    expect(summary.todayAppointmentCount, 0);
    expect(summary.distinctBranchCount, 0);
    expect(summary.distinctStaffCount, 0);
    expect(summary.pendingCount, 0);
    expect(summary.oldestPendingCreatedAt, isNull);
    expect(summary.completedCount, 0);
    expect(summary.noShowCount, 0);
    expect(summary.statusCounts, isEmpty);
    expect(summary.departmentRows, isEmpty);
    expect(summary.staffRows, isEmpty);
    expect(summary.pendingAppointments, isEmpty);
  });

  test('groups patient and staff cancellations into one status count', () {
    final summary = AdminDashboardSummary.fromAppointments(
      todayAppointments: [
        fixture.appointment(
          id: 'patient-cancel',
          status: AppointmentStatus.cancelledByPatient,
        ),
        fixture.appointment(
          id: 'staff-cancel',
          status: AppointmentStatus.cancelledByStaff,
        ),
      ],
      pendingAppointments: const [],
      today: fixture.calendarDay,
      catalog: fixture.catalog,
    );

    expect(summary.statusCounts, hasLength(1));
    expect(summary.statusCounts.single.status, AdminStatusFilter.cancelled);
    expect(summary.statusCounts.single.count, 2);
  });

  test('exposes immutable summary collections', () {
    final summary = AdminDashboardSummary.fromAppointments(
      todayAppointments: todaysAppointments,
      pendingAppointments: pendingAppointments,
      today: fixture.calendarDay,
      catalog: fixture.catalog,
    );

    expect(() => summary.statusCounts.clear(), throwsUnsupportedError);
    expect(() => summary.pendingAppointments.clear(), throwsUnsupportedError);
  });
}
