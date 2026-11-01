import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/appointment_status_change.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Adapts audit entries to Firestore timestamps inside arrays.
final class AppointmentHistoryConverter {
  /// Creates an audit converter.
  const AppointmentHistoryConverter();

  /// Parses the oldest-first audit entries; invalid fields fail decoding.
  List<AppointmentStatusChange> fromJson(List<dynamic> entries) {
    return entries.map((entry) {
      final json = Map<String, dynamic>.from(entry as Map);
      return AppointmentStatusChange(
        status: AppointmentStatus.values.byName(
          json[FirestoreConstants.status] as String,
        ),
        byUserId: json[FirestoreConstants.byUserId] as String,
        byRole: UserRole.values.byName(
          json[FirestoreConstants.byRole] as String,
        ),
        at: (json[FirestoreConstants.at] as Timestamp).toDate(),
      );
    }).toList();
  }

  /// Uses client time because server timestamp sentinels cannot appear in arrays.
  List<Map<String, dynamic>> toJson(List<AppointmentStatusChange> entries) {
    return entries
        .map(
          (entry) => <String, dynamic>{
            FirestoreConstants.status: entry.status.name,
            FirestoreConstants.byUserId: entry.byUserId,
            FirestoreConstants.byRole: entry.byRole.name,
            FirestoreConstants.at: Timestamp.fromDate(entry.at),
          },
        )
        .toList();
  }
}
