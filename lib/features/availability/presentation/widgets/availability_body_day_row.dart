part of 'availability_body.dart';

/// One weekday with wrapped ranges and an add action only while the branch is open.
final class _AvailabilityDayRow extends StatelessWidget {
  const _AvailabilityDayRow({required this.day});
  final Weekday day;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: AppSizes.availabilityDayRow),
      padding: const AppPadding.verticalSm(),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.colorScheme.outlineVariant,
            width: AppSizes.borderThin,
          ),
        ),
      ),
      child: _AvailabilityDayContent(day: day),
    );
  }
}
