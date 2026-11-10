part of 'staff_form.dart';

/// Localizes authentication and profile failures at the form boundary.
final class _StaffFormSaveError extends StatelessWidget {
  const _StaffFormSaveError();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StaffSaveCubit, StaffSaveState>(
      builder: (context, state) {
        final String? message;
        if (state is StaffSaveAuthFailure) {
          message = state.code.message;
        } else if (state is StaffSaveProfileFailure) {
          message = state.code.staffMessage;
        } else {
          message = null;
        }
        if (message == null) return const SizedBox.shrink();
        return Semantics(
          liveRegion: true,
          child: AppText.caption(message, tone: TextTone.error),
        );
      },
    );
  }
}
