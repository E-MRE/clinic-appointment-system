import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/models/department_service_group.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/models/medical_service_list_overview.dart';

/// Loaded medical services together with models calculated by their cubit.
final class MedicalServiceListLoaded
    extends InstitutionListLoaded<MedicalService> {
  /// Creates a loaded service list and its overview, filter result and groups.
  const MedicalServiceListLoaded({
    required List<MedicalService> items,
    required this.overview,
    required this.filteredServices,
    required this.groups,
  }) : super(items);

  /// Aggregate counts and department lookup data for all loaded services.
  final MedicalServiceListOverview overview;

  /// Services matching the active kind filter.
  final List<MedicalService> filteredServices;

  /// Filtered services grouped for the mobile list.
  final List<DepartmentServiceGroup> groups;
}
