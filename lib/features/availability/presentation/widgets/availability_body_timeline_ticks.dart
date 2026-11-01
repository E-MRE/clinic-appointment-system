part of 'availability_body.dart';

/// Tick labels share precisely the same leading and trailing columns as rows.
final class _AvailabilityTimelineTicks extends StatelessWidget {
  const _AvailabilityTimelineTicks({required this.timeline});
  final AvailabilityTimeline timeline;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSizes.s16,
      children: [
        SizedBox(
          width: context.screenSize.select(
            mobile: AppSizes.availabilityTimelineLabelTablet,
            tablet: AppSizes.availabilityTimelineLabelTablet,
            desktop: AppSizes.s96,
          ),
        ),
        Expanded(
          child: SizedBox(
            height: AppSizes.s24,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    for (final tick in timeline.ticks)
                      Positioned(
                        left: timeline.fractionOf(tick) * constraints.maxWidth,
                        child: FractionalTranslation(
                          translation: _tickTranslation,
                          child: AppText.caption('$tick', tone: TextTone.muted),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
        if (context.screenSize.isDesktop) const SizedBox(width: AppSizes.s40),
      ],
    );
  }

  /// Centers the tick label at its axis position.
  Offset get _tickTranslation => const Offset(-0.5, 0);
}
