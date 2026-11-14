part of 'admin_appointments_page.dart';

/// Shows filtered counts beside the patient search field.
final class _AdminAppointmentsTableHeader extends StatelessWidget {
  const _AdminAppointmentsTableHeader({
    required this.state,
    required this.searchController,
  });

  final AdminAppointmentsLoaded state;
  final TextEditingController searchController;

  int get _noAppointments => 0;

  Widget get _summary {
    return Wrap(
      spacing: AppSizes.s8,
      runSpacing: AppSizes.s4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AppText.bodyStrong(
          '${state.filteredAppointments.length} ${LocaleKeys.admin_appointmentsPage_appointmentCount.translate()}',
        ),
        for (final status in AdminStatusFilter.values)
          if ((state.statusCounts[status] ?? _noAppointments) > _noAppointments)
            AppText.body(
              '· ${state.statusCounts[status]} ${status.label.toLowerCase()}',
              tone: TextTone.muted,
            ),
      ],
    );
  }

  Widget _searchField(BuildContext context) {
    return AppTextField(
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
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const AppPadding.allLg(),
      child: context.screenSize.isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSizes.s12,
              children: [_summary, _searchField(context)],
            )
          : Row(
              spacing: AppSizes.s20,
              children: [
                Expanded(child: _summary),
                SizedBox(
                  width: AppSizes.progressWidthMd,
                  child: _searchField(context),
                ),
              ],
            ),
    );
  }
}
