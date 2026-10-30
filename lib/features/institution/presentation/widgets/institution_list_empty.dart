part of 'institution_list_view.dart';

/// Shared institution list no-content presentation.
final class _InstitutionListEmpty extends StatelessWidget {
  const _InstitutionListEmpty({
    required this.title,
    required this.message,
    this.action,
  });

  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: title,
      message: message,
      icon: const Icon(Icons.inbox_outlined),
      iconBackground: context.colorScheme.surfaceContainerHighest,
      primaryAction: action,
    );
  }
}
