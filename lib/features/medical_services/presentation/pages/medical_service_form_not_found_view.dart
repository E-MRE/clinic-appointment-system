part of 'medical_service_form_page.dart';

/// Empty state scaffold displayed when the requested service cannot be found.
final class _MedicalServiceFormNotFoundView extends StatelessWidget {
  const _MedicalServiceFormNotFoundView();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: EmptyState(
        title: LocaleKeys.services_notFoundTitle.tr(),
        message: LocaleKeys.services_notFoundMessage.tr(),
        icon: const Icon(Icons.search_off),
        iconBackground: context.colorScheme.surfaceContainerHighest,
      ),
    );
  }
}
