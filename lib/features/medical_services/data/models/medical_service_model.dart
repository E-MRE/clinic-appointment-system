import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/features/medical_services/data/converters/money_converter.dart';
import 'package:clinic_appointment_system/features/medical_services/data/converters/service_duration_converter.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:json_annotation/json_annotation.dart';

/// The stored form of a medical service, shared by every concrete service model.
/// The id comes from the Firestore document id and is never written; the kind
/// is written so the document can be read back as the right model. A model must
/// provide [toJson].
base mixin MedicalServiceModel on MedicalService {
  /// Converts this medical service to stored document fields.
  Map<String, dynamic> toJson();

  @override
  @JsonKey(includeToJson: false)
  String get id => super.id;

  @override
  @JsonKey(includeFromJson: false, includeToJson: true)
  MedicalServiceKind get kind => super.kind;

  @override
  @JsonKey(name: FirestoreConstants.durationMinutes)
  @ServiceDurationConverter()
  ServiceDuration get duration => super.duration;

  @override
  @JsonKey(name: FirestoreConstants.feeMinorUnits)
  @MoneyConverter()
  Money get fee => super.fee;
}
