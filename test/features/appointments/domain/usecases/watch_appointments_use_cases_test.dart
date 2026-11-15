import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/usecases/no_params.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/models/admin_appointments_query.dart';
import 'package:clinic_appointment_system/features/appointments/domain/models/staff_appointments_query.dart';
import 'package:clinic_appointment_system/features/appointments/domain/models/staff_booked_slots_query.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/watch_admin_appointments_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/watch_patient_appointments_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/watch_pending_appointments_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/watch_staff_appointments_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/watch_staff_booked_slots_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/fake_appointment_repository.dart';
import '../support/booking_fixture.dart';

void main() {
  const f = BookingFixture();
  late FakeAppointmentRepository repository;
  setUp(() => repository = FakeAppointmentRepository());
  test(
    'patient observation forwards owner and success/error results',
    () async {
      final success = DataResult<List<Appointment>>.success(
        data: [f.appointment()],
      );
      const error = DataResult<List<Appointment>>.error(message: 'unavailable');
      repository.appointments = Stream.fromIterable([success, error]);
      expect(
        await WatchPatientAppointmentsUseCase(repository)('patient').toList(),
        [success, error],
      );
      expect(repository.watchedOwner, 'patient');
    },
  );
  test(
    'staff observation forwards owner and inclusive date boundaries',
    () async {
      final success = DataResult<List<Appointment>>.success(
        data: [f.appointment()],
      );
      const error = DataResult<List<Appointment>>.error(
        message: 'invalidRecord',
      );
      repository.appointments = Stream.fromIterable([success, error]);
      final through = f.lifecycle.date;
      expect(
        await WatchStaffAppointmentsUseCase(repository)(
          StaffAppointmentsQuery(
            staffId: 'staff',
            from: f.date,
            through: through,
          ),
        ).toList(),
        [success, error],
      );
      expect(repository.watchedOwner, 'staff');
      expect(repository.watchedFrom, f.date);
      expect(repository.watchedThrough, through);
    },
  );
  test(
    'administrator observation forwards inclusive date boundaries',
    () async {
      final success = DataResult<List<Appointment>>.success(
        data: [f.appointment()],
      );
      const error = DataResult<List<Appointment>>.error(
        message: 'invalidRecord',
      );
      repository.appointments = Stream.fromIterable([success, error]);
      final through = f.lifecycle.date;
      expect(
        await WatchAdminAppointmentsUseCase(repository)(
          AdminAppointmentsQuery(from: f.date, through: through),
        ).toList(),
        [success, error],
      );
      expect(repository.watchedAdminFrom, f.date);
      expect(repository.watchedAdminThrough, through);
    },
  );
  test('pending observation forwards success and error results', () async {
    final success = DataResult<List<Appointment>>.success(
      data: [f.appointment()],
    );
    const error = DataResult<List<Appointment>>.error(message: 'unavailable');
    repository.appointments = Stream.fromIterable([success, error]);
    expect(
      await WatchPendingAppointmentsUseCase(repository)(
        const NoParams(),
      ).toList(),
      [success, error],
    );
    expect(repository.watchedPendingAppointments, isTrue);
  });
  test(
    'slot observation forwards staff/date and success/error results',
    () async {
      final success = DataResult<List<BookedSlot>>.success(data: [f.slot()]);
      const error = DataResult<List<BookedSlot>>.error(
        message: 'invalidRecord',
      );
      repository.slots = Stream.fromIterable([success, error]);
      expect(
        await WatchStaffBookedSlotsUseCase(repository)(
          StaffBookedSlotsQuery(staffId: 'staff', date: f.date),
        ).toList(),
        [success, error],
      );
      expect(repository.watchedOwner, 'staff');
      expect(repository.watchedFrom, f.date);
    },
  );
}
