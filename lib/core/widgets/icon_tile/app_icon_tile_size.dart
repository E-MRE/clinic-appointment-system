import 'package:clinic_appointment_system/core/theme/theme.dart';

/// Edge and icon sizes of an [AppIconTile].
enum AppIconTileSize {
  /// 32 px tile with a 16 px icon, used inside table cells.
  small(tile: AppSizes.s32, icon: AppSizes.s16),

  /// 36 px tile with an 18 px icon, used beside list and note rows.
  medium(tile: AppSizes.iconTileMedium, icon: AppSizes.iconTileMediumIcon);

  const AppIconTileSize({required this.tile, required this.icon});

  /// Edge length of the square tile.
  final double tile;

  /// Size of the centered icon.
  final double icon;
}
