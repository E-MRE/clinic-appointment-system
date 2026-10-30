part of 'component_preview_page.dart';

/// Sample appointment row shown by the appointments table preview.
final class _PreviewAppointment {
  const _PreviewAppointment({
    required this.patientName,
    required this.patientInitials,
    required this.dateTime,
    required this.serviceKey,
    required this.staffName,
  });

  /// Rows rendered at every table density.
  static final List<_PreviewAppointment> samples = [
    _PreviewAppointment(
      patientName: 'Ayşe Yılmaz',
      patientInitials: 'AY',
      dateTime: DateTime(2026, 10, 26, 10, 30),
      serviceKey: LocaleKeys.services_examination,
      staffName: 'Dr. Demir',
    ),
    _PreviewAppointment(
      patientName: 'Mehmet Kaya',
      patientInitials: 'MK',
      dateTime: DateTime(2026, 10, 26, 11, 15),
      serviceKey: LocaleKeys.services_radiology,
      staffName: 'Dr. Aydın',
    ),
  ];

  final String patientName;
  final String patientInitials;
  final DateTime dateTime;
  final String serviceKey;
  final String staffName;
}
