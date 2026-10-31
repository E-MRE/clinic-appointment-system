part of 'availability_body.dart';

/// Aligns the reusable tablet action with either shell's supplied heading.
final class _AvailabilityHeader extends StatelessWidget {
  const _AvailabilityHeader({required this.header});
  final Widget header;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSizes.s16,
      children: [
        Expanded(child: header),
        if (context.screenSize.isTablet) const _AvailabilityAddButton(),
      ],
    );
  }
}
