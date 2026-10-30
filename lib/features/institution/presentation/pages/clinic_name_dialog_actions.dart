part of 'institution_page.dart';

/// Cancel and save controls for the clinic dialog.
final class _ClinicNameDialogActions extends StatelessWidget {
  const _ClinicNameDialogActions({
    required this.clinic,
    required this.controller,
  });

  final Clinic? clinic;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: AppText.label(LocaleKeys.institution_cancel.tr()),
        ),
        _ClinicNameSaveButton(clinic: clinic, controller: controller),
      ],
    );
  }
}
