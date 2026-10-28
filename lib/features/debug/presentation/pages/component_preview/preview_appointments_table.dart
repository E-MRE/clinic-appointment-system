part of 'component_preview_page.dart';

/// Demonstrates appointment rows at one table density.
final class _PreviewAppointmentsTable extends StatelessWidget {
  const _PreviewAppointmentsTable({required this.density});

  final AppTableDensity density;

  @override
  Widget build(BuildContext context) {
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
}
