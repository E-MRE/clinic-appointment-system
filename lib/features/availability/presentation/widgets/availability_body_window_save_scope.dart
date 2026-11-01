part of 'availability_body.dart';

/// Shares success cleanup between modal editors and the persistent panel.
final class _AvailabilityWindowSaveScope extends StatelessWidget {
  const _AvailabilityWindowSaveScope({
    required this.child,
    this.closesOnSaved = true,
  });
  final Widget child;
  final bool closesOnSaved;

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      AvailabilityWindowAddCubit,
      AvailabilityWindowSaveState
    >(
      listener: (context, state) {
        if (state is AvailabilityWindowSaved) {
          if (closesOnSaved) Navigator.of(context).pop();
          context.read<AvailabilityWindowDraftCubit>().reset(
            keepsRepeat: !closesOnSaved,
          );
          context.read<AvailabilityWindowAddCubit>().reset();
        }
      },
      child: child,
    );
  }
}
