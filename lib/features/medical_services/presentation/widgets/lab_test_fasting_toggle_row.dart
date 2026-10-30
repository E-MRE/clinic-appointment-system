part of 'lab_test_form_section.dart';

/// Toggle row for specifying whether a laboratory test requires fasting.
final class _LabTestFastingToggleRow extends StatelessWidget {
  const _LabTestFastingToggleRow();

  @override
  Widget build(BuildContext context) {
    final requiresFasting = context.select<MedicalServiceFormCubit, bool>(
      (c) => c.state.requiresFasting,
    );
    final formCubit = context.read<MedicalServiceFormCubit>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.bodyStrong(LocaleKeys.services_requiresFasting.tr()),
        Switch(value: requiresFasting, onChanged: formCubit.toggleFasting),
      ],
    );
  }
}
