import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/enums/medical_service_kind_filter.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/models/medical_service_list_overview.dart';

/// Formats localized subtitles and department labels for service overviews.
final class MedicalServiceOverviewFormatter {
  /// Creates the formatter.
  const MedicalServiceOverviewFormatter();

  /// Localized header subtitle for desktop viewports.
  String desktopSubtitle(MedicalServiceListOverview overview) {
    return LocaleKeys.services_desktopSubtitle.translate(
      args: ['${overview.total}'],
    );
  }

  /// Localized header subtitle for tablet viewports.
  String tabletSubtitle(MedicalServiceListOverview overview) {
    return LocaleKeys.services_tabletSubtitle.translate(
      args: [
        '${overview.examinationCount}',
        '${overview.radiologyCount}',
        '${overview.labCount}',
      ],
    );
  }

  /// Localized header subtitle for mobile viewports.
  String mobileSubtitle(MedicalServiceListOverview overview) {
    return LocaleKeys.services_mobileSubtitle.translate(
      args: ['${overview.total}', '${overview.distinctDepartmentsCount}'],
    );
  }

  /// Localized filter chip label for [filter] including its count.
  String chipLabel(
    MedicalServiceListOverview overview,
    MedicalServiceKindFilter filter,
  ) {
    return switch (filter) {
      MedicalServiceKindFilter.all => LocaleKeys.services_chipAll.translate(
        args: ['${overview.total}'],
      ),
      MedicalServiceKindFilter.examination =>
        LocaleKeys.services_chipExamination.translate(
          args: ['${overview.examinationCount}'],
        ),
      MedicalServiceKindFilter.radiology =>
        LocaleKeys.services_chipRadiology.translate(
          args: ['${overview.radiologyCount}'],
        ),
      MedicalServiceKindFilter.lab => LocaleKeys.services_chipLab.translate(
        args: ['${overview.labCount}'],
      ),
    };
  }

  /// Human-readable name for [departmentId], or the localized fallback.
  String departmentName(
    MedicalServiceListOverview overview,
    String departmentId,
  ) {
    return overview.departmentMap[departmentId]?.name ??
        LocaleKeys.services_unknownDepartment.translate();
  }

  /// Localized group label for services with unknown departments.
  String get otherDepartmentName =>
      LocaleKeys.services_otherDepartment.translate();
}
