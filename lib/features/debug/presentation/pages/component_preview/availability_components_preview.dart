part of 'component_preview_page.dart';

/// Interactive samples of the shared availability controls.
final class _AvailabilityComponentsPreview extends StatefulWidget {
  const _AvailabilityComponentsPreview();

  @override
  State<_AvailabilityComponentsPreview> createState() {
    return _AvailabilityComponentsPreviewState();
  }
}

final class _AvailabilityComponentsPreviewState
    extends State<_AvailabilityComponentsPreview> {
  ClockTime? _time;
  late CalendarDate _date;

  @override
  void initState() {
    super.initState();
    _date = CalendarDate(year: 2026, month: 11, day: 2);
  }

  @override
  Widget build(BuildContext context) {
    final sample = LocaleKeys.componentPreview_sample.translate();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s16,
      children: [
        AppDashedBorder(
          color: context.colorScheme.primary,
          strokeWidth: AppSizes.borderThick,
          radius: const AppRadius.small(),
          child: Padding(
            padding: const AppPadding.allLg(),
            child: AppText.body(sample),
          ),
        ),
        AppTimeField(
          label: sample,
          value: _time,
          hint: LocaleKeys.common_selectTime.translate(),
          onChanged: (value) {
            setState(() {
              _time = value;
            });
          },
        ),
        AppTimeField(
          label: sample,
          value: ClockTime(hour: 9, minute: 0),
          onChanged: (_) {},
        ),
        AppTimeField(
          label: LocaleKeys.componentPreview_error.translate(),
          value: _time,
          hasError: true,
          onChanged: (_) {},
        ),
        AppDateField(
          label: sample,
          value: _date,
          first: CalendarDate(year: 2020, month: 1, day: 1),
          last: CalendarDate(year: 2030, month: 12, day: 31),
          onChanged: (value) {
            setState(() {
              _date = value;
            });
          },
        ),
        Wrap(
          spacing: AppSizes.s8,
          runSpacing: AppSizes.s8,
          children: [
            AppTimeRangeChip(
              label: '09:00–12:00',
              removeTooltip: LocaleKeys.common_removeRange.translate(),
              onRemove: () {},
            ),
            AppTimeRangeChip(
              label: '09:00–12:00',
              removeTooltip: LocaleKeys.common_removeRange.translate(),
              onRemove: () {},
              variant: AppTimeRangeChipVariant.flagged,
            ),
            AppTimeRangeChip(
              label: '09:00–12:00',
              removeTooltip: LocaleKeys.common_removeRange.translate(),
              onRemove: null,
            ),
          ],
        ),
        for (final variant in AppMessageBannerVariant.values)
          AppMessageBanner(message: sample, variant: variant),
        FilledButton(
          onPressed: () {
            context.showAppBottomSheet<void>(
              builder: (sheetContext) {
                return AppBottomSheet(
                  title: sample,
                  child: AppSheetActions(
                    cancelLabel: LocaleKeys.common_cancel.translate(),
                    confirmLabel: LocaleKeys.common_save.translate(),
                    onCancel: () {
                      Navigator.pop(sheetContext);
                    },
                    onConfirm: () {
                      Navigator.pop(sheetContext);
                    },
                  ),
                );
              },
            );
          },
          child: AppText.label(sample, tone: TextTone.onPrimary),
        ),
        AppNavigationUserCard(
          initials: 'EK',
          name: sample,
          subtitle: sample,
          signOutTooltip: LocaleKeys.auth_signOut.translate(),
          onSignOut: () {},
        ),
      ],
    );
  }
}
