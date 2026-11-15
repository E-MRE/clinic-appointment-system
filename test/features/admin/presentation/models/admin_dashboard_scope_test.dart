import 'package:clinic_appointment_system/features/admin/presentation/models/admin_dashboard_scope.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/admin_dashboard_fixture.dart';

void main() {
  const fixture = AdminDashboardFixture();

  test('includes only today appointments in the optional branch scope', () {
    final scope = AdminDashboardScope(
      today: fixture.calendarDay,
      branchId: 'branch-a',
    );

    expect(
      scope.includesToday(
        fixture.appointment(id: 'today', status: AppointmentStatus.approved),
      ),
      isTrue,
    );
    expect(
      scope.includesToday(
        fixture.appointment(
          id: 'other-branch',
          status: AppointmentStatus.approved,
          branchId: 'branch-b',
        ),
      ),
      isFalse,
    );
    expect(
      scope.includesToday(
        fixture.appointment(
          id: 'yesterday',
          status: AppointmentStatus.approved,
          date: DateTime(2026, 11, 13),
        ),
      ),
      isFalse,
    );
  });

  test('includes pending appointments from today forward in the branch', () {
    final scope = AdminDashboardScope(
      today: fixture.calendarDay,
      branchId: 'branch-a',
    );

    expect(
      scope.includesUpcomingPending(
        fixture.appointment(id: 'today', status: AppointmentStatus.pending),
      ),
      isTrue,
    );
    expect(
      scope.includesUpcomingPending(
        fixture.appointment(
          id: 'future',
          status: AppointmentStatus.pending,
          date: DateTime(2026, 11, 15),
        ),
      ),
      isTrue,
    );
    expect(
      scope.includesUpcomingPending(
        fixture.appointment(
          id: 'past',
          status: AppointmentStatus.pending,
          date: DateTime(2026, 11, 13),
        ),
      ),
      isFalse,
    );
    expect(
      scope.includesUpcomingPending(
        fixture.appointment(id: 'approved', status: AppointmentStatus.approved),
      ),
      isFalse,
    );
    expect(
      scope.includesUpcomingPending(
        fixture.appointment(
          id: 'other-branch',
          status: AppointmentStatus.pending,
          branchId: 'branch-b',
        ),
      ),
      isFalse,
    );
  });
}
