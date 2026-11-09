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
              _PatientBookSlotCell(
                slot: slot,
                isSelected: slot.range == selectedSlot,
              ),
          ],
        ),
      ],
    );
  }
}
