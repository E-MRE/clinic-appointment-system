part of 'component_preview_page.dart';

/// Demonstrates service rows in a wide table.
final class _PreviewServicesTable extends StatelessWidget {
  const _PreviewServicesTable();

  @override
  Widget build(BuildContext context) {
    return AppDataTable<_PreviewService>(
      rows: _PreviewService.samples,
      minWidth: AppSizes.previewDesktopWidth,
      rowVerticalPadding: AppSizes.s8,
      columns: _columns,
    );
  }

  List<AppTableColumn<_PreviewService>> get _columns {
    return [
      AppTableColumn(
        label: LocaleKeys.componentPreview_table_service.translate(),
        cellBuilder: (context, row) =>
            _PreviewServiceCell(name: row.nameKey.translate()),
      ),
      AppTableColumn(
        label: LocaleKeys.componentPreview_table_duration.translate(),
        alignment: AppTableAlignment.end,
        cellBuilder: (context, row) => AppText.body(
          LocaleKeys.componentPreview_table_durationMinutes.translate(
            args: ['${row.durationMinutes}'],
          ),
        ),
      ),
      AppTableColumn(
        label: LocaleKeys.componentPreview_table_fee.translate(),
        alignment: AppTableAlignment.end,
        cellBuilder: (context, row) => AppText.bodyStrong(
          AppFormatters.formatCurrency(
            row.fee,
            decimalDigits: 0,
            context: context,
          ),
        ),
      ),
      AppTableColumn(
        label: '',
        semanticsLabel: LocaleKeys.componentPreview_table_actions.translate(),
        alignment: AppTableAlignment.end,
        cellBuilder: (context, row) => IconButton(
          onPressed: () {},
          tooltip: LocaleKeys.common_edit.translate(),
          icon: const Icon(Icons.edit_outlined),
        ),
      ),
    ];
  }
}
