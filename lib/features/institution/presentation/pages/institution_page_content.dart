part of 'institution_page.dart';

/// Renders the clinic list state and creation action.
final class _InstitutionPageContent extends StatelessWidget {
  const _InstitutionPageContent();

  @override
  Widget build(BuildContext context) {
    return InstitutionListView<Clinic, ClinicListCubit>(
      emptyTitle: LocaleKeys.institution_empty_clinicsTitle.tr(),
      emptyMessage: LocaleKeys.institution_empty_clinicsDescription.tr(),
      onRetry: context.read<ClinicListCubit>().retry,
      emptyAction: FilledButton(
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) => _ClinicNameDialog(
            selection: InstitutionSelectionScope.read(context),
          ),
        ),
        child: AppText.label(
          LocaleKeys.institution_createClinic.tr(),
          tone: TextTone.onPrimary,
        ),
      ),
      loadedBuilder: (clinics) => _InstitutionContent(clinics: clinics),
    );
  }
}
