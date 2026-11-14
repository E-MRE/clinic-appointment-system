part of 'admin_appointments_page.dart';

/// Select-looking range control that opens Material's date-range picker.
final class _AdminAppointmentDateRangeField extends StatelessWidget {
  const _AdminAppointmentDateRangeField({required this.filter});

  final AdminAppointmentFilter filter;

  @override
  Widget build(BuildContext context) {
    final start = DateTime(
      filter.from.year,
      filter.from.month,
      filter.from.day,
    );
    final end = DateTime(
      filter.through.year,
      filter.through.month,
      filter.through.day,
    );
    return AppPickerField(
      label: LocaleKeys.admin_appointmentsPage_dateRange.translate(),
      value: AppFormatters.formatShortDateRange(start, end, context: context),
      icon: Icons.keyboard_arrow_down,
      enabled: true,
      isSelected: true,
      onTap: () async {
        final selected = await showDateRangePicker(
          context: context,
          firstDate: DateTime(AdminAppointmentConstants.firstSelectableYear),
          lastDate: DateTime(AdminAppointmentConstants.lastSelectableYear),
          initialDateRange: DateTimeRange(start: start, end: end),
        );
        if (selected == null || !context.mounted) return;
        context.read<AdminAppointmentsCubit>().selectDateRange(
          CalendarDate.fromDateTime(selected.start),
          CalendarDate.fromDateTime(selected.end),
        );
      },
    );
  }
}
