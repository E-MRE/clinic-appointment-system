part of 'state_layout.dart';

/// Centered primary and secondary state actions.
final class _StateActions extends StatelessWidget {
  const _StateActions({this.primaryAction, this.secondaryAction});

  final Widget? primaryAction;
  final Widget? secondaryAction;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSizes.s12,
      runSpacing: AppSizes.s8,
      children: [?secondaryAction, ?primaryAction],
    );
  }
}
