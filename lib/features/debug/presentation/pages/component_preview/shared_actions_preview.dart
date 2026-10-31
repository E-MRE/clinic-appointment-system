part of 'component_preview_page.dart';

/// Demonstrates shared actions, selection, dialog and panel layouts.
final class _SharedActionsPreview extends StatefulWidget {
  const _SharedActionsPreview();
  @override
  State<_SharedActionsPreview> createState() => _SharedActionsPreviewState();
}

final class _SharedActionsPreviewState extends State<_SharedActionsPreview> {
  bool _selected = false;
  @override
  Widget build(BuildContext context) {
    final sample = LocaleKeys.componentPreview_sample.translate();
    return Column(
      spacing: AppSizes.s16,
      children: [
        AppAddButton(
          label: sample,
          onPressed: () => showDialog<void>(
            context: context,
            builder: (_) =>
                AppFormDialog(title: sample, child: AppText.body(sample)),
          ),
        ),
        AppAddFab(label: sample, onPressed: () {}),
        AppCheckboxTile(
          label: sample,
          value: _selected,
          onChanged: (value) {
            setState(() {
              _selected = value;
            });
          },
        ),
        AppMutedMessage(message: sample),
        AppSidePanelLayout(
          showsPanel: context.screenSize.isDesktop,
          panel: AppSidePanel(child: AppText.body(sample)),
          child: AppText.body(sample),
        ),
      ],
    );
  }
}
