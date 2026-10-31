part of 'app_message_banner.dart';

/// Layout of the banner's icon and message.
final class _MessageBannerContent extends StatelessWidget {
  const _MessageBannerContent({
    required this.message,
    required this.variant,
    required this.icon,
  });
  final String message;
  final AppMessageBannerVariant variant;
  final IconData? icon;

  IconData? get _icon => icon ?? variant.defaultIcon;

  @override
  Widget build(BuildContext context) {
    final style = variant.style;
    final icon = _icon;
    return Container(
      padding: style.padding,
      decoration: BoxDecoration(
        color: variant.background(context.colorScheme),
        borderRadius: const AppRadius.medium(),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: style.iconSize,
              color: variant.foreground(context.colorScheme),
            ),
            style.iconGap,
          ],
          Expanded(
            child: AppText(message, role: style.textRole, tone: variant.tone),
          ),
        ],
      ),
    );
  }
}
