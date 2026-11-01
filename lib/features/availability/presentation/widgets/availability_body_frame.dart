part of 'availability_body.dart';

/// Owns remove feedback while keeping the header inside the observation scope.
final class _AvailabilityBodyFrame extends StatelessWidget {
  const _AvailabilityBodyFrame({required this.header});
  final Widget header;

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      AvailabilityWindowRemoveCubit,
      AvailabilityWindowSaveState
    >(
      listenWhen: (previous, current) =>
          current is AvailabilityWindowSaveFailure,
      listener: (context, state) {
        if (state case AvailabilityWindowSaveFailure(
          :final code,
          :final conflict,
        )) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: AppText.body(
                code.message(conflict: conflict),
                tone: TextTone.onInverse,
              ),
            ),
          );
        }
      },
      child: AppScaffold(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AvailabilityHeader(header: header),
            const EmptySize.s16Height(),
            const Expanded(child: _AvailabilityBodyContent()),
          ],
        ),
      ),
    );
  }
}
