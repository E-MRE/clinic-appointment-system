part of 'availability_body.dart';

/// Owns remove feedback while keeping the header inside the observation scope.
final class _AvailabilityBodyFrame extends StatelessWidget {
  const _AvailabilityBodyFrame({required this.header});
  final Widget header;

  @override
  Widget build(BuildContext context) {
    final actions = context.read<_AvailabilityBodyActions>();
    return BlocListener<
      AvailabilityWindowSaveCubit,
      AvailabilityWindowSaveState
    >(
      // Only a remove request may publish page-level feedback. A dismissed add
      // sheet can finish later, so modal visibility alone cannot identify it.
      listenWhen: (previous, current) =>
          previous is AvailabilityWindowSaving &&
          current is AvailabilityWindowSaveFailure &&
          actions.isRemoveRequest &&
          !actions.isSheetOpen,
      listener: (context, state) {
        if (state case AvailabilityWindowSaveFailure(
          :final code,
          :final conflict,
        )) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: AppText.body(
                code.message(conflict: conflict),
                tone: TextTone.onInverse,
              ),
            ),
          );
        }
      },
      child: AppScaffold(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header,
            const EmptySize.s16Height(),
            const Expanded(child: _AvailabilityBodyContent()),
          ],
        ),
      ),
    );
  }
}
