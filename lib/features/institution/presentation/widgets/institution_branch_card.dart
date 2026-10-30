import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/presentation/extensions/working_hours_summary.dart';
import 'package:flutter/material.dart';

/// Mobile branch summary with location and weekly hours.
final class InstitutionBranchCard extends StatelessWidget {
  const InstitutionBranchCard({
    required this.branch,
    required this.onTap,
    super.key,
  });
  final Branch branch;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppText.cardTitle(branch.name),
            const EmptySize.s4Height(),
            AppText.body(branch.address, tone: TextTone.muted),
            const EmptySize.s8Height(),
            AppText.caption(branch.workingHours.localizedSummary),
          ],
        ),
      ),
    );
  }
}
