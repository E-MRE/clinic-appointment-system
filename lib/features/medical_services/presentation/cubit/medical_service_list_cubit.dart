import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/watch_medical_services_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_list_loaded.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/enums/medical_service_kind_filter.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/medical_service_kind_filter_matching.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/services/medical_service_overview_calculator.dart';

/// Observes the medical services belonging to one branch at a time.
final class MedicalServiceListCubit
    extends
        InstitutionListCubit<
          MedicalService,
          String,
          WatchMedicalServicesUseCase
        > {
  /// Creates a medical service observer whose first branch is supplied by [watch].
  MedicalServiceListCubit(super.watchUseCase, this._overviewCalculator);

  final MedicalServiceOverviewCalculator _overviewCalculator;
  List<Department> _departments = const [];
  MedicalServiceKindFilter _filter = MedicalServiceKindFilter.all;

  /// Supplies the latest department records used by overview and grouping.
  void updateDepartments(List<Department> departments) {
    _departments = List<Department>.unmodifiable(departments);
    _refreshLoaded();
  }

  /// Supplies the active filter used by the list's derived presentation data.
  void updateFilter(MedicalServiceKindFilter filter) {
    _filter = filter;
    _refreshLoaded();
  }

  /// Starts or replaces the medical service observation for [branchId].
  Future<void> watch(String branchId) {
    _departments = const [];
    return watchWith(branchId);
  }

  @override
  Future<void> clear() {
    _departments = const [];
    return super.clear();
  }

  @override
  InstitutionListState<MedicalService> loadedState(List<MedicalService> data) {
    final items = List<MedicalService>.unmodifiable(data);
    final overview = _overviewCalculator.calculate(
      services: items,
      departments: _departments,
    );
    final filteredServices = <MedicalService>[
      for (final service in items)
        if (_filter.matches(service)) service,
    ];
    final immutableFilteredServices = List<MedicalService>.unmodifiable(
      filteredServices,
    );
    final groups = _overviewCalculator.groupServices(
      services: immutableFilteredServices,
      overview: overview,
    );
    return MedicalServiceListLoaded(
      items: items,
      overview: overview,
      filteredServices: immutableFilteredServices,
      groups: groups,
    );
  }

  void _refreshLoaded() {
    final currentState = state;
    if (currentState is InstitutionListLoaded<MedicalService>) {
      emit(loadedState(currentState.items));
    }
  }
}
