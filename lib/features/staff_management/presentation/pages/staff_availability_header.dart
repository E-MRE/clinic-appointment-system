part of 'staff_availability_page.dart';

/// Shows the staff identity and a return action above availability content.
final class _StaffAvailabilityHeader extends StatelessWidget {
  const _StaffAvailabilityHeader({required this.staff});

  final Staff staff;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.go(AppRoutes.adminStaff),
          tooltip: LocaleKeys.common_back.tr(),
          icon: const Icon(Icons.arrow_back),
        ),
        Expanded(
          child: PageHeader(
            title: LocaleKeys.availability_title.tr(),
            subtitle: context
                .watch<StaffDepartmentListCubit>()
                .state
                .subtitleFor(staff),
          ),
        ),
      ],
    );
  }
}
