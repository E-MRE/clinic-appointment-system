import 'package:clinic_appointment_system/core/constants/entity_constants.dart';
import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/core/data/converters/calendar_date_converter.dart';
import 'package:clinic_appointment_system/core/data/extensions/firestore_guarded_transaction.dart';
import 'package:clinic_appointment_system/core/errors/app_exception.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/appointments/data/converters/booked_slot_converter.dart';
import 'package:clinic_appointment_system/features/appointments/data/models/appointment_model.dart';
import 'package:clinic_appointment_system/features/appointments/data/models/booking_day_model.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/errors/appointment_exception.dart';
import 'package:clinic_appointment_system/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:clinic_appointment_system/features/appointments/domain/results/appointment_booking_result.dart';
import 'package:clinic_appointment_system/features/appointments/domain/results/appointment_result.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_violation.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Persists appointments and their two busy-day projections atomically.
/// Expected provider and decoding failures are returned rather than thrown.
final class FirestoreAppointmentRepository implements AppointmentRepository {
  /// Injects the Firestore instance shared by appointments and projections.
  const FirestoreAppointmentRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _appointments =>
      _firestore.collection(FirestoreConstants.appointments);

  @override
  Future<AppointmentBookingResult> book(
    Appointment candidate,
    List<AppointmentViolation> Function(List<BookedSlot>, List<BookedSlot>)
    check,
  ) async {
    if (candidate.id != EntityConstants.unsavedId ||
        candidate.status != AppointmentStatus.pending ||
        candidate.history.length != _initialHistoryLength) {
      return const AppointmentBookingResult.error(
        AppointmentErrorCode.invalidTransition,
      );
    }
    try {
      // Generate once, outside the retryable transaction, for both projections.
      final reference = _appointments.doc();
      final saved = candidate.withId(reference.id);
      final slot = saved.bookedSlot;
      if (slot == null) {
        return const AppointmentBookingResult.error(
          AppointmentErrorCode.invalidTransition,
        );
      }
      final staffDay = _staffDay(saved.staffId, saved.date);
      final patientDay = _patientDay(saved.patientId, saved.date);
      return await _firestore.runGuardedTransaction((transaction) async {
        final staffSnapshot = await transaction.get(staffDay);
        final patientSnapshot = await transaction.get(patientDay);
        final staff = _decode(
          () =>
              BookingDayModel.fromJson(staffSnapshot.id, staffSnapshot.data()),
        );
        final patient = _decode(
          () => BookingDayModel.fromJson(
            patientSnapshot.id,
            patientSnapshot.data(),
          ),
        );
        final violations = check(staff.slots, patient.slots);
        if (violations.isNotEmpty) {
          return AppointmentBookingResult.violations(violations);
        }
        transaction.set(reference, AppointmentModel.fromEntity(saved).toJson());
        transaction.set(staffDay, staff.appending(slot));
        transaction.set(patientDay, patient.appending(slot));
        return AppointmentBookingResult.success(saved);
      });
    } on FirebaseException {
      return const AppointmentBookingResult.error(
        AppointmentErrorCode.unavailable,
      );
    } on AppointmentException catch (error) {
      return AppointmentBookingResult.error(error.code);
    }
  }

  /// A new booking carries only its initial pending entry.
  static const int _initialHistoryLength = 1;

  @override
  Future<AppointmentResult> changeStatus(
    String id,
    AppointmentResult Function(Appointment current) change,
  ) async {
    try {
      final reference = _appointments.doc(id);
      return await _firestore.runGuardedTransaction((transaction) async {
        final snapshot = await transaction.get(reference);
        final data = snapshot.data();
        if (!snapshot.exists) {
          return const AppointmentResult.error(AppointmentErrorCode.notFound);
        }
        final current = _decode(
          () => AppointmentModel.fromJson(
            snapshot.id,
            _requiredData(data),
          ).appointment,
        );
        final result = change(current);
        final next = result.appointment;
        if (result.isNotSuccess || next == null) return result;
        transaction.update(
          reference,
          AppointmentModel.fromEntity(next).transitionJson(),
        );
        if (current.occupiesSlot && !next.occupiesSlot) {
          final slot = current.bookedSlot;
          if (slot != null) {
            final removal = {
              FirestoreConstants.slots: FieldValue.arrayRemove([
                const BookedSlotConverter().toJson(slot),
              ]),
              FirestoreConstants.lastAppointmentId: current.id,
              FirestoreConstants.updatedAt: FieldValue.serverTimestamp(),
            };
            // Staff/admin can write these paired removals without reading patient days.
            transaction.set(
              _staffDay(current.staffId, current.date),
              removal,
              SetOptions(merge: true),
            );
            transaction.set(
              _patientDay(current.patientId, current.date),
              removal,
              SetOptions(merge: true),
            );
          }
        }
        return result;
      });
    } on FirebaseException {
      return const AppointmentResult.error(AppointmentErrorCode.unavailable);
    } on AppointmentException catch (error) {
      return AppointmentResult.error(error.code);
    }
  }

  @override
  Stream<DataResult<List<Appointment>>> watchPatientAppointments(
    String patientId,
  ) async* {
    try {
      yield* _watchAppointments(
        _appointments.where(FirestoreConstants.patientId, isEqualTo: patientId),
      );
    } on FirebaseException {
      yield DataResult.error(message: AppointmentErrorCode.unavailable.name);
    }
  }

  @override
  Stream<DataResult<List<Appointment>>> watchStaffAppointments(
    String staffId,
    CalendarDate from,
    CalendarDate through,
  ) async* {
    try {
      yield* _watchAppointments(
        _appointments
            .where(FirestoreConstants.staffId, isEqualTo: staffId)
            .where(
              FirestoreConstants.date,
              isGreaterThanOrEqualTo: const CalendarDateConverter().toJson(
                from,
              ),
            )
            .where(
              FirestoreConstants.date,
              isLessThanOrEqualTo: const CalendarDateConverter().toJson(
                through,
              ),
            ),
      );
    } on FirebaseException {
      yield DataResult.error(message: AppointmentErrorCode.unavailable.name);
    }
  }

  Stream<DataResult<List<Appointment>>> _watchAppointments(
    Query<Map<String, dynamic>> query,
  ) async* {
    try {
      await for (final snapshot
          in query
              .orderBy(FirestoreConstants.date)
              .orderBy(FirestoreConstants.start)
              .snapshots()) {
        try {
          final appointments = _decode(
            () => snapshot.docs
                .map(
                  (doc) =>
                      AppointmentModel.fromJson(doc.id, doc.data()).appointment,
                )
                .toList(),
          );
          yield DataResult.success(data: List.unmodifiable(appointments));
        } on AppointmentException catch (error) {
          yield DataResult.error(message: error.code.name);
        }
      }
    } on FirebaseException {
      yield DataResult.error(message: AppointmentErrorCode.unavailable.name);
    }
  }

  @override
  Stream<DataResult<List<BookedSlot>>> watchStaffBookedSlots(
    String staffId,
    CalendarDate date,
  ) async* {
    try {
      await for (final snapshot in _staffDay(staffId, date).snapshots()) {
        try {
          final day = _decode(
            () => BookingDayModel.fromJson(snapshot.id, snapshot.data()),
          );
          yield DataResult.success(data: day.slots);
        } on AppointmentException catch (error) {
          yield DataResult.error(message: error.code.name);
        }
      }
    } on FirebaseException {
      yield DataResult.error(message: AppointmentErrorCode.unavailable.name);
    }
  }

  DocumentReference<Map<String, dynamic>> _staffDay(
    String id,
    CalendarDate date,
  ) => _day(FirestoreConstants.staffBookings, id, date);

  DocumentReference<Map<String, dynamic>> _patientDay(
    String id,
    CalendarDate date,
  ) => _day(FirestoreConstants.patientBookings, id, date);

  DocumentReference<Map<String, dynamic>> _day(
    String collection,
    String id,
    CalendarDate date,
  ) {
    return _firestore
        .collection(collection)
        .doc(id)
        .collection(FirestoreConstants.days)
        .doc(const CalendarDateConverter().toJson(date));
  }

  Map<String, dynamic> _requiredData(Map<String, dynamic>? data) {
    if (data == null) {
      throw const FormatException('An appointment must contain data.');
    }
    return data;
  }

  T _decode<T>(T Function() read) {
    try {
      return read();
    } on AppException {
      throw const AppointmentException(AppointmentErrorCode.invalidRecord);
    } on TypeError {
      throw const AppointmentException(AppointmentErrorCode.invalidRecord);
    } on ArgumentError {
      throw const AppointmentException(AppointmentErrorCode.invalidRecord);
    } on FormatException {
      throw const AppointmentException(AppointmentErrorCode.invalidRecord);
    }
  }
}
