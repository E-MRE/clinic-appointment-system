part of 'loading_state.dart';

/// Centered progress indicator and its display label.
final class _CenteredIndicator extends StatelessWidget {
  const _CenteredIndicator({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const EmptySize.s16Height(),
          AppText.body(label, tone: TextTone.muted),
        ],
      ),
    );
  }
}
