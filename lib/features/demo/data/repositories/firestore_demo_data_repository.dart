import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/core/data/converters/calendar_date_converter.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/appointments/data/models/appointment_model.dart';
import 'package:clinic_appointment_system/features/appointments/data/models/booking_day_model.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';
import 'package:clinic_appointment_system/features/availability/data/models/staff_availability_model.dart';
import 'package:clinic_appointment_system/features/demo/domain/enums/demo_error_code.dart';
import 'package:clinic_appointment_system/features/demo/domain/models/demo_data_set.dart';
import 'package:clinic_appointment_system/features/demo/domain/repositories/demo_data_repository.dart';
import 'package:clinic_appointment_system/features/institution/data/models/branch_model.dart';
import 'package:clinic_appointment_system/features/institution/data/models/clinic_model.dart';
import 'package:clinic_appointment_system/features/institution/data/models/department_model.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/medical_service_model_factory.dart';
import 'package:clinic_appointment_system/features/staff_management/data/visitors/staff_document_visitor.dart';
import 'package:clinic_appointment_system/features/users/data/models/patient_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Replaces seeded records while preserving user and appointment documents
/// that do not carry the demo marker.
final class FirestoreDemoDataRepository implements DemoDataRepository {
  /// Injects Firestore and the existing service model factory.
  const FirestoreDemoDataRepository(this._firestore, this._serviceModels);

  final FirebaseFirestore _firestore;
  final MedicalServiceModelFactory _serviceModels;

  /// Deletes prior seed records and writes the supplied records in batches.
  @override
  Future<DataResult<void>> replace(DemoDataSet set) async {
    try {
      final conflict = await _hasDeterministicIdConflict(set);
      if (conflict) {
        return const DataResult.error(
          errorCode: DemoErrorCode.recordIdConflict,
        );
      }
      await _deleteInstitutionRecords();
      await _deleteDemoRecords(
        retainedUserIds: <String>{
          set.staff[_firstProfileIndex].id,
          set.patients[_firstProfileIndex].id,
        },
      );
      await _writeDataSet(set);
      return const DataResult.success(data: null);
    } on FirebaseException {
      return const DataResult.error(errorCode: DemoErrorCode.unavailable);
    } on Exception {
      return const DataResult.error(errorCode: DemoErrorCode.invalidScenario);
    }
  }

  /// Removes only demo-marked records and leaves all unmarked records intact.
  @override
  Future<DataResult<void>> clear() async {
    try {
      await _deleteDemoInstitutionRecords();
      await _deleteDemoRecords();
      return const DataResult.success(data: null);
    } on FirebaseException {
      return const DataResult.error(errorCode: DemoErrorCode.unavailable);
    } on Exception {
      return const DataResult.error(errorCode: DemoErrorCode.invalidScenario);
    }
  }

  /// value = 500
  int get _maximumBatchWrites => 500;

  /// value = 3
  int get _maximumAppointmentBatchWrites => 3;

  /// value = 4
  int get _maximumProjectionBatchWrites => 4;

  /// value = 1
  int get _firstProfileIndex => 0;

  /// value = 1
  int get _firstNonLinkedProfileIndex => 1;

  Future<bool> _hasDeterministicIdConflict(DemoDataSet set) async {
    final users = _firestore.collection(FirestoreConstants.users);
    final linkedIds = <String>{
      set.staff[_firstProfileIndex].id,
      set.patients[_firstProfileIndex].id,
    };
    for (final staff in set.staff.skip(_firstNonLinkedProfileIndex)) {
      final snapshot = await users.doc(staff.id).get();
      if (_isNonDemoDocument(snapshot)) return true;
    }
    for (final patient in set.patients.skip(_firstNonLinkedProfileIndex)) {
      if (linkedIds.contains(patient.id)) continue;
      final snapshot = await users.doc(patient.id).get();
      if (_isNonDemoDocument(snapshot)) return true;
    }
    final availability = _firestore.collection(
      FirestoreConstants.staffAvailability,
    );
    for (final schedule in set.availabilities.skip(
      _firstNonLinkedProfileIndex,
    )) {
      final snapshot = await availability.doc(schedule.staffId).get();
      if (_isNonDemoDocument(snapshot)) return true;
    }
    final appointments = _firestore.collection(FirestoreConstants.appointments);
    for (final appointment in set.appointments) {
      final snapshot = await appointments.doc(appointment.id).get();
      if (_isNonDemoDocument(snapshot)) return true;
    }
    final checkedProjectionPaths = <String>{};
    for (final reference in _bookingProjectionReferences(set)) {
      final isNewProjectionPath = checkedProjectionPaths.add(reference.path);
      if (isNewProjectionPath) {
        final snapshot = await reference.get();
        if (_isNonDemoDocument(snapshot)) return true;
      }
    }
    return false;
  }

  Iterable<DocumentReference<Map<String, dynamic>>>
  _bookingProjectionReferences(DemoDataSet set) sync* {
    for (final appointment in set.appointments) {
      final slot = appointment.bookedSlot;
      if (slot == null) continue;
      yield _bookingProjectionReference(
        FirestoreConstants.staffBookings,
        appointment.staffId,
        slot,
      );
      yield _bookingProjectionReference(
        FirestoreConstants.patientBookings,
        appointment.patientId,
        slot,
      );
    }
  }

  DocumentReference<Map<String, dynamic>> _bookingProjectionReference(
    String collection,
    String ownerId,
    BookedSlot slot,
  ) {
    final dateId = const CalendarDateConverter().toJson(slot.date);
    return _firestore
        .collection(collection)
        .doc(ownerId)
        .collection(FirestoreConstants.days)
        .doc(dateId);
  }

  bool _isNonDemoDocument(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.exists &&
        snapshot.data()?[FirestoreConstants.isDemo] != true;
  }

  Future<void> _deleteInstitutionRecords() async {
    await _deleteDocuments(_firestore.collection(FirestoreConstants.services));
    await _deleteDocuments(
      _firestore.collection(FirestoreConstants.departments),
    );
    await _deleteDocuments(_firestore.collection(FirestoreConstants.branches));
    await _deleteDocuments(_firestore.collection(FirestoreConstants.clinics));
  }

  Future<void> _deleteDemoInstitutionRecords() async {
    await _deleteDemoDocuments(FirestoreConstants.services);
    await _deleteDemoDocuments(FirestoreConstants.departments);
    await _deleteDemoDocuments(FirestoreConstants.branches);
    await _deleteDemoDocuments(FirestoreConstants.clinics);
  }

  Future<void> _deleteDemoRecords({
    Set<String> retainedUserIds = const <String>{},
  }) async {
    await _deleteDocuments(
      _firestore
          .collection(FirestoreConstants.users)
          .where(FirestoreConstants.isDemo, isEqualTo: true),
      retainedIds: retainedUserIds,
    );
    await _deleteDocuments(
      _firestore
          .collection(FirestoreConstants.staffAvailability)
          .where(FirestoreConstants.isDemo, isEqualTo: true),
    );
    await _deleteDocuments(
      _firestore
          .collection(FirestoreConstants.appointments)
          .where(FirestoreConstants.isDemo, isEqualTo: true),
    );
    await _deleteDemoBookingProjections();
  }

  Future<void> _deleteDemoDocuments(String collection) async {
    await _deleteDocuments(
      _firestore
          .collection(collection)
          .where(FirestoreConstants.isDemo, isEqualTo: true),
    );
  }

  Future<void> _deleteDemoBookingProjections() async {
    final snapshot = await _firestore
        .collectionGroup(FirestoreConstants.days)
        .where(FirestoreConstants.isDemo, isEqualTo: true)
        .get();
    final references = snapshot.docs
        .where((document) => _isBookingProjection(document.reference))
        .map((document) => document.reference)
        .toList();
    await _deleteReferences(references);
  }

  bool _isBookingProjection(DocumentReference<Map<String, dynamic>> reference) {
    final collection = reference.parent.parent?.parent.id;
    return collection == FirestoreConstants.staffBookings ||
        collection == FirestoreConstants.patientBookings;
  }

  Future<void> _deleteDocuments(
    Query<Map<String, dynamic>> query, {
    Set<String> retainedIds = const <String>{},
  }) async {
    final snapshot = await query.get();
    List<DocumentReference<Map<String, dynamic>>> pendingDeletes = [];
    for (final document in snapshot.docs) {
      if (retainedIds.contains(document.id)) continue;
      pendingDeletes.add(document.reference);
      if (pendingDeletes.length == _maximumBatchWrites) {
        await _deleteReferences(pendingDeletes);
        pendingDeletes = <DocumentReference<Map<String, dynamic>>>[];
      }
    }
    if (pendingDeletes.isNotEmpty) {
      await _deleteReferences(pendingDeletes);
    }
  }

  Future<void> _deleteReferences(
    List<DocumentReference<Map<String, dynamic>>> references,
  ) async {
    for (
      int offset = 0;
      offset < references.length;
      offset += _maximumBatchWrites
    ) {
      final batch = _firestore.batch();
      for (final reference
          in references.skip(offset).take(_maximumBatchWrites)) {
        batch.delete(reference);
      }
      await batch.commit();
    }
  }

  Future<void> _writeDataSet(DemoDataSet set) async {
    final documents =
        <
          MapEntry<
            DocumentReference<Map<String, dynamic>>,
            Map<String, dynamic>
          >
        >[];
    final clinics = _firestore.collection(FirestoreConstants.clinics);
    final branches = _firestore.collection(FirestoreConstants.branches);
    final departments = _firestore.collection(FirestoreConstants.departments);
    final services = _firestore.collection(FirestoreConstants.services);
    final users = _firestore.collection(FirestoreConstants.users);
    final availability = _firestore.collection(
      FirestoreConstants.staffAvailability,
    );
    final appointments = _firestore.collection(FirestoreConstants.appointments);

    _addDocument(
      documents,
      clinics.doc(set.clinic.id),
      ClinicModel.fromEntity(set.clinic).toJson(),
    );
    for (final branch in set.branches) {
      _addDocument(
        documents,
        branches.doc(branch.id),
        BranchModel.fromEntity(branch).toJson(),
      );
    }
    for (final department in set.departments) {
      _addDocument(
        documents,
        departments.doc(department.id),
        DepartmentModel.fromEntity(department).toJson(),
      );
    }
    for (final service in set.services) {
      _addDocument(
        documents,
        services.doc(service.id),
        _serviceModels.toModel(service).toJson(),
      );
    }
    for (final staff in set.staff) {
      final fields = staff.accept(const StaffDocumentVisitor());
      if (staff.id == set.staff[_firstProfileIndex].id) {
        _addLinkedDoctorAssignment(documents, users.doc(staff.id), fields);
      } else {
        _addDocument(documents, users.doc(staff.id), {
          ...fields,
          FirestoreConstants.createdAt: FieldValue.serverTimestamp(),
        });
      }
    }
    for (final patient in set.patients) {
      if (patient.id == set.patients[_firstProfileIndex].id) continue;
      _addDocument(documents, users.doc(patient.id), {
        ...PatientModel.fromEntity(patient).toJson(),
        FirestoreConstants.createdAt: FieldValue.serverTimestamp(),
      });
    }
    for (final schedule in set.availabilities) {
      final fields = {
        ...StaffAvailabilityModel.fromEntity(schedule).toJson(),
        FirestoreConstants.updatedAt: FieldValue.serverTimestamp(),
      };
      if (schedule.staffId == set.staff[_firstProfileIndex].id) {
        _addUnmarkedDocument(
          documents,
          availability.doc(schedule.staffId),
          fields,
        );
      } else {
        _addDocument(documents, availability.doc(schedule.staffId), fields);
      }
    }
    for (final appointment in set.appointments) {
      _addDocument(
        documents,
        appointments.doc(appointment.id),
        AppointmentModel.fromEntity(appointment).toJson(),
      );
      final slot = appointment.bookedSlot;
      if (slot == null) continue;
      _addBookingProjection(
        documents,
        FirestoreConstants.staffBookings,
        appointment.staffId,
        slot,
      );
      _addBookingProjection(
        documents,
        FirestoreConstants.patientBookings,
        appointment.patientId,
        slot,
      );
    }

    final foundationDocuments =
        <
          MapEntry<
            DocumentReference<Map<String, dynamic>>,
            Map<String, dynamic>
          >
        >[];
    final appointmentDocuments =
        <
          MapEntry<
            DocumentReference<Map<String, dynamic>>,
            Map<String, dynamic>
          >
        >[];
    final projectionDocuments =
        <
          MapEntry<
            DocumentReference<Map<String, dynamic>>,
            Map<String, dynamic>
          >
        >[];
    for (final document in documents) {
      final reference = document.key;
      if (_isBookingProjection(reference)) {
        projectionDocuments.add(document);
      } else if (reference.parent.id == FirestoreConstants.appointments) {
        appointmentDocuments.add(document);
      } else {
        foundationDocuments.add(document);
      }
    }
    await _writeDocumentsInBatches(
      foundationDocuments,
      set,
      _maximumBatchWrites,
    );
    await _writeDocumentsInBatches(
      appointmentDocuments,
      set,
      _maximumAppointmentBatchWrites,
    );
    await _writeDocumentsInBatches(
      projectionDocuments,
      set,
      _maximumProjectionBatchWrites,
    );
  }

  Future<void> _writeDocumentsInBatches(
    List<
      MapEntry<DocumentReference<Map<String, dynamic>>, Map<String, dynamic>>
    >
    documents,
    DemoDataSet set,
    int maximumWrites,
  ) async {
    for (int offset = 0; offset < documents.length; offset += maximumWrites) {
      final batch = _firestore.batch();
      for (final document in documents.skip(offset).take(maximumWrites)) {
        final reference = document.key;
        final fields = document.value;
        final keepAccountProfile =
            reference.parent.id == FirestoreConstants.users &&
            _isLinkedAccountId(reference.id, set);
        if (keepAccountProfile) {
          batch.set(reference, fields, SetOptions(merge: true));
        } else {
          batch.set(reference, fields);
        }
      }
      await batch.commit();
    }
  }

  void _addLinkedDoctorAssignment(
    List<
      MapEntry<DocumentReference<Map<String, dynamic>>, Map<String, dynamic>>
    >
    documents,
    DocumentReference<Map<String, dynamic>> reference,
    Map<String, dynamic> staffFields,
  ) {
    _addUnmarkedDocument(documents, reference, {
      FirestoreConstants.branchId: staffFields[FirestoreConstants.branchId],
      FirestoreConstants.departmentId:
          staffFields[FirestoreConstants.departmentId],
      FirestoreConstants.serviceIds: staffFields[FirestoreConstants.serviceIds],
    });
  }

  void _addUnmarkedDocument(
    List<
      MapEntry<DocumentReference<Map<String, dynamic>>, Map<String, dynamic>>
    >
    documents,
    DocumentReference<Map<String, dynamic>> reference,
    Map<String, dynamic> fields,
  ) {
    documents.add(MapEntry(reference, fields));
  }

  void _addBookingProjection(
    List<
      MapEntry<DocumentReference<Map<String, dynamic>>, Map<String, dynamic>>
    >
    documents,
    String collection,
    String ownerId,
    BookedSlot slot,
  ) {
    final reference = _bookingProjectionReference(collection, ownerId, slot);
    final dateId = const CalendarDateConverter().toJson(slot.date);
    final existingIndex = documents.indexWhere(
      (document) => document.key.path == reference.path,
    );
    final existingData = existingIndex < 0
        ? null
        : documents[existingIndex].value;
    final day = BookingDayModel.fromJson(dateId, existingData);
    final fields = {...day.appending(slot), FirestoreConstants.isDemo: true};
    final projection = MapEntry(reference, fields);
    if (existingIndex < 0) {
      documents.add(projection);
    } else {
      documents[existingIndex] = projection;
    }
  }

  void _addDocument(
    List<
      MapEntry<DocumentReference<Map<String, dynamic>>, Map<String, dynamic>>
    >
    documents,
    DocumentReference<Map<String, dynamic>> reference,
    Map<String, dynamic> fields,
  ) {
    documents.add(
      MapEntry(reference, {...fields, FirestoreConstants.isDemo: true}),
    );
  }

  bool _isLinkedAccountId(String id, DemoDataSet set) {
    return id == set.staff[_firstProfileIndex].id ||
        id == set.patients[_firstProfileIndex].id;
  }
}
