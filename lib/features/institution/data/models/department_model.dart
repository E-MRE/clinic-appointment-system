import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:json_annotation/json_annotation.dart';

part 'department_model.g.dart';

/// The Firestore representation of a department.
@JsonSerializable()
final class DepartmentModel extends Department {
  /// Creates a department model with its document identifier and stored fields.
  const DepartmentModel({
    required super.id,
    required super.branchId,
    required super.name,
  });

  /// Creates the stored model for [department].
  DepartmentModel.fromEntity(Department department)
    : this(
        id: department.id,
        branchId: department.branchId,
        name: department.name,
      );

  /// Creates a department model from stored fields and the document id.
  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentModelFromJson(json);

  @JsonKey(includeToJson: false)
  @override
  String get id => super.id;

  Map<String, dynamic> toJson() => _$DepartmentModelToJson(this);
}
