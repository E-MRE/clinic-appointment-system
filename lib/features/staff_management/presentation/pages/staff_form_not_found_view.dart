part of 'staff_form_page.dart';

/// Empty state scaffold displayed when the requested staff profile cannot be found.
final class _StaffFormNotFoundView extends StatelessWidget {
  const _StaffFormNotFoundView();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: EmptyState(
        title: LocaleKeys.staff_notFoundTitle.tr(),
        message: LocaleKeys.staff_notFoundMessage.tr(),
        icon: const Icon(Icons.search_off),
        iconBackground: context.colorScheme.surfaceContainerHighest,
      ),
    );
  }
}
