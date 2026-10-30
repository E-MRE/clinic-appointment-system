part of 'medical_services_page.dart';

/// Trailing actions for the medical services page header.
final class _MedicalServicesHeaderActions extends StatelessWidget {
  const _MedicalServicesHeaderActions();

  @override
  Widget build(BuildContext context) {
    final isMobile = context.screenSize.isMobile;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: AppSizes.s8,
      children: [
        const _MedicalServicesBranchSelector(),
        if (!isMobile) const _MedicalServicesAddButton(),
      ],
    );
  }
}
