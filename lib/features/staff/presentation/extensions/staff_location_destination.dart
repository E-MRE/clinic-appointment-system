import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_destination.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_destination_navigation.dart';

/// Resolves staff navigation from a route location.
extension StaffLocationDestination on String {
  /// Matching destination, falling back to availability.
  StaffDestination get staffDestination => StaffDestination.values.firstWhere(
    (item) => item.matches(this),
    orElse: () => StaffDestination.availability,
  );
}
