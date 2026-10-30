part of 'medical_services_page.dart';

/// Small placeholder message when a kind filter produces an empty list.
final class _MedicalServicesFilteredEmpty extends StatelessWidget {
  const _MedicalServicesFilteredEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const AppPadding.allXl(),
        child: AppText.body(
          LocaleKeys.services_filterEmpty.tr(),
          tone: TextTone.muted,
        ),
      ),
    );
  }
}
