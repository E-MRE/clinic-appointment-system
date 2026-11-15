import 'package:clinic_appointment_system/core/extensions/turkish_alphabetical_comparison.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/institution_record.dart';

/// Orders institution records by their Turkish display names.
extension InstitutionRecordNameOrdering<T extends InstitutionRecord>
    on Iterable<T> {
  /// Returns a sorted copy, leaving this iterable unchanged.
  List<T> sortedByName() {
    return toList()..sort(
      (T first, T second) =>
          first.name.compareTurkishAlphabetically(second.name),
    );
  }
}
