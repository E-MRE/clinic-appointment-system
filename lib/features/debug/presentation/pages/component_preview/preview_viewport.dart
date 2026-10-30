part of 'component_preview_page.dart';

/// Sizes and scrolls the selected preview viewport.
final class _PreviewViewport extends StatelessWidget {
  const _PreviewViewport({required this.width, required this.theme});

  final _PreviewWidth width;
  final _PreviewTheme theme;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(
          width.width ?? constraints.maxWidth,
          MediaQuery.sizeOf(context).height,
        );
        final screenSize = BreakpointsConstants.resolve(
          size.width,
          size.height,
        );
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: size.width,
            child: _PreviewThemedViewport(
              size: size,
              screenSize: screenSize,
              theme: theme,
            ),
          ),
        );
      },
    );
  }
}
