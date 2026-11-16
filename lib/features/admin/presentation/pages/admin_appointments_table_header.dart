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
    return Padding(
      padding: const AppPadding.allLg(),
      child: context.screenSize.isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSizes.s12,
              children: [
                _AdminAppointmentsTableHeaderSummary(state: state),
                _searchField(context),
              ],
            )
          : Row(
              spacing: AppSizes.s20,
              children: [
                Expanded(
                  child: _AdminAppointmentsTableHeaderSummary(state: state),
                ),
                SizedBox(
                  width: AppSizes.progressWidthMd,
                  child: _searchField(context),
                ),
              ],
            ),
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
}
