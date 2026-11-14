part of 'admin_appointments_page.dart';

/// Toggles any combination of appointment status groups and clears filters.
final class _AdminAppointmentsFilterStatuses extends StatelessWidget {
  const _AdminAppointmentsFilterStatuses({
    required this.filter,
    required this.onClearFilters,
  });

  final AdminAppointmentFilter filter;
  final ValueChanged<BuildContext> onClearFilters;

  @override
  Widget build(BuildContext context) {
    if (!context.screenSize.isMobile) {
      return Row(
        spacing: AppSizes.s12,
        children: [
          AppText.label(LocaleKeys.admin_appointmentsPage_status.translate()),
          Expanded(child: _buildChips(context)),
          _clearButton(context),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s8,
      children: [
        Row(
          spacing: AppSizes.s12,
          children: [
            AppText.label(LocaleKeys.admin_appointmentsPage_status.translate()),
            Expanded(child: _buildChips(context)),
          ],
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: _clearButton(context),
        ),
      ],
    );
  }

  Widget _buildChips(BuildContext context) {
    return AppMultiFilterChips<AdminStatusFilter>(
      choices: [
        for (final status in AdminStatusFilter.values)
          AppChoice<AdminStatusFilter>(value: status, label: status.label),
      ],
      selected: filter.statuses,
      onSelectionChanged: context.read<AdminAppointmentsCubit>().selectStatuses,
    );
  }

  TextButton _clearButton(BuildContext context) {
    return TextButton(
      onPressed: filter.hasNonDateFilters
          ? () => onClearFilters(context)
          : null,
      child: AppText.label(
        LocaleKeys.admin_appointmentsPage_clearFilters.translate(),
        color: filter.hasNonDateFilters
            ? context.colorScheme.primary
            : context.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
