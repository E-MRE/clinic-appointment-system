part of 'component_preview_page.dart';

/// Simulates a viewport tier while allowing horizontal scrolling in narrow windows.
final class _TierPreview extends StatelessWidget {
  const _TierPreview({required this.width, required this.child});
  final double width;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final size = Size(width, AppSizes.previewHeight);
    final tier = BreakpointsConstants.resolve(size.width, size.height);
    final brightness = Theme.of(context).brightness;
    final theme = switch (brightness) {
      Brightness.light => LightTheme(tier).themeData,
      Brightness.dark => DarkTheme(tier).themeData,
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: size.width,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(size: size),
          child: Theme(data: theme, child: child),
        ),
      ),
    );
  }
}
