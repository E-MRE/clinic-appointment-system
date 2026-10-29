part of 'component_preview_page.dart';

/// Demonstrates service rows in a wide table.
final class _PreviewServicesTable extends StatelessWidget {
  const _PreviewServicesTable();

  @override
  Widget build(BuildContext context) {
    return AppDataTable<String>(
      rows: const ['Muayene', 'Kontrol'],
      minWidth: AppSizes.previewDesktopWidth,
      rowVerticalPadding: AppSizes.s8,
      columns: _columns,
    );
  }

  List<AppTableColumn<String>> get _columns {
    return [
      AppTableColumn(
        label: 'Hizmet',
        cellBuilder: (context, row) => _PreviewServiceCell(name: row),
      ),
      AppTableColumn(
        label: 'Süre',
        alignment: AppTableAlignment.end,
        cellBuilder: (context, row) => const AppText.body('30 dk'),
      ),
      AppTableColumn(
        label: 'Ücret',
        alignment: AppTableAlignment.end,
        cellBuilder: (context, row) => const AppText.bodyStrong('₺500'),
      ),
      AppTableColumn(
        label: '',
        semanticsLabel: 'İşlemler',
        alignment: AppTableAlignment.end,
        cellBuilder: (context, row) => IconButton(
          onPressed: () {},
          tooltip: 'Düzenle',
          icon: const Icon(Icons.edit_outlined),
        ),
      ),
    ];
  }
}
