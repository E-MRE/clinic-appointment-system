part of 'admin_home_page.dart';

/// Shows the pending count and a shortcut to the filtered appointment list.
final class _AdminHomePendingTableHeader extends StatelessWidget {
  const _AdminHomePendingTableHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final title = LocaleKeys.admin_overview_pendingTableTitle.translate(
      args: [count.toString()],
    );
    return Padding(
      padding: const AppPadding.allLg(),
      child: Row(
        spacing: AppSizes.s16,
        children: [
          Expanded(child: AppText.bodyStrong(title)),
          TextButton(
            onPressed: () {
              context.go(AppRoutes.adminAppointmentsWithPendingStatus);
            },
            child: AppText.label(
              LocaleKeys.admin_overview_seeAll.translate(),
              color: context.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
