part of 'state_layout.dart';

/// Actions slot with top spacing for state layout.
final class _StateActionSlot extends StatelessWidget {
  const _StateActionSlot({
    required this.primaryAction,
    required this.secondaryAction,
  });

  final Widget? primaryAction;
  final Widget? secondaryAction;

  @override
  Widget build(BuildContext context) {
    if (primaryAction == null && secondaryAction == null) {
      return const SizedBox.shrink();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const EmptySize.s24Height(),
        _StateActions(
          primaryAction: primaryAction,
          secondaryAction: secondaryAction,
        ),
      ],
    );
  }
}
