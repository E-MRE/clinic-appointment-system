part of 'page_header.dart';

/// Title and optional subtitle text block in a page header.
final class _PageHeaderTitle extends StatelessWidget {
  const _PageHeaderTitle({
    required this.title,
    required this.subtitle,
    required this.tier,
  });

  final String title;
  final String? subtitle;
  final PageHeaderTier tier;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.pageTitle(title),
        if (subtitle case final value?) ...[
          const EmptySize.s2Height(),
          AppText(value, role: tier.subtitleRole, tone: TextTone.muted),
        ],
      ],
    );
  }
}
