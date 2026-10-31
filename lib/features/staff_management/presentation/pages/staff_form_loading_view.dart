part of 'staff_form_page.dart';

/// Loading indicator scaffold while staff profiles are being fetched.
final class _StaffFormLoadingView extends StatelessWidget {
  const _StaffFormLoadingView();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: LoadingState(
        variant: LoadingStateVariant.centeredIndicator,
        label: LocaleKeys.staff_loading.tr(),
      ),
    );
  }
}
