part of 'staff_form.dart';

/// Filters the loaded catalogue through the preview entity's eligibility rules.
final class _StaffFormServiceOptions extends StatelessWidget {
  const _StaffFormServiceOptions();

  @override
  Widget build(BuildContext context) {
    final values = context.watch<StaffFormCubit>().state;
    final state = context.watch<MedicalServiceListCubit>().state;
    final preview = values.role.staffFormStrategy.build(
      values,
      id: EntityConstants.unsavedId,
    );
    final services = <MedicalService>[
      if (state is InstitutionListLoaded<MedicalService>)
        for (final service in state.items)
          if (preview.canProvide(service)) service,
    ];
    if (services.isEmpty) {
      return AppText.caption(
        LocaleKeys.staff_noEligibleServices.tr(),
        tone: TextTone.muted,
      );
    }
    return Column(
      spacing: AppSizes.s8,
      children: [
        for (final service in services) _StaffFormServiceTile(service: service),
      ],
    );
  }
}
