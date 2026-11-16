part of 'patient_book_page.dart';

/// A slot's start time; taken slots are struck through and disabled.
final class _PatientBookSlotCell extends StatelessWidget {
  const _PatientBookSlotCell({required this.slot, required this.selectedSlot});

  final StaffSlot slot;
  final TimeRange? selectedSlot;

  @override
  Widget build(BuildContext context) {
    final style = slot.cellStyle(isSelected: slot.range == selectedSlot);
    return _PatientBookChoiceCell(
      style: style,
      minHeight: AppSizes.s48,
      onTap: () => context.read<BookingSelectionCubit>().selectSlot(slot.range),
      child: AppText.bodyStrong(
        slot.label,
        tone: style.tone,
        decoration: style.decoration,
        semanticsLabel: slot.semanticsLabel,
        maxLines: 1,
      ),
    );
  }
}
