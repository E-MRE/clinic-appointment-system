part of 'patient_book_page.dart';

/// Service search, the department limit and the matching service cards.
final class _PatientBookServiceSection extends StatelessWidget {
  const _PatientBookServiceSection({required this.catalog});

  final PatientCatalog catalog;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingSelectionCubit, BookingSelection>(
      builder: (context, selection) {
        final services = selection.servicesIn(catalog);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSizes.s12,
          children: [
            _PatientBookSectionTitle(
              title: LocaleKeys.patient_book_serviceTitle.translate(),
            ),
            const _PatientBookSearchField(),
            if (selection.departmentId case final String departmentId)
              _PatientBookDepartmentChip(
                name:
                    catalog.departmentById(departmentId)?.name ??
                    LocaleKeys.common_notAvailable.translate(),
              ),
            if (services.isEmpty)
              AppMutedMessage(
                message: LocaleKeys.patient_book_noServices.translate(),
              ),
            for (final service in services)
              _PatientBookServiceCard(
                service: service,
                catalog: catalog,
                isSelected: service.id == selection.service?.id,
              ),
          ],
        );
      },
    );
  }
}
