import 'package:clinic_appointment_system/core/constants/widget_key.dart';
import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/appointment_status_change.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/weekly_window.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'doubles/staff_requests_page_harness.dart';

void main() {
  late StaffRequestsPageHarness harness;

  setUp(() async {
    harness = StaffRequestsPageHarness();
    await harness.initialize();
  });

  Appointment makeAppointment({
    required String id,
    required String patientName,
    required CalendarDate date,
    required TimeRange range,
    AppointmentStatus status = AppointmentStatus.approved,
    String serviceName = 'Kardiyoloji Muayenesi',
    Money? fee,
  }) {
    return Appointment.restore(
      id: id,
      patientId: 'patient-$id',
      patientName: patientName,
      staffId: harness.staff.id,
      branchId: 'branch',
      departmentId: 'department',
      serviceId: 'service',
      serviceName: serviceName,
      fee: fee ?? Money.minorUnits(120000),
      date: date,
      range: range,
      status: status,
      history: [
        AppointmentStatusChange(
          status: status,
          byUserId: 'staff',
          byRole: UserRole.doctor,
          at: DateTime(2026, 10, 20, 8),
        ),
      ],
    );
  }

  void configureWorkspace({
    StaffAvailability? availability,
    WorkingHours? workingHours,
  }) {
    when(() => harness.branchRepo.watchBranch(any())).thenAnswer(
      (_) => Stream.value(
        DataResult.success(
          data: Branch(
            id: 'branch',
            clinicId: 'clinic',
            name: 'Merkez Şube',
            address: 'Adres',
            workingHours:
                workingHours ??
                WorkingHours({
                  Weekday.monday: [
                    TimeRange(
                      start: ClockTime(hour: 8, minute: 30),
                      end: ClockTime(hour: 18, minute: 0),
                    ),
                  ],
                  Weekday.tuesday: [
                    TimeRange(
                      start: ClockTime(hour: 8, minute: 30),
                      end: ClockTime(hour: 18, minute: 0),
                    ),
                  ],
                  Weekday.wednesday: [
                    TimeRange(
                      start: ClockTime(hour: 8, minute: 30),
                      end: ClockTime(hour: 18, minute: 0),
                    ),
                  ],
                  Weekday.thursday: [
                    TimeRange(
                      start: ClockTime(hour: 8, minute: 30),
                      end: ClockTime(hour: 18, minute: 0),
                    ),
                  ],
                  Weekday.friday: [
                    TimeRange(
                      start: ClockTime(hour: 8, minute: 30),
                      end: ClockTime(hour: 18, minute: 0),
                    ),
                  ],
                }),
          ),
        ),
      ),
    );
    harness.servicesRepo.servicesStream = Stream.value(
      const DataResult<List<MedicalService>>.success(data: []),
    ).asBroadcastStream();
    harness.availabilityRepo.stream = Stream.value(
      DataResult.success(
        data:
            availability ??
            StaffAvailability(
              staffId: harness.staff.id,
              branchId: 'branch',
              weekly: [
                WeeklyWindow(
                  weekday: Weekday.tuesday,
                  range: TimeRange(
                    start: ClockTime(hour: 9, minute: 0),
                    end: ClockTime(hour: 12, minute: 0),
                  ),
                ),
              ],
            ),
      ),
    ).asBroadcastStream();
  }

  testWidgets(
    'week view shows day headers with counts, appointment block, closed day, and legend',
    (tester) async {
      addTearDown(() => harness.dispose(tester));
      configureWorkspace();

      final appointment = makeAppointment(
        id: 'apt-1',
        patientName: 'Ali Yılmaz',
        date: CalendarDate(year: 2026, month: 10, day: 20),
        range: TimeRange(
          start: ClockTime(hour: 9, minute: 20),
          end: ClockTime(hour: 9, minute: 40),
        ),
      );

      await harness.pumpCalendar(
        tester,
        size: StaffRequestsPageHarness.desktop,
      );
      await harness.emitAndPump(tester, [appointment]);

      // Day headers with appointment counts
      expect(find.text('Pzt'), findsOneWidget);
      expect(find.text('Sal'), findsOneWidget);
      expect(find.text('Çar'), findsOneWidget);
      expect(find.text('Per'), findsOneWidget);
      expect(find.text('Cum'), findsOneWidget);
      expect(find.text('Cmt'), findsOneWidget);
      expect(find.text('1 randevu'), findsWidgets);
      expect(find.text('0 randevu'), findsWidgets);

      // Appointment block shows time and patient name
      expect(find.text('09:20'), findsOneWidget);
      expect(find.text('Ali Yılmaz'), findsOneWidget);

      // Closed day shows "Şube kapalı"
      expect(find.text('Şube kapalı'), findsOneWidget);

      // Legend swatches and labels
      expect(find.text('Beklemede'), findsOneWidget);
      expect(find.text('Onaylandı'), findsOneWidget);
      expect(find.text('Tamamlandı'), findsOneWidget);
      expect(find.text('Gelmedi'), findsOneWidget);
      expect(find.text('İptal Edildi'), findsOneWidget);
      expect(find.text('Uygunluk aralığı'), findsOneWidget);
    },
  );

  testWidgets('navigation next and previous change the header title', (
    tester,
  ) async {
    addTearDown(() => harness.dispose(tester));
    configureWorkspace();

    await harness.pumpCalendar(tester, size: StaffRequestsPageHarness.desktop);
    await harness.emitAndPump(tester, []);

    // Current week: 19 – 24 Ekim
    expect(find.textContaining('19 – 24 Ekim'), findsOneWidget);

    // Tap next
    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();

    expect(find.textContaining('26 – 31 Ekim'), findsOneWidget);

    // Tap previous
    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();

    expect(find.textContaining('19 – 24 Ekim'), findsOneWidget);
  });

  testWidgets('switching to Gün view shows only one day column', (
    tester,
  ) async {
    addTearDown(() => harness.dispose(tester));
    configureWorkspace();

    await harness.pumpCalendar(tester, size: StaffRequestsPageHarness.desktop);
    await harness.emitAndPump(tester, []);

    // In week view, multiple day headers exist
    expect(find.text('Pzt'), findsOneWidget);
    expect(find.text('Sal'), findsOneWidget);

    // Switch to "Gün"
    await tester.tap(find.text('Gün'));
    await tester.pumpAndSettle();

    // Now only today's column (Salı 20 Ekim) is visible
    expect(find.text('Pzt'), findsNothing);
    expect(find.text('Sal'), findsOneWidget);
  });

  testWidgets('tapping an appointment block calls onAppointmentTap', (
    tester,
  ) async {
    addTearDown(() => harness.dispose(tester));
    configureWorkspace();

    Appointment? tapped;
    final appointment = makeAppointment(
      id: 'apt-tap',
      patientName: 'Zeynep Kaya',
      date: CalendarDate(year: 2026, month: 10, day: 20),
      range: TimeRange(
        start: ClockTime(hour: 9, minute: 20),
        end: ClockTime(hour: 9, minute: 40),
      ),
    );

    await harness.pumpCalendar(
      tester,
      size: StaffRequestsPageHarness.desktop,
      onAppointmentTap: (apt) {
        tapped = apt;
      },
    );
    await harness.emitAndPump(tester, [appointment]);

    await tester.tap(find.text('Zeynep Kaya'));
    await tester.pumpAndSettle();

    expect(tapped, appointment);
  });

  testWidgets('now line indicator exists on today column', (tester) async {
    addTearDown(() => harness.dispose(tester));
    configureWorkspace();

    await harness.pumpCalendar(tester, size: StaffRequestsPageHarness.desktop);
    await harness.emitAndPump(tester, []);

    expect(find.byKey(const WidgetKey.staffCalendarNowLine()), findsOneWidget);
  });

  for (final size in const [
    StaffRequestsPageHarness.mobile,
    StaffRequestsPageHarness.tablet,
    StaffRequestsPageHarness.desktop,
  ]) {
    testWidgets('renders without overflow at $size', (tester) async {
      addTearDown(() => harness.dispose(tester));
      configureWorkspace();

      final appointment = makeAppointment(
        id: 'apt-overflow',
        patientName: 'Prof. Dr. Mehmet Ali Karaosmanoğlu',
        date: CalendarDate(year: 2026, month: 10, day: 20),
        range: TimeRange(
          start: ClockTime(hour: 9, minute: 20),
          end: ClockTime(hour: 9, minute: 40),
        ),
      );

      await harness.pumpCalendar(tester, size: size);
      await harness.emitAndPump(tester, [appointment]);

      expect(tester.takeException(), isNull);
    });
  }
}
