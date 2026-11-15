part of 'availability_body.dart';

/// Resolves observation states before selecting the device-specific layout.
final class _AvailabilityBodyContent extends StatelessWidget {
  const _AvailabilityBodyContent();

  @override
  Widget build(BuildContext context) {
    final availability = context.watch<StaffAvailabilityCubit>().state;
    final branch = context.watch<AvailabilityBranchCubit>().state;
    if (availability is WatchLoading || branch is WatchLoading) {
      return LoadingState(
        variant: LoadingStateVariant.skeletonList,
        label: LocaleKeys.availability_loading.translate(),
      );
    }
    if (availability
        is WatchFailure<StaffAvailability, AvailabilityErrorCode>) {
      return _AvailabilityFailure(message: availability.code.message());
    }
    if (branch is WatchFailure<Branch, InstitutionErrorCode>) {
      return _AvailabilityFailure(message: branch.code.message);
    }
    return context.screenSize.select(
      mobile: _buildMobileLayout(context),
      tablet: const _AvailabilityTabletLayout(),
      desktop: _buildDesktopViewport(),
    );
  }

  /// Builds the mobile scroll layout and its weekday rows.
  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _AvailabilityBranchBanner(),
          const EmptySize.s16Height(),
          for (final day in Weekday.values) _buildDayRow(context, day),
          const EmptySize.s24Height(),
          const _AvailabilityOneOffSection(),
        ],
      ),
    );
  }

  /// Builds one weekday row with its themed border and day content.
  Widget _buildDayRow(BuildContext context, Weekday day) {
    return Container(
      constraints: const BoxConstraints(minHeight: AppSizes.availabilityDayRow),
      padding: const AppPadding.verticalSm(),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.colorScheme.outlineVariant,
            width: AppSizes.borderThin,
          ),
        ),
      ),
      child: _AvailabilityDayContent(day: day),
    );
  }

  /// Builds the horizontally scrollable desktop minimum-width viewport.
  Widget _buildDesktopViewport() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: const SizedBox(
              width: AppSizes.availabilityDesktopMinWidth,
              child: _AvailabilityDesktopLayout(),
            ),
          ),
        );
      },
    );
  }
}
