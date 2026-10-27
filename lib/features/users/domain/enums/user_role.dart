import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'storageValue')
/// A user profile's role, its stable storage value and what the role may do.
enum UserRole {
  /// A patient who books appointments.
  patient(storageValue: 'patient', canBookAppointments: true),

  /// A doctor who approves appointments and marks no-shows.
  doctor(
    storageValue: 'doctor',
    canApproveAppointments: true,
    canMarkNoShow: true,
  ),

  /// A technician who approves appointments.
  technician(storageValue: 'technician', canApproveAppointments: true),

  /// An administrator who manages the clinic and sees every appointment.
  admin(
    storageValue: 'admin',
    canManageClinic: true,
    canViewAllAppointments: true,
  );

  const UserRole({
    required this.storageValue,
    this.canBookAppointments = false,
    this.canApproveAppointments = false,
    this.canMarkNoShow = false,
    this.canManageClinic = false,
    this.canViewAllAppointments = false,
  });

  /// The stable, case-sensitive value stored for this role.
  final String storageValue;

  /// Whether the role may book appointments.
  final bool canBookAppointments;

  /// Whether the role may approve or reject appointment requests.
  final bool canApproveAppointments;

  /// Whether the role may mark a patient as a no-show.
  final bool canMarkNoShow;

  /// Whether the role may manage the clinic, branches, departments, services
  /// and staff.
  final bool canManageClinic;

  /// Whether the role may view every appointment.
  final bool canViewAllAppointments;

  /// Finds a role by its exact storage value.
  ///
  /// Throws [ArgumentError] when the value is unknown.
  static UserRole fromStorage(String value) {
    for (final role in values) {
      if (role.storageValue == value) {
        return role;
      }
    }
    throw ArgumentError.value(value, 'value', 'Unknown user role');
  }
}
