/// Clipped horizontal placement on the normalized availability axis.
final class TimelineSegment {
  /// Creates the start and width fractions of a timeline segment.
  const TimelineSegment({required this.start, required this.width});

  /// Left edge as a fraction of the track width.
  final double start;

  /// Visible width as a fraction of the track width.
  final double width;
}
