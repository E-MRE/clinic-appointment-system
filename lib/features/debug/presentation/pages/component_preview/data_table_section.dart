part of 'component_preview_page.dart';

/// Demonstrates appointment and service table content.
final class _DataTableSection extends StatelessWidget {
  const _DataTableSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s16,
      children: [
        for (final density in AppTableDensity.values)
          _PreviewAppointmentsTable(density: density),
        const _PreviewServicesTable(),
      ],
    );
  }
}
