import 'package:clinic_appointment_system/features/institution/data/converters/working_hours_converter.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:json_annotation/json_annotation.dart';

part 'branch_model.g.dart';

/// The Firestore representation of a branch.
@JsonSerializable()
final class BranchModel extends Branch {
  /// Creates a branch model with its document identifier and stored fields.
  const BranchModel({
    required super.id,
    required super.clinicId,
    required super.name,
    required super.address,
    required super.workingHours,
  });

  /// Creates the stored model for [branch].
  BranchModel.fromEntity(Branch branch)
    : this(
        id: branch.id,
        clinicId: branch.clinicId,
        name: branch.name,
        address: branch.address,
        workingHours: branch.workingHours,
      );

  /// Creates a branch model from stored fields and the document id.
  factory BranchModel.fromJson(Map<String, dynamic> json) =>
      _$BranchModelFromJson(json);

  @JsonKey(includeToJson: false)
  @override
  String get id => super.id;

  @WorkingHoursConverter()
  @override
  WorkingHours get workingHours => super.workingHours;

  Map<String, dynamic> toJson() => _$BranchModelToJson(this);
}
