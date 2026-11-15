part of 'availability_body.dart';

/// Keeps both desktop columns readable when the shell leaves a narrow viewport.
final class _AvailabilityDesktopViewport extends StatelessWidget {
  const _AvailabilityDesktopViewport();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: const SizedBox(
              width: AppSizes.availabilityDesktopMinWidth,
              child: _AvailabilityDesktopLayout(),
            ),
          ),
        );
      },
    );
  }
}
