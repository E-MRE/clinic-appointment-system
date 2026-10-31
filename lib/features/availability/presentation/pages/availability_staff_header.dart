part of 'availability_page.dart';

/// Staff header with responsive explanations and loaded weekly totals.
final class _AvailabilityStaffHeader extends StatelessWidget {
  const _AvailabilityStaffHeader();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StaffAvailabilityCubit>().state;
    return PageHeader(
      title: LocaleKeys.availability_title.translate(),
      subtitle: context.screenSize.select(
        mobile: LocaleKeys.availability_mobileSubtitle.translate(),
        tablet: state.withWeeklyTotal(
          LocaleKeys.availability_tabletSubtitle.translate(),
        ),
        desktop: state.withWeeklyTotal(
          LocaleKeys.availability_desktopSubtitle.translate(),
        ),
      ),
    );
  }
}
