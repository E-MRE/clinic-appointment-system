part of 'patient_book_page.dart';

/// Staff who provide the chosen service, or a hint before a service.
final class _PatientBookStaffSection extends StatelessWidget {
  const _PatientBookStaffSection({required this.catalog});

  final PatientCatalog catalog;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingSelectionCubit, BookingSelection>(
      builder: (context, selection) {
        final service = selection.service;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSizes.s12,
          children: [
            _PatientBookSectionTitle(
              title: LocaleKeys.patient_book_staffTitle.translate(),
            ),
            if (service == null)
              AppText.body(
                LocaleKeys.patient_book_staffHint.translate(),
                tone: TextTone.muted,
              )
            else
              for (final staff in catalog.staffFor(service))
                _PatientBookStaffCard(
                  staff: staff,
                  catalog: catalog,
                  isSelected: staff.id == selection.staff?.id,
                ),
          ],
        );
      },
    );
  }
}
