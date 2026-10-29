import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header_tier.dart';
import 'package:flutter/material.dart';

part 'page_header_title.dart';

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
    final tier = PageHeaderTier.from(context.screenSize);
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: tier.minimumHeight),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _PageHeaderTitle(
                title: title,
                subtitle: subtitle,
                tier: tier,
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
