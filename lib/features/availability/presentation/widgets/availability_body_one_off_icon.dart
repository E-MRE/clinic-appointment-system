part of 'availability_body.dart';

/// Tertiary calendar tile identifying a dated extra window.
final class _AvailabilityOneOffIcon extends StatelessWidget {
  const _AvailabilityOneOffIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.availabilityCalendarTile,
      height: AppSizes.availabilityCalendarTile,
      decoration: BoxDecoration(
        color: context.colorScheme.tertiaryContainer,
        borderRadius: const AppRadius.small(),
      ),
      child: Icon(
        Icons.calendar_today_outlined,
        size: AppSizes.availabilityCalendarIcon,
        color: context.colorScheme.onTertiaryContainer,
      ),
    );
  }
}
