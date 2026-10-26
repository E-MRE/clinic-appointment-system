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
        for (final density in AppTableDensity.values) _appointments(density),
        _services(),
      ],
    );
  }

  Widget _appointments(AppTableDensity density) {
    return AppDataTable<String>(
      rows: const ['Ayşe Yılmaz', 'Mehmet Kaya'],
      minWidth: AppSizes.previewTabletWidth,
      density: density,
      rowVerticalPadding: AppSizes.s8,
      header: Padding(
        padding: const AppPadding.allLg(),
        child: AppText.cardTitle('Randevular · ${density.name}'),
      ),
      columns: [
        AppTableColumn(
          label: 'Tarih',
          noWrap: true,
          cellBuilder: (context, row) => const AppText.body('26.10.2026 10:30'),
        ),
        AppTableColumn(
          label: 'Hasta',
          cellBuilder: (context, row) => Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSizes.s8,
            children: [
              const AppAvatar(initials: 'AY', size: AppAvatarSize.small),
              AppText.bodyStrong(row),
            ],
          ),
        ),
        AppTableColumn(
          label: 'Hizmet',
          cellBuilder: (context, row) => const AppText.body('Muayene'),
        ),
        AppTableColumn(
          label: 'Personel',
          cellBuilder: (context, row) =>
              const AppText.body('Dr. Demir', tone: TextTone.muted),
        ),
        AppTableColumn(
          label: 'Durum',
          cellBuilder: (context, row) => const StatusBadge(
            label: 'Onaylandı',
            variant: StatusBadgeVariant.info,
          ),
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
      ],
    );
  }

  Widget _services() {
    return AppDataTable<String>(
      rows: const ['Muayene', 'Kontrol'],
      minWidth: AppSizes.previewDesktopWidth,
      rowVerticalPadding: AppSizes.s8,
      columns: [
        AppTableColumn(
          label: 'Hizmet',
          cellBuilder: (context, row) => Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSizes.s8,
            children: [
              const Icon(Icons.medical_services_outlined),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText.bodyStrong(row),
                  const AppText.caption('Genel hizmet', tone: TextTone.muted),
                ],
              ),
            ],
          ),
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
      ],
    );
  }
}
