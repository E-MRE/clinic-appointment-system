part of 'medical_service_form_page.dart';

/// Loading indicator scaffold while medical services are being fetched.
final class _MedicalServiceFormLoadingView extends StatelessWidget {
  const _MedicalServiceFormLoadingView();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: LoadingState(
        variant: LoadingStateVariant.centeredIndicator,
        label: LocaleKeys.institution_loading.tr(),
      ),
    );
  }
}
