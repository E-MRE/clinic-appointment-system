part of 'patient_book_page.dart';

/// The schedule could not be observed; offers a retry.
final class _PatientBookScheduleFailure extends StatelessWidget {
  const _PatientBookScheduleFailure();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s12,
      children: [
        AppMessageBanner(
          message: LocaleKeys.patient_book_scheduleFailure.translate(),
          variant: AppMessageBannerVariant.error,
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: OutlinedButton(
            onPressed: context.read<StaffWeekScheduleCubit>().retry,
            child: Text(LocaleKeys.patient_book_retry.translate()),
          ),
        ),
      ],
    );
  }
}
