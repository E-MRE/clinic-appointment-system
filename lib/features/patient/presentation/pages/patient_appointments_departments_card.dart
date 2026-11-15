part of 'patient_appointments_page.dart';

/// Departments offering bookable services; each opens the booking page.
final class _PatientAppointmentsDepartmentsCard extends StatelessWidget {
  const _PatientAppointmentsDepartmentsCard({required this.departments});

  final List<PatientDepartmentSummary> departments;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      padding: AppSurfacePadding.comfortable,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s12,
        children: [
          Semantics(
            header: true,
            child: AppText.cardTitle(
              LocaleKeys.patient_appointments_departmentsTitle.translate(),
            ),
          ),
          for (final summary in departments)
            _buildDepartmentRow(context, summary),
        ],
      ),
    );
  }

  /// Builds one department row that opens its booking page.
  Widget _buildDepartmentRow(
    BuildContext context,
    PatientDepartmentSummary summary,
  ) {
    final colors = context.colorScheme;
    return Material(
      color: colors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: const AppRadius.medium(),
        side: BorderSide(
          color: colors.outlineVariant,
          width: AppSizes.borderThin,
        ),
      ),
      child: AppListTile(
        title: summary.department.name,
        density: AppListTileDensity.dense,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSizes.s8,
          children: [
            AppText.caption(summary.serviceCountLabel, tone: TextTone.muted),
            Icon(
              Icons.chevron_right,
              size: AppSizes.s20,
              color: colors.onSurfaceVariant,
            ),
          ],
        ),
        onTap: () {
          context.go(AppRoutes.patientBookForDepartment(summary.department.id));
        },
      ),
    );
  }
}
