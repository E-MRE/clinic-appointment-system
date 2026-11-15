part of 'patient_book_page.dart';

/// One availability window's heading and its four-column slot grid.
final class _PatientBookSlotGroup extends StatelessWidget {
  const _PatientBookSlotGroup({
    required this.group,
    required this.selectedSlot,
  });

  final StaffSlotGroup group;
  final TimeRange? selectedSlot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s12,
      children: [
        AppText.bodyStrong(group.heading, tone: TextTone.muted),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: PatientLayoutConstants.bookingSlotColumns,
            mainAxisExtent: AppSizes.s48,
            mainAxisSpacing: AppSizes.s8,
            crossAxisSpacing: AppSizes.s8,
          ),
          children: [
            for (final slot in group.slots)
              _buildSlotCell(context, slot, selectedSlot),
          ],
        ),
      ],
    );
  }

  /// Builds a slot cell with its current selection state.
  _PatientBookChoiceCell _buildSlotCell(
    BuildContext context,
    StaffSlot slot,
    TimeRange? selectedSlot,
  ) {
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
