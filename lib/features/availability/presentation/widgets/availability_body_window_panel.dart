part of 'availability_body.dart';

/// Persistent add form sharing modal submission behavior without navigation.
final class _AvailabilityWindowPanel extends StatelessWidget {
  const _AvailabilityWindowPanel();

  @override
  Widget build(BuildContext context) {
    return _AvailabilityWindowSaveScope(
      closesOnSaved: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s16,
        children: [
          Semantics(
            header: true,
            child: AppText.sectionTitle(
              LocaleKeys.availability_addWindow.translate(),
            ),
          ),
          const _AvailabilityWindowForm(showsWeekdaySelect: true),
          const _AvailabilityWindowPreview(),
          _AvailabilitySaveButton(
            label: LocaleKeys.availability_saveWindow.translate(),
          ),
        ],
      ),
    );
  }
}
