part of 'state_layout.dart';

/// Inner column containing state icon, message, and optional actions.
final class _StateContent extends StatelessWidget {
  const _StateContent({
    required this.title,
    required this.message,
    required this.icon,
    required this.iconBackground,
    required this.iconSize,
    required this.variant,
    required this.primaryAction,
    required this.secondaryAction,
  });

  final String title;
  final String message;
  final Widget icon;
  final Color iconBackground;
  final double iconSize;
  final StateLayoutVariant variant;
  final Widget? primaryAction;
  final Widget? secondaryAction;

  @override
  Widget build(BuildContext context) {
    final screenSize = context.screenSize;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StateIcon(
          icon: icon,
          background: iconBackground,
          size: iconSize,
          shape: variant.iconShape,
        ),
        const EmptySize.s24Height(),
        _StateMessage(
          title: title,
          message: message,
          maxWidth: variant.messageMaxWidth(screenSize),
          messageRole: variant.messageRole(screenSize),
        ),
        _StateActionSlot(
          primaryAction: primaryAction,
          secondaryAction: secondaryAction,
        ),
      ],
    );
  }
}
