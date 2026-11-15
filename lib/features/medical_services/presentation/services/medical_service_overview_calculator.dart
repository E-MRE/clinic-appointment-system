import 'package:clinic_appointment_system/core/extensions/iterable_count_by.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/models/department_service_group.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/models/medical_service_list_overview.dart';

/// Calculates medical service overview counts and department groupings.
final class MedicalServiceOverviewCalculator {
  /// Creates a stateless overview calculator.
  const MedicalServiceOverviewCalculator();

  /// Number returned when a service kind has no matches.
  int get _zeroCount => 0;

  /// Calculates service-kind counts and department lookup data.
  MedicalServiceListOverview calculate({
    required List<MedicalService> services,
    required List<Department> departments,
  }) {
    final kindCounts = services.countBy(
      (MedicalService service) => service.kind,
    );
    final departmentCounts = services.countBy(
      (MedicalService service) => service.departmentId,
    );
    final departmentMap = <String, Department>{
      for (final department in departments) department.id: department,
    };

    return MedicalServiceListOverview(
      total: services.length,
      examinationCount:
          kindCounts[MedicalServiceKind.examination] ?? _zeroCount,
      radiologyCount: kindCounts[MedicalServiceKind.radiology] ?? _zeroCount,
      labCount: kindCounts[MedicalServiceKind.lab] ?? _zeroCount,
      distinctDepartmentsCount: departmentCounts.length,
      departmentMap: Map<String, Department>.unmodifiable(departmentMap),
    );
  }

  /// Groups [services] by known department name, sorted alphabetically.
  /// Unknown department services are appended as one final group named
  /// [otherDepartmentName].
  List<DepartmentServiceGroup> groupServices({
    required List<MedicalService> services,
    required MedicalServiceListOverview overview,
  }) {
    final knownGroups = <String, List<MedicalService>>{};
    final otherServices = <MedicalService>[];

    for (final service in services) {
      final department = overview.departmentMap[service.departmentId];
      if (department != null) {
        knownGroups.putIfAbsent(department.name, () => []).add(service);
      } else {
        otherServices.add(service);
      }
    }

    final sortedNames = knownGroups.keys.toList()..sort();
    final groups = <DepartmentServiceGroup>[];
    for (final name in sortedNames) {
      final departmentServices = knownGroups[name];
      if (departmentServices == null) continue;
      groups.add(
        DepartmentServiceGroup(
          departmentName: name,
          services: List<MedicalService>.unmodifiable(departmentServices),
        ),
      );
    }

    if (otherServices.isNotEmpty) {
      groups.add(
        DepartmentServiceGroup(
          departmentName: null,
          services: List<MedicalService>.unmodifiable(otherServices),
        ),
      );
    }

    return List<DepartmentServiceGroup>.unmodifiable(groups);
  }
}
