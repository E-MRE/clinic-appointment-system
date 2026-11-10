part of 'patient_appointments_page.dart';

/// Outlined department row with its bookable service count.
final class _PatientAppointmentsDepartmentRow extends StatelessWidget {
  const _PatientAppointmentsDepartmentRow({required this.summary});

  final PatientDepartmentSummary summary;

  @override
  Widget build(BuildContext context) {
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
