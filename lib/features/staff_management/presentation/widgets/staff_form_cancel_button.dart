part of 'staff_form.dart';

/// Invokes the host's cancellation action unless a save is in progress.
final class _StaffFormCancelButton extends StatelessWidget {
  const _StaffFormCancelButton({required this.onCancel});

  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StaffSaveCubit, StaffSaveState>(
      builder: (context, state) {
        return TextButton(
          onPressed: state is StaffSaveSaving ? null : onCancel,
          child: AppText.label(LocaleKeys.staff_cancel.tr()),
        );
      },
    );
  }
}
