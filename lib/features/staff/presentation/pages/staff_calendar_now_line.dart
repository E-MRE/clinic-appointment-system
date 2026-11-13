part of 'staff_calendar_page.dart';

/// Current-time horizontal line and marker dot positioned on today's calendar column.
final class _StaffCalendarNowLine extends StatelessWidget {
  const _StaffCalendarNowLine({
    required this.nowFraction,
    required this.totalHeight,
    super.key,
  });

  final double nowFraction;
  final double totalHeight;

  /// Height of the current-time horizontal indicator.
  double get _nowLineHeight => 2;

  /// Diameter of the indicator dot anchored on the current-time line.
  double get _nowDotSize => 8;

  /// Divisor used to center elements vertically or horizontally on their axis.
  double get _halvingDivisor => 2;

  @override
  Widget build(BuildContext context) {
    final top = nowFraction * totalHeight;
    final color = context.colorScheme.error;

    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: top - (_nowLineHeight / _halvingDivisor),
          left: 0,
          right: 0,
          child: Container(height: _nowLineHeight, color: color),
        ),
        Positioned(
          top: top - (_nowDotSize / _halvingDivisor),
          left: -(_nowDotSize / _halvingDivisor),
          child: Container(
            width: _nowDotSize,
            height: _nowDotSize,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
      ],
    );
  }
}
