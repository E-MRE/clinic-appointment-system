part of 'startup_error_page.dart';

final class _StartupHeader extends StatelessWidget {
  const _StartupHeader();

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: AppSizes.xxxl),
    child: Row(
      children: [
        Assets.images.brand.clinicLogo.svg(
          width: AppSizes.xxl,
          height: AppSizes.xxl,
          excludeFromSemantics: true,
        ),
        const EmptySize.mdWidth(),
        Expanded(
          child: Text(
            LocaleKeys.appName.translate(),
            style: context.textTheme.titleMedium,
          ),
        ),
      ],
    ),
  );
}
