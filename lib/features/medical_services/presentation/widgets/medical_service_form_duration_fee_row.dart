part of 'medical_service_form.dart';

/// Dual-input row configuring allocated duration in minutes and fee in Turkish Lira.
final class _MedicalServiceFormDurationFeeRow extends StatelessWidget
    with InstitutionInputValidationMixin, MedicalServiceInputValidationMixin {
  const _MedicalServiceFormDurationFeeRow();

  @override
  Widget build(BuildContext context) {
    final formCubit = context.read<MedicalServiceFormCubit>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSizes.s12,
      children: [
        Expanded(
          child: AppTextField(
            label: LocaleKeys.services_durationLabel.tr(),
            helper: LocaleKeys.services_durationHelper.tr(),
            keyboardType: TextInputType.number,
            initialValue: formCubit.state.durationText,
            onChanged: formCubit.changeDuration,
            validator: (value) => durationInputError(value ?? '')?.message,
          ),
        ),
        Expanded(
          child: AppTextField(
            label: LocaleKeys.services_feeLabel.tr(),
            helper: LocaleKeys.services_feeHelper.tr(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: formCubit.state.feeText,
            onChanged: formCubit.changeFee,
            validator: (value) => feeInputError(value ?? '')?.message,
          ),
        ),
      ],
    );
  }
}
