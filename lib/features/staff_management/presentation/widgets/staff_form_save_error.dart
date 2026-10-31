part of 'staff_form.dart';

/// Localizes authentication and profile failures at the form boundary.
final class _StaffFormSaveError extends StatelessWidget {
  const _StaffFormSaveError();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StaffSaveCubit, StaffSaveState>(
      builder: (context, state) {
        final message = switch (state) {
          StaffSaveAuthFailure(:final code) => code.message,
          StaffSaveProfileFailure(:final code) => code.staffMessage,
          _ => null,
        };
        if (message == null) return const SizedBox.shrink();
        return Semantics(
          liveRegion: true,
          child: AppText.caption(message, tone: TextTone.error),
        );
      },
    );
  }
}
