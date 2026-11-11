part of 'staff_requests_page.dart';

/// Top header of the request detail panel showing the patient avatar,
/// display name, and relative requested age.
final class _StaffRequestDetailHeader extends StatelessWidget {
  const _StaffRequestDetailHeader({required this.request});

  final Appointment request;

  @override
  Widget build(BuildContext context) {
    final clock = AppDependency.injector.get<Clock>();

    return Row(
      spacing: AppSizes.s12,
      children: [
        AppAvatar(initials: request.patientInitials, size: AppAvatarSize.large),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSizes.s4,
            children: [
              AppText.cardTitle(request.displayPatientName),
              AppText.caption(
                request.requestedAgoLabel(clock.now()),
                tone: TextTone.muted,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
