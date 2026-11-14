part of 'admin_appointments_page.dart';

/// Shows filtered counts beside the patient search field.
final class _AdminAppointmentsTableHeader extends StatelessWidget {
  const _AdminAppointmentsTableHeader({
    required this.state,
    required this.searchController,
  });

  final AdminAppointmentsLoaded state;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final summary = Wrap(
      spacing: AppSizes.s8,
      runSpacing: AppSizes.s4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AppText.bodyStrong(
          '${state.filteredAppointments.length} ${LocaleKeys.admin_appointmentsPage_appointmentCount.translate()}',
        ),
        for (final status in AdminStatusFilter.values)
          if ((state.statusCounts[status] ?? 0) > 0)
            AppText.body(
              '· ${state.statusCounts[status]} ${status.label.toLowerCase()}',
              tone: TextTone.muted,
            ),
      ],
    );
    final search = AppTextField(
      label: LocaleKeys.admin_appointmentsPage_searchPatient.translate(),
      hint: LocaleKeys.admin_appointmentsPage_searchPatient.translate(),
      controller: searchController,
      isLabelVisible: false,
      textInputAction: TextInputAction.search,
      prefix: Icon(
        Icons.search,
        color: context.colorScheme.onSurfaceVariant,
        size: AppSizes.s20,
      ),
      onChanged: context.read<AdminAppointmentsCubit>().searchPatient,
    );
    return Padding(
      padding: const AppPadding.allLg(),
      child: context.screenSize.isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSizes.s12,
              children: [summary, search],
            )
          : Row(
              spacing: AppSizes.s20,
              children: [
                Expanded(child: summary),
                SizedBox(width: AppSizes.progressWidthMd, child: search),
              ],
            ),
    );
  }
}
