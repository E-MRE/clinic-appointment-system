part of 'lab_test_form_section.dart';

/// Dropdown selector for laboratory test result turn-around duration.
final class _LabTestResultTimeField extends StatelessWidget {
  const _LabTestResultTimeField();

  @override
  Widget build(BuildContext context) {
    final resultTime = context.select<MedicalServiceFormCubit, LabResultTime>(
      (c) => c.state.resultTime,
    );
    final formCubit = context.read<MedicalServiceFormCubit>();

    return AppSelectField<LabResultTime>(
      label: LocaleKeys.services_resultTimeLabel.tr(),
      value: resultTime,
      options: _resultTimeOptions,
      onChanged: (time) {
        if (time != null) formCubit.selectResultTime(time);
      },
    );
  }

  List<AppSelectOption<LabResultTime>> get _resultTimeOptions {
    return [
      for (final time in LabResultTime.values)
        AppSelectOption(value: time, label: time.label),
    ];
  }
}
