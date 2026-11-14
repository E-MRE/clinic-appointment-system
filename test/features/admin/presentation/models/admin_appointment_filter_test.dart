import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_status_filter.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_appointment_filter.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/time/support/fixed_clock.dart';
import '../../../appointments/domain/support/appointment_fixture.dart';

void main() {
  const fixture = AppointmentFixture();
  final from = CalendarDate(year: 2026, month: 10, day: 26);
  final through = CalendarDate(year: 2026, month: 11, day: 1);

  AdminAppointmentFilter filter({
    String? branchId,
    String? departmentId,
    String? staffId,
    Set<AdminStatusFilter> statuses = const {},
    String patientQuery = '',
  }) {
    return AdminAppointmentFilter(
      from: from,
      through: through,
      branchId: branchId,
      departmentId: departmentId,
      staffId: staffId,
      statuses: statuses,
      patientQuery: patientQuery,
    );
  }

  test('defaults to the current Monday through Sunday week', () {
    final currentWeek = AdminAppointmentFilter.currentWeek(
      clock: FixedClock(DateTime(2026, 11, 1, 12)),
    );

    expect(currentWeek.from, from);
    expect(currentWeek.through, through);
  });

  test('matches each criterion by itself and combines all criteria', () {
    final matching = _appointment(
      fixture,
      id: 'matching',
      date: CalendarDate(year: 2026, month: 10, day: 27),
      status: AppointmentStatus.approved,
      branchId: 'branch-1',
      departmentId: 'department-1',
      staffId: 'staff-1',
      patientName: 'İpek Işık',
    );

    expect(filter(branchId: 'branch-1').matches(matching), isTrue);
    expect(filter(departmentId: 'department-1').matches(matching), isTrue);
    expect(filter(staffId: 'staff-1').matches(matching), isTrue);
    expect(
      filter(statuses: {AdminStatusFilter.approved}).matches(matching),
      isTrue,
    );
    expect(filter(patientQuery: 'ipek').matches(matching), isTrue);
    expect(filter(patientQuery: 'ışık').matches(matching), isTrue);
    expect(filter(patientQuery: '  İPEK  ').patientQuery, 'İPEK');
    expect(
      filter(
        branchId: 'branch-1',
        departmentId: 'department-1',
        staffId: 'staff-1',
        statuses: {AdminStatusFilter.pending, AdminStatusFilter.approved},
        patientQuery: 'ipek',
      ).matches(matching),
      isTrue,
    );
    expect(filter(branchId: 'branch-2').matches(matching), isFalse);
    expect(filter(departmentId: 'department-2').matches(matching), isFalse);
    expect(filter(staffId: 'staff-2').matches(matching), isFalse);
    expect(
      filter(statuses: {AdminStatusFilter.pending}).matches(matching),
      isFalse,
    );
    expect(filter(patientQuery: 'ayşe').matches(matching), isFalse);
    expect(
      filter(patientQuery: 'ipek').matches(
        _appointment(
          fixture,
          date: CalendarDate(year: 2026, month: 11, day: 2),
        ),
      ),
      isFalse,
    );
  });

  test(
    'status groups include both cancellation types and support multi-select',
    () {
      final cancelledByPatient = _appointment(
        fixture,
        status: AppointmentStatus.cancelledByPatient,
      );
      final cancelledByStaff = _appointment(
        fixture,
        id: 'staff-cancelled',
        status: AppointmentStatus.cancelledByStaff,
      );
      final pending = _appointment(fixture, id: 'pending');
      final cancelledOnly = filter(statuses: {AdminStatusFilter.cancelled});
      final multiple = filter(
        statuses: {AdminStatusFilter.cancelled, AdminStatusFilter.pending},
      );

      expect(cancelledOnly.matches(cancelledByPatient), isTrue);
      expect(cancelledOnly.matches(cancelledByStaff), isTrue);
      expect(cancelledOnly.matches(pending), isFalse);
      expect(multiple.matches(cancelledByStaff), isTrue);
      expect(multiple.matches(pending), isTrue);
    },
  );

  test('branch and department selections clear only invalid dependants', () {
    final catalog = _catalog();
    final selected = filter(
      branchId: 'branch-1',
      departmentId: 'department-1',
      staffId: 'staff-1',
    );

    final sameBranch = selected.withBranch('branch-1', catalog);
    expect(sameBranch.departmentId, 'department-1');
    expect(sameBranch.staffId, 'staff-1');

    final otherBranch = selected.withBranch('branch-2', catalog);
    expect(otherBranch.branchId, 'branch-2');
    expect(otherBranch.departmentId, isNull);
    expect(otherBranch.staffId, isNull);

    final otherDepartment = selected.withDepartment('department-2', catalog);
    expect(otherDepartment.departmentId, 'department-2');
    expect(otherDepartment.staffId, isNull);
  });

  test(
    'catalog options narrow departments and staff by current selections',
    () {
      final catalog = _catalog();
      final selectedBranch = filter(branchId: 'branch-1');
      expect(
        selectedBranch
            .departmentsIn(catalog)
            .map((department) => department.id),
        ['department-1'],
      );
      expect(selectedBranch.staffIn(catalog).map((member) => member.id), [
        'staff-1',
        'staff-2',
      ]);

      final selectedDepartment = filter(
        branchId: 'branch-1',
        departmentId: 'department-1',
      );
      expect(selectedDepartment.staffIn(catalog).map((member) => member.id), [
        'staff-1',
      ]);
      expect(selectedBranch.branchesIn(catalog), catalog.branches);
    },
  );

  test('copy and clear preserve dates and clear only optional criteria', () {
    final selected = filter(
      branchId: 'branch-1',
      departmentId: 'department-1',
      staffId: 'staff-1',
      statuses: {AdminStatusFilter.approved},
      patientQuery: ' Işık ',
    );
    final cleared = selected.cleared();

    expect(selected.copyWith(), selected);
    expect(selected.copyWith(branchId: null).branchId, isNull);
    expect(cleared.from, from);
    expect(cleared.through, through);
    expect(cleared.branchId, isNull);
    expect(cleared.departmentId, isNull);
    expect(cleared.staffId, isNull);
    expect(cleared.statuses, isEmpty);
    expect(cleared.patientQuery, isEmpty);
  });
}

Appointment _appointment(
  AppointmentFixture fixture, {
  String id = 'appointment',
  CalendarDate? date,
  AppointmentStatus status = AppointmentStatus.pending,
  String branchId = 'branch-1',
  String departmentId = 'department-1',
  String staffId = 'staff-1',
  String patientName = 'Patient',
}) {
  return Appointment.restore(
    id: id,
    patientId: 'patient-1',
    patientName: patientName,
    staffId: staffId,
    branchId: branchId,
    departmentId: departmentId,
    serviceId: 'service-1',
    serviceName: 'Examination',
    fee: fixture.fee,
    date: date ?? CalendarDate(year: 2026, month: 10, day: 27),
    range: fixture.range,
    status: status,
    history: [fixture.change(status)],
  );
}

ClinicCatalog _catalog() {
  final branches = [
    Branch(
      id: 'branch-1',
      clinicId: 'clinic-1',
      name: 'Merkez',
      address: 'Main street',
      workingHours: WorkingHours.closed(),
    ),
    Branch(
      id: 'branch-2',
      clinicId: 'clinic-1',
      name: 'Kadıköy',
      address: 'Second street',
      workingHours: WorkingHours.closed(),
    ),
  ];
  final departments = [
    const Department(
      id: 'department-1',
      branchId: 'branch-1',
      name: 'Cardiology',
    ),
    const Department(
      id: 'department-2',
      branchId: 'branch-2',
      name: 'Radiology',
    ),
  ];
  final staff = [
    const Doctor(
      id: 'staff-1',
      fullName: 'Ali Doctor',
      email: 'ali@example.com',
      branchId: 'branch-1',
      departmentId: 'department-1',
      serviceIds: [],
      specialty: 'Cardiology',
    ),
    const Doctor(
      id: 'staff-2',
      fullName: 'Can Doctor',
      email: 'can@example.com',
      branchId: 'branch-1',
      departmentId: 'department-2',
      serviceIds: [],
      specialty: 'Radiology',
    ),
    const Doctor(
      id: 'staff-3',
      fullName: 'Ece Doctor',
      email: 'ece@example.com',
      branchId: 'branch-2',
      departmentId: 'department-2',
      serviceIds: [],
      specialty: 'Radiology',
    ),
  ];
  return ClinicCatalog(
    clinics: const [],
    branches: branches,
    departments: departments,
    services: const [],
    staff: staff,
  );
}
