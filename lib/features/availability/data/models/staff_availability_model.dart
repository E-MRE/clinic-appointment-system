import 'package:clinic_appointment_system/features/availability/data/converters/one_off_windows_converter.dart';
import 'package:clinic_appointment_system/features/availability/data/converters/weekly_windows_converter.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/one_off_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/weekly_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';
import 'package:json_annotation/json_annotation.dart';

part 'staff_availability_model.g.dart';

/// Firestore representation; composition is required because [StaffAvailability]
/// is final and uses factories.
@JsonSerializable()
final class StaffAvailabilityModel {
  /// Creates a stored schedule.
  const StaffAvailabilityModel({
    required this.branchId,
    required this.weekly,
    required this.oneOff,
  });

  /// Creates a model from an aggregate.
  StaffAvailabilityModel.fromEntity(StaffAvailability entity)
    : this(
        branchId: entity.branchId,
        weekly: entity.weekly,
        oneOff: entity.oneOff,
      );

  /// Parses the stored fields, ignoring the server timestamp.
  factory StaffAvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$StaffAvailabilityModelFromJson(json);

  /// The branch saved with the schedule.
  final String branchId;

  /// The recurring windows.
  @WeeklyWindowsConverter()
  final List<WeeklyWindow> weekly;

  /// The dated windows.
  @OneOffWindowsConverter()
  final List<OneOffWindow> oneOff;

  /// Builds an aggregate using the current profile's identifiers.
  StaffAvailability toEntity(AvailabilitySubject subject) {
    return StaffAvailability(
      staffId: subject.staffId,
      branchId: subject.branchId,
      weekly: weekly,
      oneOff: oneOff,
    );
  }

  /// Serializes the stored fields without the server timestamp.
  Map<String, dynamic> toJson() => _$StaffAvailabilityModelToJson(this);
}
