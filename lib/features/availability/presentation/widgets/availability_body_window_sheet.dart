part of 'availability_body.dart';

/// Modal editor that closes only after a successful add or explicit dismissal.
final class _AvailabilityWindowSheet extends StatelessWidget {
  const _AvailabilityWindowSheet({required this.showsWeekdaySelect});
  final bool showsWeekdaySelect;

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<AvailabilityWindowDraftCubit>().state;
    return _AvailabilityWindowSaveScope(
      child: AppBottomSheet(
        title: draft.sheetTitle,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSizes.s16,
          children: [
            _AvailabilityWindowForm(showsWeekdaySelect: showsWeekdaySelect),
            const _AvailabilitySheetActions(),
          ],
        ),
      ),
    );
  }
}
