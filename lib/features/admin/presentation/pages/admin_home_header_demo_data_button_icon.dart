part of 'admin_home_page.dart';

/// Shows loading progress or the icon for a demo data action.
final class _AdminHomeHeaderDemoDataButtonIcon extends StatelessWidget {
  /// Creates a demo data action icon with its current progress state.
  const _AdminHomeHeaderDemoDataButtonIcon({
    required this.isLoading,
    required this.icon,
    required this.color,
  });

  final bool isLoading;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox.square(
        dimension: AppSizes.s16,
        child: CircularProgressIndicator(color: color),
      );
    }
    return Icon(icon);
  }
}
