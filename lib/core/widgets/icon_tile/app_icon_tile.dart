import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/icon_tile/app_icon_tile_size.dart';
import 'package:clinic_appointment_system/core/widgets/icon_tile/app_icon_tile_variant.dart';
import 'package:clinic_appointment_system/core/widgets/icon_tile/app_icon_tile_variant_colors.dart';
import 'package:flutter/material.dart';

export 'package:clinic_appointment_system/core/widgets/icon_tile/app_icon_tile_size.dart';
export 'package:clinic_appointment_system/core/widgets/icon_tile/app_icon_tile_variant.dart';

/// A decorative, rounded square holding one themed icon.
final class AppIconTile extends StatelessWidget {
  /// Creates an icon tile from a size and color variant.
  const AppIconTile({
    required this.icon,
    this.size = AppIconTileSize.medium,
    this.variant = AppIconTileVariant.secondary,
    super.key,
  });

  /// Icon displayed in the tile.
  final IconData icon;

  /// Tile and icon dimensions.
  final AppIconTileSize size;

  /// Fill and icon colors.
  final AppIconTileVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Container(
      width: size.tile,
      height: size.tile,
      decoration: BoxDecoration(
        color: variant.background(colors),
        borderRadius: const AppRadius.small(),
      ),
      child: Icon(icon, size: size.icon, color: variant.foreground(colors)),
    );
  }
}
