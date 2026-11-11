import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/definition_row/app_definition_row.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_appointment_presentation.dart';
import 'package:flutter/widgets.dart';

/// Shared two-column summary of a staff appointment's schedule and location.
final class StaffAppointmentDetailGrid extends StatelessWidget {
  /// Creates the appointment detail grid with its resolved location label.
  const StaffAppointmentDetailGrid({
    required this.appointment,
    required this.location,
    super.key,
  });

  /// Appointment snapshot whose service and schedule are displayed.
  final Appointment appointment;

  /// Branch and department display names, or a localized fallback.
  final String location;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s16,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppDefinitionRow(
                label: LocaleKeys.staffRequests_detail_dateTime.translate(),
                child: AppText.bodyStrong(appointment.scheduleRangeLabel),
              ),
            ),
            const EmptySize.s16Width(),
            Expanded(
              child: AppDefinitionRow(
                label: LocaleKeys.staffRequests_detail_service.translate(),
                child: AppText.bodyStrong(appointment.serviceName),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppDefinitionRow(
                label: LocaleKeys.staffRequests_detail_durationAndFee
                    .translate(),
                child: AppText.bodyStrong(appointment.durationAndFeeLabel),
              ),
            ),
            const EmptySize.s16Width(),
            Expanded(
              child: AppDefinitionRow(
                label: LocaleKeys.staffRequests_detail_location.translate(),
                child: AppText.bodyStrong(location),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
