import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/models/appointment_status_request.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/change_appointment_status_use_case.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../doubles/fake_appointment_repository.dart';
import '../doubles/mock_clock.dart';
import '../support/appointment_fixture.dart';

void main() {
  const f = AppointmentFixture();
  late FakeAppointmentRepository repository;
  late Clock clock;
  late ChangeAppointmentStatusUseCase useCase;
  setUp(() {
    repository = FakeAppointmentRepository();
    clock = MockClock();
    when(clock.now).thenReturn(f.atTolerance);
    useCase = ChangeAppointmentStatusUseCase(repository, clock);
  });
  const targets = {
    AppointmentAction.approve: AppointmentStatus.approved,
    AppointmentAction.reject: AppointmentStatus.rejected,
    AppointmentAction.cancelByPatient: AppointmentStatus.cancelledByPatient,
    AppointmentAction.cancelByStaff: AppointmentStatus.cancelledByStaff,
    AppointmentAction.complete: AppointmentStatus.completed,
    AppointmentAction.markNoShow: AppointmentStatus.noShow,
  };
  for (final entry in targets.entries) {
    test(
      '${entry.key.name} transitions the current stored appointment',
      () async {
        AppointmentStatus initial = AppointmentStatus.approved;
        if (entry.key == AppointmentAction.approve ||
            entry.key == AppointmentAction.reject) {
          initial = AppointmentStatus.pending;
        }
        repository.current = f.restore(initial);
        UserRole role = UserRole.doctor;
        String id = 'staff';
        if (entry.key == AppointmentAction.cancelByPatient) {
          role = UserRole.patient;
          id = 'patient';
          when(clock.now).thenReturn(f.beforeStart);
        }
        final result = await useCase(
          AppointmentStatusRequest(
            appointmentId: 'appointment',
            action: entry.key,
            by: f.actor(role, id),
          ),
        );
        expect(result.appointment?.status, entry.value);
        expect(result.appointment?.history.last.at, clock.now());
        expect(result.appointment?.history, hasLength(2));
      },
    );
  }
  test('preserves domain rejection without throwing', () async {
    repository.current = f.restore(AppointmentStatus.pending);
    final result = await useCase(
      AppointmentStatusRequest(
        appointmentId: 'appointment',
        action: AppointmentAction.approve,
        by: f.patient,
      ),
    );
    expect(result.errorCode, AppointmentErrorCode.notPermitted);
  });
}
