part of 'lab_test_form_section.dart';

/// Row arranging fasting hours and result turn-around duration inputs side by side.
final class _LabTestDetailsRow extends StatelessWidget {
  const _LabTestDetailsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSizes.s12,
      children: [
        Expanded(child: _LabTestFastingHoursField()),
        Expanded(child: _LabTestResultTimeField()),
      ],
    );
  }
}
