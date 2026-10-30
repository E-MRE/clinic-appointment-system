part of 'institution_page.dart';

/// Clinic selector and new-clinic action.
final class _InstitutionClinicPicker extends StatelessWidget {
  const _InstitutionClinicPicker({required this.clinics, required this.clinic});

  final List<Clinic> clinics;
  final Clinic clinic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSelectField<String>(
          label: LocaleKeys.institution_selectClinic.tr(),
          value: clinic.id,
          options: [
            for (final item in clinics)
              AppSelectOption(value: item.id, label: item.name),
          ],
          onChanged: (value) {
            if (value case final selected?) {
              InstitutionSelectionScope.read(context).selectClinic(selected);
            }
          },
        ),
        const EmptySize.s12Height(),
        const _InstitutionNewClinicButton(),
      ],
    );
  }
}
