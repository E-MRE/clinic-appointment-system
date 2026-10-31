import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/watch_services_of_branches_use_case.dart';

/// Observes medical services across the selected clinic branches.
final class StaffServiceListCubit
    extends
        InstitutionListCubit<
          MedicalService,
          List<String>,
          WatchServicesOfBranchesUseCase
        > {
  /// Injects the typed observation use case.
  StaffServiceListCubit(super.watchUseCase);

  /// Starts or replaces the observation.
  Future<void> watch(List<String> branchIds) => watchWith(branchIds);
}
