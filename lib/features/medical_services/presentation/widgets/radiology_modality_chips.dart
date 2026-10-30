part of 'radiology_form_section.dart';

/// Filter chips row for selecting the radiology imaging modality.
final class _RadiologyModalityChips extends StatelessWidget {
  const _RadiologyModalityChips();

  @override
  Widget build(BuildContext context) {
    final selectedModality = context
        .select<MedicalServiceFormCubit, RadiologyModality>(
          (c) => c.state.modality,
        );
    final formCubit = context.read<MedicalServiceFormCubit>();

    return AppFilterChips<RadiologyModality>(
      choices: _modalityChoices,
      selected: selectedModality,
      onSelected: formCubit.selectModality,
    );
  }

  List<AppChoice<RadiologyModality>> get _modalityChoices {
    return [
      for (final modality in RadiologyModality.values)
        AppChoice(value: modality, label: modality.label),
    ];
  }
}
