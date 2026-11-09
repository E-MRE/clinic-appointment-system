part of 'staff_requests_page.dart';

/// Announced progress indicator shown inside the approve button.
final class _StaffRequestApproveProgress extends StatelessWidget {
  const _StaffRequestApproveProgress();

  @override
  Widget build(BuildContext context) {
    return AnnouncedSemantics(
      label: LocaleKeys.staffRequests_approving.translate(),
      child: SizedBox.square(
        dimension: AppSizes.s20,
        child: CircularProgressIndicator(
          strokeWidth: AppSizes.s2,
          color: context.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
