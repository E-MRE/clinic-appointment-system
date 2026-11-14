part of 'admin_appointments_page.dart';

/// Displays the current range and bounded previous/next page controls.
final class _AdminAppointmentsTableFooter extends StatelessWidget {
  const _AdminAppointmentsTableFooter({required this.state});

  final AdminAppointmentsLoaded state;

  int get _firstPage => 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const AppPadding.allLg(),
      child: Row(
        children: [
          AppText.caption(state.rangeLabel, tone: TextTone.muted),
          const Spacer(),
          IconButton(
            tooltip: LocaleKeys.admin_appointmentsPage_previousPage.translate(),
            style: _buttonStyle(context),
            onPressed: state.currentPage > _firstPage
                ? context.read<AdminAppointmentsCubit>().previousPage
                : null,
            icon: const Icon(Icons.chevron_left),
          ),
          const EmptySize.s8Width(),
          IconButton(
            tooltip: LocaleKeys.admin_appointmentsPage_nextPage.translate(),
            style: _buttonStyle(context),
            onPressed: state.currentPage < state.pageCount
                ? context.read<AdminAppointmentsCubit>().nextPage
                : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  ButtonStyle _buttonStyle(BuildContext context) {
    return IconButton.styleFrom(
      foregroundColor: context.colorScheme.onSurfaceVariant,
      side: BorderSide(color: context.colorScheme.outline),
      shape: const CircleBorder(),
      minimumSize: const Size(AppSizes.s40, AppSizes.s40),
      padding: const AppPadding.none(),
    );
  }
}
