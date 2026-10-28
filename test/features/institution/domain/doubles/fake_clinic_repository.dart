import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/clinic_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/clinic_repository.dart';

final class FakeClinicRepository implements ClinicRepository {
  Stream<DataResult<List<Clinic>>> clinicsStream = const Stream.empty();
  DataResult<Clinic> createResult = const DataResult.error();
  DataResult<Clinic> updateResult = const DataResult.error();
  ClinicDraft? createdDraft;
  Clinic? updatedClinic;
  int createCalls = 0;
  int updateCalls = 0;

  @override
  Stream<DataResult<List<Clinic>>> watchClinics() {
    return clinicsStream;
  }

  @override
  Future<DataResult<Clinic>> createClinic(ClinicDraft draft) async {
    createCalls++;
    createdDraft = draft;
    return createResult;
  }

  @override
  Future<DataResult<Clinic>> updateClinic(Clinic clinic) async {
    updateCalls++;
    updatedClinic = clinic;
    return updateResult;
  }
}
