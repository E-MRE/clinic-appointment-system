part of 'branch_form_page.dart';

/// Cancel and save controls for the branch form.
final class _BranchFormActions extends StatelessWidget {
  const _BranchFormActions({required this.onSave});

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () => context.go(AppRoutes.institution),
          child: AppText.label(LocaleKeys.institution_cancel.tr()),
        ),
        const Spacer(),
        FilledButton(
          onPressed: onSave,
          child: AppText.label(
            LocaleKeys.institution_saveBranch.tr(),
            tone: TextTone.onPrimary,
          ),
        ),
      ],
    );
  }
}
