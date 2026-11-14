part of 'medical_services_page.dart';

/// Responsive header displaying page title, overview subtitle and actions.
final class _MedicalServicesHeader extends StatelessWidget {
  const _MedicalServicesHeader();

  @override
  Widget build(BuildContext context) {
    final branchId = InstitutionSelectionScope.of(context).branchId;
    final String? subtitle;
    if (branchId == null) {
      subtitle = null;
    } else {
      subtitle = _resolveSubtitle(context);
    }

    return PageHeader(
      title: LocaleKeys.services_title.tr(),
      subtitle: subtitle,
      actions: const _MedicalServicesHeaderActions(),
    );
  }

  String? _resolveSubtitle(BuildContext context) {
    final serviceState = context.watch<MedicalServiceListCubit>().state;
    if (serviceState is! MedicalServiceListLoaded) {
      return null;
    }
    final formatter = AppDependency.injector
        .get<MedicalServiceOverviewFormatter>();
    return context.screenSize.select(
      mobile: formatter.mobileSubtitle(serviceState.overview),
      tablet: formatter.tabletSubtitle(serviceState.overview),
      desktop: formatter.desktopSubtitle(serviceState.overview),
    );
  }
}
