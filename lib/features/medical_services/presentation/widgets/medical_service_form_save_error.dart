part of 'medical_service_form.dart';

/// Feedback banner presenting error codes from failed save operations.
final class _MedicalServiceFormSaveError extends StatelessWidget {
  const _MedicalServiceFormSaveError();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      MedicalServiceSaveCubit,
      InstitutionSaveState<MedicalService>
    >(
      builder: (context, state) {
        if (state is! InstitutionSaveFailure<MedicalService>) {
          return const SizedBox.shrink();
        }
        return AppText.caption(state.code.message, tone: TextTone.error);
      },
    );
  }
}
