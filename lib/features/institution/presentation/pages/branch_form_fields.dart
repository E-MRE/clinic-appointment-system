part of 'branch_form_page.dart';

/// Scrollable branch fields and request feedback.
final class _BranchFormFields extends StatelessWidget {
  const _BranchFormFields({required this.name, required this.address});

  final TextEditingController name;
  final TextEditingController address;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: LocaleKeys.institution_branchName.tr(),
            controller: name,
          ),
          const EmptySize.s16Height(),
          AppTextField(
            label: LocaleKeys.institution_address.tr(),
            controller: address,
          ),
          const EmptySize.s16Height(),
          const WorkingHoursEditor(),
          const _BranchFormSaveError(),
        ],
      ),
    );
  }
}
