import 'package:flutter/widgets.dart';

/// Exposes [child] to assistive technologies only as [label].
///
/// The child's own semantics are excluded so the label is announced once;
/// with [liveRegion] the label is re-announced when it changes.
final class AnnouncedSemantics extends StatelessWidget {
  const AnnouncedSemantics({
    required this.label,
    required this.child,
    this.liveRegion = true,
    super.key,
  });

  final String label;
  final bool liveRegion;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      liveRegion: liveRegion,
      child: ExcludeSemantics(child: child),
    );
  }
}
