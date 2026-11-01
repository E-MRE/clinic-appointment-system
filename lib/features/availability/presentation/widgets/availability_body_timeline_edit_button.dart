part of 'availability_body.dart';

/// Selects a weekday in the persistent desktop editor.
final class _AvailabilityTimelineEditButton extends StatelessWidget {
  const _AvailabilityTimelineEditButton({required this.day});
  final Weekday day;

  @override
  Widget build(BuildContext context) {
    final saving =
        context.watch<AvailabilityWindowAddCubit>().state
            is AvailabilityWindowSaving;
    return SizedBox.square(
      dimension: AppSizes.s40,
      child: IconButton(
        tooltip: LocaleKeys.availability_editDay.translate(args: [day.label]),
        onPressed: saving
            ? null
            : () {
                context.read<AvailabilityWindowAddCubit>().reset();
                context.read<AvailabilityWindowDraftCubit>().startWeekly(day);
              },
        icon: const Icon(
          Icons.edit_outlined,
          size: AppSizes.availabilityCalendarIcon,
        ),
      ),
    );
  }
}
