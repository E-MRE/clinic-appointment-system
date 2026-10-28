import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_branches_use_case.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_cubit.dart';

/// Observes the branches belonging to one clinic at a time.
final class BranchListCubit
    extends InstitutionListCubit<Branch, String, WatchBranchesUseCase> {
  /// Creates a branch observer whose first clinic is supplied by [watch].
  BranchListCubit(super.watchUseCase);

  /// Starts or replaces the branch observation for [clinicId].
  Future<void> watch(String clinicId) => watchWith(clinicId);
}
