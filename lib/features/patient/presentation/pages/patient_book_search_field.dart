part of 'patient_book_page.dart';

/// Filters the service list by name as the patient types.
final class _PatientBookSearchField extends StatelessWidget {
  const _PatientBookSearchField();

  @override
  Widget build(BuildContext context) {
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
}
