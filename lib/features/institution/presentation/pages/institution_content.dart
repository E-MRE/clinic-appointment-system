part of 'institution_page.dart';

/// Layout of a selected clinic and its branch lists.
final class _InstitutionContent extends StatelessWidget {
  const _InstitutionContent({required this.clinics});

  final List<Clinic> clinics;

  @override
  Widget build(BuildContext context) {
    final selection = InstitutionSelectionScope.of(context);
    final clinic = clinics.firstWhere(
      (item) => item.id == selection.clinicId,
      orElse: () => clinics.first,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InstitutionClinicHeader(clinic: clinic),
        if (clinics.length > 1)
          _InstitutionClinicPicker(clinics: clinics, clinic: clinic),
        const EmptySize.s16Height(),
        _InstitutionBranchHeader(clinic: clinic),
        const EmptySize.s12Height(),
        Expanded(child: _InstitutionContentBranches(clinic: clinic)),
        if (context.screenSize.isMobile)
          _InstitutionMobileAddBranch(clinic: clinic),
      ],
    );
  }
}
