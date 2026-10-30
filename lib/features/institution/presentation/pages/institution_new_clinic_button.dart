part of 'institution_page.dart';

/// Opens the clinic creation dialog from the selector.
final class _InstitutionNewClinicButton extends StatelessWidget {
  const _InstitutionNewClinicButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => showDialog<void>(
        context: context,
        builder: (_) =>
            _ClinicNameDialog(selection: InstitutionSelectionScope.of(context)),
      ),
      icon: const Icon(Icons.add),
      label: AppText.label(LocaleKeys.institution_newClinic.tr()),
    );
  }
}
