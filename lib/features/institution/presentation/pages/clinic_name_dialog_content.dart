part of 'institution_page.dart';

/// Name field and request feedback in the clinic dialog.
final class _ClinicNameDialogContent extends StatelessWidget {
  const _ClinicNameDialogContent({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          label: LocaleKeys.institution_clinicName.tr(),
          controller: controller,
        ),
        BlocBuilder<ClinicSaveCubit, InstitutionSaveState<Clinic>>(
          builder: (context, state) {
            if (state is InstitutionSaveFailure<Clinic>) {
              return AppText.caption(state.code.message, tone: TextTone.error);
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
