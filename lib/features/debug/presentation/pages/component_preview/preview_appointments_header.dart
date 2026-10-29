part of 'component_preview_page.dart';

/// Card title header showing the appointment table density.
final class _PreviewAppointmentsHeader extends StatelessWidget {
  const _PreviewAppointmentsHeader({required this.density});

  final AppTableDensity density;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const AppPadding.allLg(),
      child: AppText.cardTitle('Randevular · ${density.name}'),
    );
  }
}
