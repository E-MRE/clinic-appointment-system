import 'package:clinic_appointment_system/features/admin/presentation/models/admin_appointment_row_presentation.dart';
import 'package:clinic_appointment_system/features/appointments/domain/actors/admin_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';
import '../../../appointments/domain/support/appointment_fixture.dart';

void main() {
  const fixture = AppointmentFixture();

  testWidgets('resolves catalog display values and the requested date label', (
    tester,
  ) async {
    await loadTestTranslations(tester);
    final presentation = AdminAppointmentRowPresentation(
      appointment: fixture.request(),
      catalog: _catalog(),
      actor: const AdminAppointmentActor(id: 'admin-1'),
      at: fixture.beforeStart,
    );

    expect(presentation.dateTimeLabel, 'Paz 1 Kas · 10:00');
    expect(presentation.staffName, 'Dr. Ayşe Yılmaz');
    expect(presentation.departmentName, 'Kardiyoloji');
    expect(presentation.branchName, 'Merkez');
    expect(presentation.appointment.serviceName, 'Examination');
    expect(presentation.actions, [
      AppointmentAction.approve,
      AppointmentAction.reject,
    ]);
  });

  testWidgets('offers only admin lifecycle actions allowed for each status', (
    tester,
  ) async {
    await loadTestTranslations(tester);
    const actor = AdminAppointmentActor(id: 'admin-1');
    final catalog = _catalog();
    final at = fixture.beforeStart;

    for (final status in AppointmentStatus.values) {
      final appointment = status == AppointmentStatus.pending
          ? fixture.request()
          : fixture.restore(status);
      final presentation = AdminAppointmentRowPresentation(
        appointment: appointment,
        catalog: catalog,
        actor: actor,
        at: at,
      );
      final expected = switch (status) {
        AppointmentStatus.pending => [
          AppointmentAction.approve,
          AppointmentAction.reject,
        ],
        AppointmentStatus.approved => [AppointmentAction.cancelByStaff],
        AppointmentStatus.rejected ||
        AppointmentStatus.cancelledByPatient ||
        AppointmentStatus.cancelledByStaff ||
        AppointmentStatus.completed ||
        AppointmentStatus.noShow => <AppointmentAction>[],
      };
      expect(presentation.actions, expected, reason: status.name);
    }
  });
}

ClinicCatalog _catalog() {
  return ClinicCatalog(
    clinics: const [],
    branches: [
      Branch(
        id: 'branch',
        clinicId: 'clinic-1',
        name: 'Merkez',
        address: 'Main street',
        workingHours: WorkingHours.closed(),
      ),
    ],
    departments: const [
      Department(id: 'department', branchId: 'branch', name: 'Kardiyoloji'),
    ],
    services: const [],
    staff: const [
      Doctor(
        id: 'staff',
        fullName: 'Dr. Ayşe Yılmaz',
        email: 'ayse@example.com',
        branchId: 'branch',
        departmentId: 'department',
        serviceIds: [],
        specialty: 'Cardiology',
      ),
    ],
  );
}
