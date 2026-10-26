import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

/// Responsive title row for page content.
final class PageHeader extends StatelessWidget {
  /// Creates a page header with optional subtitle and trailing actions.
  const PageHeader({
    required this.title,
    this.subtitle,
    this.actions,
    super.key,
  });

  /// Main page heading.
  final String title;

  /// Supporting line below the heading.
  final String? subtitle;

  /// Optional controls aligned to the trailing edge.
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    final tier = _PageHeaderTier.from(context.screenSize);
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: tier.minimumHeight),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.pageTitle(title),
                  if (subtitle case final value?) ...[
                    const EmptySize.s2Height(),
                    AppText(
                      value,
                      role: tier.subtitleRole,
                      tone: TextTone.muted,
                    ),
                  ],
                ],
              ),
            ),
            if (actions case final value?) ...[
              const EmptySize.s8Width(),
              value,
            ],
          ],
        ),
      ),
    );
  }
}

/// Header sizing and subtitle typography for a screen tier.
enum _PageHeaderTier {
  /// Mobile header uses a 64 px minimum and caption subtitle.
  mobile(AppSizes.pageHeaderMobileHeight, TextRole.caption),

  /// Tablet header uses an 88 px minimum and body-large subtitle.
  tablet(AppSizes.pageHeaderTabletHeight, TextRole.bodyLarge),

  /// Desktop header is content sized with body-large subtitle.
  desktop(0, TextRole.bodyLarge);

  const _PageHeaderTier(this.minimumHeight, this.subtitleRole);

  /// Minimum header height for this tier.
  final double minimumHeight;

  /// Subtitle role for this tier.
  final TextRole subtitleRole;

  /// Resolves a screen size to its page-header tier.
  static _PageHeaderTier from(ScreenSize size) {
    return size.select(mobile: mobile, tablet: tablet, desktop: desktop);
  }
}
