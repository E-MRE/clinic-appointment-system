part of 'availability_page.dart';

/// Safe empty presentation when the authenticated profile is not staff.
final class _AvailabilityNotFound extends StatelessWidget {
  const _AvailabilityNotFound();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: EmptyState(
        title: LocaleKeys.availability_notFoundTitle.translate(),
        message: LocaleKeys.availability_notFoundMessage.translate(),
        icon: Icon(
          Icons.person_outline,
          color: context.colorScheme.onSecondaryContainer,
        ),
        iconBackground: context.colorScheme.secondaryContainer,
      ),
    );
  }
}
