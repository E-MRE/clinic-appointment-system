part of 'staff_form.dart';

/// Explains temporary-password sharing and the owner's retained session.
final class _StaffFormPasswordHelp extends StatelessWidget {
  const _StaffFormPasswordHelp();

  @override
  Widget build(BuildContext context) {
    return AppText.caption(
      LocaleKeys.staff_passwordHelp.tr(),
      tone: TextTone.muted,
    );
  }
}
