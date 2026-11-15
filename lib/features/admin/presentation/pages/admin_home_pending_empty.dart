part of 'admin_home_page.dart';

/// States that there are no pending requests to display.
final class _AdminHomePendingEmpty extends StatelessWidget {
  const _AdminHomePendingEmpty();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const AppPadding.allLg(),
      child: AppText.body(
        LocaleKeys.admin_overview_emptyPending.translate(),
        tone: TextTone.muted,
        textAlign: TextAlign.center,
      ),
    );
  }
}
