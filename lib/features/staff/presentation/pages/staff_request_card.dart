part of 'staff_requests_page.dart';

/// One selectable pending request card with avatar, name, schedule and age.
final class _StaffRequestCard extends StatelessWidget {
  const _StaffRequestCard({
    required this.request,
    required this.isSelected,
    required this.onTap,
  });

  final Appointment request;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final clock = AppDependency.injector.get<Clock>();
    final surfaceVariant = isSelected
        ? AppSurfaceVariant.highlighted
        : AppSurfaceVariant.plain;

    return Semantics(
      selected: isSelected,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: const AppRadius.medium(),
          onTap: onTap,
          child: AppSurface(
            variant: surfaceVariant,
            padding: AppSurfacePadding.compact,
            child: Row(
              spacing: AppSizes.s12,
              children: [
                AppAvatar(initials: request.patientInitials),
                Expanded(child: _buildCardBody(clock)),
                Icon(
                  Icons.chevron_right,
                  size: AppSizes.s20,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _buildCardBody(Clock clock) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSizes.s4,
      children: [
        AppText.bodyStrong(request.displayPatientName),
        AppText.caption(request.scheduleAndServiceLabel, tone: TextTone.muted),
        AppText.caption(
          request.requestedAgoLabel(clock.now()),
          tone: TextTone.muted,
        ),
      ],
    );
  }
}
