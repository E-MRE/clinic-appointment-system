part of 'admin_home_page.dart';

/// Shows the overview title, current date and branch actions.
final class _AdminHomeHeader extends StatelessWidget {
  const _AdminHomeHeader({required this.clock});

  final Clock clock;

  @override
  Widget build(BuildContext context) {
    final today = clock.now();
    final subtitle = LocaleKeys.admin_overview_todaySubtitle.translate(
      args: [
        today.toWeekday().label,
        AppFormatters.formatLongDate(today, context: context),
      ],
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        const actions = _AdminHomeHeaderActions();
        if (constraints.maxWidth >=
            AdminLayoutConstants.overviewHeaderActionsInlineMinWidth) {
          return PageHeader(
            title: LocaleKeys.admin_overview_title.translate(),
            subtitle: subtitle,
            actions: actions,
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSizes.s12,
          children: [
            PageHeader(
              title: LocaleKeys.admin_overview_title.translate(),
              subtitle: subtitle,
            ),
            const Align(alignment: Alignment.centerLeft, child: actions),
          ],
        );
      },
    );
  }
}
