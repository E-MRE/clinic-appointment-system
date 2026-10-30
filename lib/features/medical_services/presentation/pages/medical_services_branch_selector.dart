part of 'medical_services_page.dart';

/// Compact dropdown allowing administrators to switch the active branch.
final class _MedicalServicesBranchSelector extends StatelessWidget {
  const _MedicalServicesBranchSelector();

  /// Compact width allocated for the branch selector on mobile screens.
  double get _mobileWidth => 140;

  /// Width allocated for the branch selector on tablet and desktop screens.
  double get _desktopWidth => 200;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BranchListCubit>().state;
    final branches = state is InstitutionListLoaded<Branch>
        ? state.items
        : const <Branch>[];
    final currentBranchId = InstitutionSelectionScope.of(context).branchId;
    final width = context.screenSize.isMobile ? _mobileWidth : _desktopWidth;

    return SizedBox(
      width: width,
      child: AppSelectField<String>(
        label: LocaleKeys.services_branch.tr(),
        value: currentBranchId,
        hint: LocaleKeys.services_selectBranch.tr(),
        options: [
          for (final branch in branches)
            AppSelectOption(value: branch.id, label: branch.name),
        ],
        onChanged: (branchId) {
          if (branchId != null) {
            InstitutionSelectionScope.read(context).selectBranch(branchId);
          }
        },
      ),
    );
  }
}
