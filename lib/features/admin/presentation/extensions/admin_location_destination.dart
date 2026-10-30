import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_destination.dart';
import 'package:clinic_appointment_system/features/admin/presentation/extensions/admin_destination_navigation.dart';

/// Resolves the admin destination a route location belongs to.
extension AdminLocationDestination on String {
  /// The matching destination for this location, falling back to the
  /// overview.
  AdminDestination get adminDestination {
    return AdminDestination.values.firstWhere(
      (destination) => destination.matches(this),
      orElse: () => AdminDestination.overview,
    );
  }
}
