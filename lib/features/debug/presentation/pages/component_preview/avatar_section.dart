part of 'component_preview_page.dart';

/// Displays avatar section samples.
final class _AvatarSection extends StatelessWidget {
  const _AvatarSection();
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.s16,
      runSpacing: AppSizes.s8,
      children: [
        for (final size in AppAvatarSize.values)
          Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSizes.s8,
            children: [
              AppAvatar(initials: 'EK', size: size),
              AppText.caption(size.name),
            ],
          ),
      ],
    );
  }
}
