import 'package:clinic_appointment_system/core/extensions/time_range_label.dart';
import 'package:clinic_appointment_system/core/localization/weekday_localization.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_booking_context.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_validator.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/no_staff_overlap_rule.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/staff_provides_service_rule.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/within_availability_rule.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/within_working_hours_rule.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_rule_check_kind.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_rule_check_item.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// Re-runs the booking rules a staff member can verify for a pending request.
/// The patient-overlap rule is left out: staff cannot read the patient's
/// appointments with other staff, and booking already enforced it.
final class StaffRuleCheckFactory {
  /// Creates the factory.
  const StaffRuleCheckFactory();

  /// The rules behind [StaffRuleCheckKind], in the same order.
  static const AppointmentValidator _validator = AppointmentValidator([
    WithinAvailabilityRule(),
    WithinWorkingHoursRule(),
    NoStaffOverlapRule(),
    StaffProvidesServiceRule(),
  ]);

  /// Returns one outcome per [StaffRuleCheckKind] for [request]. Only the
  /// other approved [appointments] of the staff member count as overlaps.
  List<StaffRuleCheckItem> create({
    required Appointment request,
    required Staff staff,
    required MedicalService service,
    required StaffAvailability availability,
    required WorkingHours branchHours,
    required Iterable<Appointment> appointments,
    required DateTime now,
  }) {
    final context = AppointmentBookingContext(
      staff: staff,
      service: service,
      availability: availability,
      branchHours: branchHours,
      staffSlots: _approvedSlotsBesides(request, appointments),
      patientSlots: const [],
      now: now,
    );
    final failedCodes = <AppointmentErrorCode>{
      for (final violation in _validator.validate(request, context))
        violation.code,
    };
    return [
      for (final kind in StaffRuleCheckKind.values)
        StaffRuleCheckItem(
          kind: kind,
          passed: !failedCodes.contains(kind.violationCode),
          detail: switch (kind) {
            StaffRuleCheckKind.withinAvailability => _availabilityDetail(
              request,
              availability,
              branchHours,
            ),
            StaffRuleCheckKind.withinWorkingHours => _branchHoursDetail(
              request,
              branchHours,
            ),
            StaffRuleCheckKind.noStaffOverlap ||
            StaffRuleCheckKind.staffProvidesService => null,
          },
        ),
    ];
  }

  List<BookedSlot> _approvedSlotsBesides(
    Appointment request,
    Iterable<Appointment> appointments,
  ) {
    return [
      for (final appointment in appointments)
        if (appointment.id != request.id &&
            appointment.status == AppointmentStatus.approved)
          ?appointment.bookedSlot,
    ];
  }

  /// The weekday and the window enclosing the request (`Salı 09:00–12:00`).
  String _availabilityDetail(
    Appointment request,
    StaffAvailability availability,
    WorkingHours branchHours,
  ) {
    final windows = availability.effectiveWindowsOn(request.date, branchHours);
    final ranges = [
      for (final window in windows)
        if (window.range.encloses(request.range)) window.range.label,
    ];
    final weekday = request.date.weekday.label;
    if (ranges.isEmpty) return weekday;
    return '$weekday ${ranges.first}';
  }

  /// The branch hours of the request's weekday (`08:30–18:00`).
  String _branchHoursDetail(Appointment request, WorkingHours branchHours) {
    return branchHours
        .rangesOn(request.date.weekday)
        .map((range) => range.label)
        .join(', ');
  }
}
