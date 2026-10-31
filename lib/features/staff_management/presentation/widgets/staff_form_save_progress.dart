part of 'staff_form.dart';

/// Announces saving progress inside the disabled submit button.
final class _StaffFormSaveProgress extends StatelessWidget {
  const _StaffFormSaveProgress();

  @override
  Widget build(BuildContext context) {
    return AnnouncedSemantics(
      label: LocaleKeys.staff_saving.tr(),
      child: SizedBox.square(
        dimension: AppSizes.s20,
        child: CircularProgressIndicator(
          strokeWidth: AppSizes.s2,
          color: context.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
