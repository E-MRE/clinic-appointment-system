part of 'status_badge.dart';

/// Row containing status badge icon and label.
final class _StatusBadgeContent extends StatelessWidget {
  const _StatusBadgeContent({
    required this.label,
    required this.icon,
    required this.foreground,
    required this.style,
  });

  final String label;
  final IconData? icon;
  final Color foreground;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon case final iconData?) ...[
          Icon(iconData, size: AppSizes.statusIcon, color: foreground),
          const EmptySize.s4Width(),
        ],
        Text(label, style: style),
      ],
    );
  }
}
