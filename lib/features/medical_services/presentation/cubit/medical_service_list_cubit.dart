import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/watch_medical_services_use_case.dart';

/// Observes the medical services belonging to one branch at a time.
final class MedicalServiceListCubit
    extends
        InstitutionListCubit<
          MedicalService,
          String,
          WatchMedicalServicesUseCase
        > {
  /// Creates a medical service observer whose first branch is supplied by [watch].
  MedicalServiceListCubit(super.watchUseCase);

  /// Starts or replaces the medical service observation for [branchId].
  Future<void> watch(String branchId) => watchWith(branchId);
}
