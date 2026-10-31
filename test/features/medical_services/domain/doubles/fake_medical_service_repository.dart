import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/repositories/medical_service_repository.dart';

final class FakeMedicalServiceRepository implements MedicalServiceRepository {
  Stream<DataResult<List<MedicalService>>> servicesStream =
      const Stream.empty();
  DataResult<MedicalService> createResult = const DataResult.error();
  DataResult<MedicalService> updateResult = const DataResult.error();
  MedicalService? createdService;
  MedicalService? updatedService;
  String? watchedBranchId;
  List<String>? watchedBranchIds;
  int createCalls = 0;
  int updateCalls = 0;
  Object? createException;
  Object? updateException;

  @override
  Stream<DataResult<List<MedicalService>>> watchServices(String branchId) {
    watchedBranchId = branchId;
    return servicesStream;
  }

  @override
  Stream<DataResult<List<MedicalService>>> watchServicesOfBranches(
    List<String> branchIds,
  ) {
    watchedBranchIds = branchIds;
    return servicesStream;
  }

  @override
  Future<DataResult<MedicalService>> createService(
    MedicalService service,
  ) async {
    createCalls++;
    createdService = service;
    if (createException case final exception?) {
      throw exception;
    }
    return createResult;
  }

  @override
  Future<DataResult<MedicalService>> updateService(
    MedicalService service,
  ) async {
    updateCalls++;
    updatedService = service;
    if (updateException case final exception?) {
      throw exception;
    }
    return updateResult;
  }
}
