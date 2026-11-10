part of 'availability_body.dart';

/// Tertiary calendar tile identifying a dated extra window.
final class _AvailabilityOneOffIcon extends StatelessWidget {
  const _AvailabilityOneOffIcon();

  @override
  Widget build(BuildContext context) {
    return const AppIconTile(
      icon: Icons.calendar_today_outlined,
      variant: AppIconTileVariant.tertiary,
    );
  }
}
