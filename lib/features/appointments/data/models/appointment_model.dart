import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/core/data/converters/calendar_date_converter.dart';
import 'package:clinic_appointment_system/core/data/converters/time_range_converter.dart';
import 'package:clinic_appointment_system/features/appointments/data/converters/appointment_history_converter.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore adapter composed around the final appointment aggregate.
final class AppointmentModel {
  /// Wraps an aggregate for persistence.
  const AppointmentModel.fromEntity(this.appointment);

  /// Decodes the document fields, using the document id as the entity id.
  factory AppointmentModel.fromJson(String id, Map<String, dynamic> json) {
    return AppointmentModel.fromEntity(
      Appointment.restore(
        id: id,
        patientId: json[FirestoreConstants.patientId] as String,
        staffId: json[FirestoreConstants.staffId] as String,
        branchId: json[FirestoreConstants.branchId] as String,
        departmentId: json[FirestoreConstants.departmentId] as String,
        serviceId: json[FirestoreConstants.serviceId] as String,
        serviceName: json[FirestoreConstants.serviceName] as String,
        fee: Money.minorUnits(json[FirestoreConstants.feeMinorUnits] as int),
        date: const CalendarDateConverter().fromJson(
          json[FirestoreConstants.date] as String,
        ),
        range: const TimeRangeConverter().fromJson({
          FirestoreConstants.start: json[FirestoreConstants.start],
          FirestoreConstants.end: json[FirestoreConstants.end],
        }),
        status: AppointmentStatus.values.byName(
          json[FirestoreConstants.status] as String,
        ),
        history: const AppointmentHistoryConverter().fromJson(
          json[FirestoreConstants.history] as List<dynamic>,
        ),
      ),
    );
  }

  /// The decoded or to-be-stored aggregate.
  final Appointment appointment;

  /// Serializes exactly the frozen appointment shape, without its document id.
  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.patientId: appointment.patientId,
      FirestoreConstants.staffId: appointment.staffId,
      FirestoreConstants.branchId: appointment.branchId,
      FirestoreConstants.departmentId: appointment.departmentId,
      FirestoreConstants.serviceId: appointment.serviceId,
      FirestoreConstants.serviceName: appointment.serviceName,
      FirestoreConstants.feeMinorUnits: appointment.fee.minorUnits,
      FirestoreConstants.date: const CalendarDateConverter().toJson(
        appointment.date,
      ),
      ...const TimeRangeConverter().toJson(appointment.range),
      ...transitionJson(),
      FirestoreConstants.createdAt: FieldValue.serverTimestamp(),
    };
  }

  /// The only appointment fields a status change may update.
  Map<String, dynamic> transitionJson() {
    return {
      FirestoreConstants.status: appointment.status.name,
      FirestoreConstants.history: const AppointmentHistoryConverter().toJson(
        appointment.history,
      ),
      FirestoreConstants.updatedAt: FieldValue.serverTimestamp(),
    };
  }
}
