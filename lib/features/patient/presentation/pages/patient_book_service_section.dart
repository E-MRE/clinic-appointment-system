part of 'patient_book_page.dart';

/// Service search, the department limit and the matching service cards.
final class _PatientBookServiceSection extends StatelessWidget {
  const _PatientBookServiceSection({required this.catalog});

  final ClinicCatalog catalog;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingSelectionCubit, BookingSelection>(
      builder: (context, selection) {
        final services = context.read<BookingSelectionCubit>().servicesIn(
          catalog,
        );
        final departmentId = selection.departmentId;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSizes.s12,
          children: [
            _PatientBookSectionTitle(
              title: LocaleKeys.patient_book_serviceTitle.translate(),
            ),
            _buildSearchField(context),
            if (departmentId != null)
              _buildDepartmentChip(
                context,
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

  /// Builds the localized search field for the services.
  AppTextField _buildSearchField(BuildContext context) {
    final label = LocaleKeys.patient_book_search.translate();
    return AppTextField(
      label: label,
      hint: label,
      isLabelVisible: false,
      textInputAction: TextInputAction.search,
      prefix: Icon(Icons.search, color: context.colorScheme.onSurfaceVariant),
      onChanged: context.read<BookingSelectionCubit>().search,
    );
  }

  /// Builds the removable department filter when the page is limited.
  Align _buildDepartmentChip(BuildContext context, {required String name}) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: AppTimeRangeChip(
        label: name,
        removeTooltip: LocaleKeys.patient_book_removeDepartment.translate(),
        onRemove: context.read<BookingSelectionCubit>().removeDepartmentLimit,
      ),
    );
  }
}
