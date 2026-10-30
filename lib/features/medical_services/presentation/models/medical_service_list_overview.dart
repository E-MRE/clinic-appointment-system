import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/enums/medical_service_kind_filter.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/models/department_service_group.dart';

/// Precomputed counts, localized header summaries and department groupings for medical services.
final class MedicalServiceListOverview {
  /// Computes overview counts and groupings from [services] and [departments].
  factory MedicalServiceListOverview.from({
    required List<MedicalService> services,
    required List<Department> departments,
  }) {
    final departmentMap = <String, Department>{
      for (final department in departments) department.id: department,
    };
    final distinctDepartmentIds = <String>{};
    for (final service in services) {
      distinctDepartmentIds.add(service.departmentId);
    }

    return MedicalServiceListOverview._(
      total: services.length,
      examinationCount: MedicalServiceKindFilter.examination.countIn(services),
      radiologyCount: MedicalServiceKindFilter.radiology.countIn(services),
      labCount: MedicalServiceKindFilter.lab.countIn(services),
      distinctDepartmentsCount: distinctDepartmentIds.length,
      departments: departments,
      departmentMap: departmentMap,
    );
  }

  const MedicalServiceListOverview._({
    required this.total,
    required this.examinationCount,
    required this.radiologyCount,
    required this.labCount,
    required this.distinctDepartmentsCount,
    required this.departments,
    required this.departmentMap,
  });

  /// Total count of all loaded services.
  final int total;

  /// Total count of examination services.
  final int examinationCount;

  /// Total count of radiology imaging services.
  final int radiologyCount;

  /// Total count of laboratory test services.
  final int labCount;

  /// Number of distinct departments referenced by the loaded services.
  final int distinctDepartmentsCount;

  /// Available departments for name lookups.
  final List<Department> departments;

  /// Lookup map by department id.
  final Map<String, Department> departmentMap;

  /// Count of services matching [filter].
  int countFor(MedicalServiceKindFilter filter) => switch (filter) {
    MedicalServiceKindFilter.all => total,
    MedicalServiceKindFilter.examination => examinationCount,
    MedicalServiceKindFilter.radiology => radiologyCount,
    MedicalServiceKindFilter.lab => labCount,
  };

  /// Localized header subtitle for desktop viewports.
  String get desktopSubtitle =>
      LocaleKeys.services_desktopSubtitle.translate(args: ['$total']);

  /// Localized header subtitle for tablet viewports.
  String get tabletSubtitle => LocaleKeys.services_tabletSubtitle.translate(
    args: ['$examinationCount', '$radiologyCount', '$labCount'],
  );

  /// Localized header subtitle for mobile viewports.
  String get mobileSubtitle => LocaleKeys.services_mobileSubtitle.translate(
    args: ['$total', '$distinctDepartmentsCount'],
  );

  /// Localized filter chip label for [filter] including its count.
  String chipLabel(MedicalServiceKindFilter filter) => switch (filter) {
    MedicalServiceKindFilter.all => LocaleKeys.services_chipAll.translate(
      args: ['$total'],
    ),
    MedicalServiceKindFilter.examination =>
      LocaleKeys.services_chipExamination.translate(
        args: ['$examinationCount'],
      ),
    MedicalServiceKindFilter.radiology =>
      LocaleKeys.services_chipRadiology.translate(args: ['$radiologyCount']),
    MedicalServiceKindFilter.lab => LocaleKeys.services_chipLab.translate(
      args: ['$labCount'],
    ),
  };

  /// Resolves the human-readable department name for [departmentId], or `—` if unknown.
  String departmentName(String departmentId) {
    return departmentMap[departmentId]?.name ??
        LocaleKeys.services_unknownDepartment.translate();
  }

  /// Groups [servicesToGroup] by department name, sorted alphabetically, with unknown
  /// department services grouped under "Diğer" at the end.
  List<DepartmentServiceGroup> groupServices(
    List<MedicalService> servicesToGroup,
  ) {
    final knownGroups = <String, List<MedicalService>>{};
    final otherServices = <MedicalService>[];

    for (final service in servicesToGroup) {
      final department = departmentMap[service.departmentId];
      if (department != null) {
        knownGroups.putIfAbsent(department.name, () => []).add(service);
      } else {
        otherServices.add(service);
      }
    }

    final sortedNames = knownGroups.keys.toList()..sort();
    final result = <DepartmentServiceGroup>[
      for (final name in sortedNames)
        DepartmentServiceGroup(
          departmentName: name,
          services: List.unmodifiable(knownGroups[name] ?? const []),
        ),
    ];

    if (otherServices.isNotEmpty) {
      result.add(
        DepartmentServiceGroup(
          departmentName: LocaleKeys.services_otherDepartment.translate(),
          services: List.unmodifiable(otherServices),
        ),
      );
    }

    return List.unmodifiable(result);
  }
}
