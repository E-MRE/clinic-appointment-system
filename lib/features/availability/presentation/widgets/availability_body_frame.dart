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
        if (state is AvailabilityWindowSaveFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: AppText.body(
                state.code.message(conflict: state.conflict),
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
            _buildHeader(context),
            const EmptySize.s16Height(),
            const Expanded(child: _AvailabilityBodyContent()),
          ],
        ),
      ),
    );
  }

  /// Builds the header and includes the add action on tablet screens.
  Widget _buildHeader(BuildContext context) {
    return Row(
      spacing: AppSizes.s16,
      children: [
        Expanded(child: header),
        if (context.screenSize.isTablet) const _AvailabilityAddButton(),
      ],
    );
  }
}
