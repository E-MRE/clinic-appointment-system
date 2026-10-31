part of 'availability_body.dart';

/// Gives enlarged range labels the full row width without shrinking user text.
final class _AvailabilityDayContent extends StatelessWidget {
  const _AvailabilityDayContent({required this.day});
  final Weekday day;

  @override
  Widget build(BuildContext context) {
    final fontSize = context.textTheme.labelLarge?.fontSize ?? AppSizes.s16;
    if (context.textScaleFor(fontSize) > BreakpointsConstants.largeTextScale) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s8,
        children: [
          Row(
            children: [
              Expanded(child: AppText.bodyStrong(day.label)),
              _AvailabilityDayAddButton(day: day),
            ],
          ),
          _AvailabilityDayWindows(day: day),
        ],
      );
    }
    return Row(
      spacing: AppSizes.s12,
      children: [
        SizedBox(
          width: AppSizes.s40,
          child: AppText.bodyStrong(day.shortLabel),
        ),
        Expanded(child: _AvailabilityDayWindows(day: day)),
        _AvailabilityDayAddButton(day: day),
      ],
    );
  }
}
