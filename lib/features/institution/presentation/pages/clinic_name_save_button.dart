part of 'institution_page.dart';

/// Submits a new or renamed clinic.
final class _ClinicNameSaveButton extends StatelessWidget {
  const _ClinicNameSaveButton({required this.clinic, required this.controller});

  final Clinic? clinic;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        final save = context.read<ClinicSaveCubit>();
        final name = controller.text.trim();
        if (clinic case final existing?) {
          save.update(existing, name);
        } else {
          save.create(name);
        }
      },
      child: AppText.label(
        LocaleKeys.institution_save.tr(),
        tone: TextTone.onPrimary,
      ),
    );
  }
}
