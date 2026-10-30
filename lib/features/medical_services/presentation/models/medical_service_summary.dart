/// Immutable display summary for a medical service row or card.
final class MedicalServiceSummary {
  /// Creates a display summary with table subtitle, type line and detail.
  const MedicalServiceSummary({
    required this.tableSubtitle,
    required this.typeLine,
    required this.detail,
  });

  /// Subtitle shown under the service name in desktop and tablet table rows.
  final String tableSubtitle;

  /// Kind, modality and duration line shown in mobile cards
  /// (e.g. `"Muayene · 20 dk"`, `"Radyoloji · Röntgen · 15 dk"`).
  final String typeLine;

  /// Secondary description shown in mobile cards.
  final String detail;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MedicalServiceSummary &&
            runtimeType == other.runtimeType &&
            tableSubtitle == other.tableSubtitle &&
            typeLine == other.typeLine &&
            detail == other.detail;
  }

  @override
  int get hashCode => Object.hash(tableSubtitle, typeLine, detail);

  @override
  String toString() =>
      'MedicalServiceSummary(tableSubtitle: $tableSubtitle, typeLine: $typeLine, detail: $detail)';
}
