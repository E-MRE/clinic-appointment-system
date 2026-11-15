part of 'admin_appointments_page.dart';

/// Keeps search, empty feedback and pagination inside the table surface.
final class _AdminAppointmentsEmptyTable extends StatelessWidget {
  const _AdminAppointmentsEmptyTable({
    required this.header,
    required this.footer,
  });

  final Widget header;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      padding: AppSurfacePadding.none,
      radius: AppTableDensity.regular.radius,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,
          Divider(
            height: AppSizes.borderThin,
            color: context.colorScheme.outlineVariant,
          ),
          EmptyState(
            title: LocaleKeys.admin_appointmentsPage_emptyTitle.translate(),
            message: LocaleKeys.admin_appointmentsPage_emptyMessage.translate(),
            icon: Icon(
              Icons.search_off,
              color: context.colorScheme.onSurfaceVariant,
            ),
            iconBackground: context.colorScheme.surfaceContainerHigh,
            iconSize: AppSizes.s40,
          ),
          Divider(
            height: AppSizes.borderThin,
            color: context.colorScheme.outlineVariant,
          ),
          footer,
        ],
      ),
    );
  }
}
