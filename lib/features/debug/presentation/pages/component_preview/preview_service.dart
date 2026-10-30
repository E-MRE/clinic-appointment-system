part of 'component_preview_page.dart';

/// Sample service row shown by the services table preview.
final class _PreviewService {
  const _PreviewService({
    required this.nameKey,
    required this.durationMinutes,
    required this.fee,
  });

  /// Rows rendered by the services table preview.
  static const List<_PreviewService> samples = [
    _PreviewService(
      nameKey: LocaleKeys.services_examination,
      durationMinutes: 30,
      fee: 500,
    ),
    _PreviewService(
      nameKey: LocaleKeys.services_labTest,
      durationMinutes: 15,
      fee: 250,
    ),
  ];

  final String nameKey;
  final int durationMinutes;
  final num fee;
}
