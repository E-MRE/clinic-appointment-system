part of 'availability_body.dart';

/// Dated window row matching the approved web item for reuse in stage 6b.
final class _AvailabilityOneOffItem extends StatelessWidget {
  const _AvailabilityOneOffItem({required this.window});
  final OneOffWindow window;

  @override
  Widget build(BuildContext context) {
    final saving =
        context.watch<AvailabilityWindowRemoveCubit>().state
            is AvailabilityWindowSaving;
    return Container(
      padding: const AppPadding.control(),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        border: Border.all(
          color: context.colorScheme.outlineVariant,
          width: AppSizes.borderThin,
        ),
        borderRadius: const AppRadius.medium(),
      ),
      child: Row(
        spacing: AppSizes.s12,
        children: [
          const _AvailabilityOneOffIcon(),
          Expanded(child: _AvailabilityOneOffIdentity(window: window)),
          SizedBox.square(
            dimension: AppSizes.s40,
            child: IconButton(
              tooltip: LocaleKeys.availability_removeOneOff.translate(),
              onPressed: saving
                  ? null
                  : () {
                      context.read<AvailabilityWindowRemoveCubit>().submit(
                        context.read<AvailabilitySubject>(),
                        window,
                      );
                    },
              icon: const Icon(Icons.close, size: AppSizes.s20),
            ),
          ),
        ],
      ),
    );
  }
}
