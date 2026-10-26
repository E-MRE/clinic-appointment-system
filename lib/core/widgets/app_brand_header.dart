import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/generated/assets.gen.dart';
import 'package:flutter/material.dart';

/// Shared application logo and name for headers on different surfaces.
final class AppBrandHeader extends StatelessWidget {
  const AppBrandHeader({
    required this.logo,
    required this.logoSize,
    this.minimumHeight,
    this.textColor,
    super.key,
  });

  final SvgGenImage logo;
  final double logoSize;
  final double? minimumHeight;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minimumHeight ?? logoSize),
      child: Row(
        children: [
          logo.svg(
            width: logoSize,
            height: logoSize,
            excludeFromSemantics: true,
          ),
          const EmptySize.s12Width(),
          Expanded(
            child: Text(
              LocaleKeys.appName.translate(),
              style: context.textTheme.titleMedium?.copyWith(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
