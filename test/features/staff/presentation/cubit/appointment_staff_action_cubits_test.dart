import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/change_appointment_status_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/cubit/appointment_action_state.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/appointment_complete_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/appointment_no_show_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/appointment_staff_cancel_cubit.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/time/support/fixed_clock.dart';
import '../../../appointments/domain/support/appointment_fixture.dart';
import '../../../appointments/presentation/doubles/staff_appointment_repository.dart';

void main() {
  const fixture = AppointmentFixture();
  final staff = fixture.actor(UserRole.doctor, 'staff');

  Appointment approvedAppointment() {
    return fixture
        .success(fixture.request().approve(by: staff, at: fixture.beforeStart))
        .withId('appointment-18');
  }

  test('complete cubit forwards the completion action', () async {
    final appointment = approvedAppointment();
    final repository = StaffAppointmentRepository()
      ..stored[appointment.id] = appointment;
    final cubit = AppointmentCompleteCubit(
      ChangeAppointmentStatusUseCase(repository, FixedClock(fixture.start)),
    );

    await cubit.perform(appointment, by: staff);

    expect(cubit.action, AppointmentAction.complete);
    expect(repository.changedIds, [appointment.id]);
    expect(
      repository.stored[appointment.id]?.status,
      AppointmentStatus.completed,
    );
    expect(cubit.state, isA<AppointmentActionSuccess>());
    await cubit.close();
    await repository.events.close();
  });

  test('no-show cubit forwards the no-show action', () async {
    final appointment = approvedAppointment();
    final repository = StaffAppointmentRepository()
      ..stored[appointment.id] = appointment;
    final cubit = AppointmentNoShowCubit(
      ChangeAppointmentStatusUseCase(
        repository,
        FixedClock(fixture.atTolerance),
      ),
    );

    await cubit.perform(appointment, by: staff);

    expect(cubit.action, AppointmentAction.markNoShow);
    expect(repository.changedIds, [appointment.id]);
    expect(repository.stored[appointment.id]?.status, AppointmentStatus.noShow);
    expect(cubit.state, isA<AppointmentActionSuccess>());
    await cubit.close();
    await repository.events.close();
  });

  test('staff-cancel cubit forwards action and optional reason', () async {
    final appointment = approvedAppointment();
    final repository = StaffAppointmentRepository()
      ..stored[appointment.id] = appointment;
    final cubit = AppointmentStaffCancelCubit(
      ChangeAppointmentStatusUseCase(
        repository,
        FixedClock(fixture.beforeStart),
      ),
    );

    await cubit.perform(
      appointment,
      by: staff,
      reason: 'Şube saatleri değişti',
    );

    expect(cubit.action, AppointmentAction.cancelByStaff);
    expect(repository.changedIds, [appointment.id]);
    expect(
      repository.stored[appointment.id]?.status,
      AppointmentStatus.cancelledByStaff,
    );
    expect(
      repository.stored[appointment.id]?.statusReason,
      'Şube saatleri değişti',
    );
    expect(cubit.state, isA<AppointmentActionSuccess>());
    await cubit.close();
    await repository.events.close();
  });
}
