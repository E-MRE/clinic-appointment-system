import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/branch_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/clinic_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/department_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/branch_repository.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/clinic_repository.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/department_repository.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/repositories/medical_service_repository.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/repositories/staff_repository.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

import 'keyed_streams.dart';

/// Key of the single clinic and staff streams.
const String catalogAllKey = 'all';

/// Catalog repositories whose streams are keyed by their parameters:
/// clinic id for branches, comma-joined branch ids for departments and
/// services, [catalogAllKey] for clinics and staff.
final class PatientCatalogRepositories
    implements
        ClinicRepository,
        BranchRepository,
        DepartmentRepository,
        MedicalServiceRepository,
        StaffRepository {
  final KeyedStreams<Clinic> clinics = KeyedStreams<Clinic>();
  final KeyedStreams<Branch> branches = KeyedStreams<Branch>();
  final KeyedStreams<Department> departments = KeyedStreams<Department>();
  final KeyedStreams<MedicalService> services = KeyedStreams<MedicalService>();
  final KeyedStreams<Staff> staff = KeyedStreams<Staff>();

  /// Thrown synchronously by [watchStaff] when set.
  Exception? staffSetupError;

  @override
  Stream<DataResult<List<Clinic>>> watchClinics() =>
      clinics.watch(catalogAllKey);

  @override
  Stream<DataResult<List<Branch>>> watchBranches(String clinicId) =>
      branches.watch(clinicId);

  @override
  Stream<DataResult<List<Department>>> watchDepartmentsOfBranches(
    List<String> branchIds,
  ) => departments.watch(branchIds.join(','));

  @override
  Stream<DataResult<List<MedicalService>>> watchServicesOfBranches(
    List<String> branchIds,
  ) => services.watch(branchIds.join(','));

  @override
  Stream<DataResult<List<Staff>>> watchStaff() {
    if (staffSetupError case final Exception error) throw error;
    return staff.watch(catalogAllKey);
  }

  Future<void> close() async {
    await clinics.close();
    await branches.close();
    await departments.close();
    await services.close();
    await staff.close();
  }

  @override
  Stream<DataResult<Branch>> watchBranch(String branchId) =>
      throw UnimplementedError();

  @override
  Stream<DataResult<List<Department>>> watchDepartments(String branchId) =>
      throw UnimplementedError();

  @override
  Stream<DataResult<List<MedicalService>>> watchServices(String branchId) =>
      throw UnimplementedError();

  @override
  Future<DataResult<Clinic>> createClinic(ClinicDraft draft) =>
      throw UnimplementedError();

  @override
  Future<DataResult<Clinic>> updateClinic(Clinic clinic) =>
      throw UnimplementedError();

  @override
  Future<DataResult<Branch>> createBranch(BranchDraft draft) =>
      throw UnimplementedError();

  @override
  Future<DataResult<Branch>> updateBranch(Branch branch) =>
      throw UnimplementedError();

  @override
  Future<DataResult<Department>> createDepartment(DepartmentDraft draft) =>
      throw UnimplementedError();

  @override
  Future<DataResult<Department>> updateDepartment(Department department) =>
      throw UnimplementedError();

  @override
  Future<DataResult<MedicalService>> createService(MedicalService service) =>
      throw UnimplementedError();

  @override
  Future<DataResult<MedicalService>> updateService(MedicalService service) =>
      throw UnimplementedError();

  @override
  Future<DataResult<Staff>> createStaff(Staff staff) =>
      throw UnimplementedError();

  @override
  Future<DataResult<Staff>> updateStaff(Staff staff) =>
      throw UnimplementedError();
}
