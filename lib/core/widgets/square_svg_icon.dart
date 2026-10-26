import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/generated/assets.gen.dart';
import 'package:flutter/material.dart';

/// Decorative SVG icon with shared sizing and theme-aware tinting.
final class SquareSvgIcon extends StatelessWidget {
  const SquareSvgIcon({
    required this.asset,
    required this.size,
    this.color,
    super.key,
  });

  final SvgGenImage asset;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Center(
        child: asset.svg(
          width: size,
          height: size,
          excludeFromSemantics: true,
          colorFilter: ColorFilter.mode(
            color ?? context.iconTheme.color ?? context.colorScheme.onPrimary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
