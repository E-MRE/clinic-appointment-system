// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsColorsGen {
  const $AssetsColorsGen();

  /// File path: assets/colors/colors.xml
  String get colors => 'assets/colors/colors.xml';

  /// List of all assets
  List<String> get values => [colors];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// Directory path: assets/images/auth
  $AssetsImagesAuthGen get auth => const $AssetsImagesAuthGen();

  /// Directory path: assets/images/brand
  $AssetsImagesBrandGen get brand => const $AssetsImagesBrandGen();

  /// Directory path: assets/images/status
  $AssetsImagesStatusGen get status => const $AssetsImagesStatusGen();
}

class $AssetsTranslationsGen {
  const $AssetsTranslationsGen();

  /// File path: assets/translations/tr-TR.json
  String get trTR => 'assets/translations/tr-TR.json';

  /// List of all assets
  List<String> get values => [trTR];
}

class $AssetsImagesAuthGen {
  const $AssetsImagesAuthGen();

  /// File path: assets/images/auth/admin.svg
  SvgGenImage get admin => const SvgGenImage('assets/images/auth/admin.svg');

  /// File path: assets/images/auth/back.svg
  SvgGenImage get back => const SvgGenImage('assets/images/auth/back.svg');

  /// File path: assets/images/auth/email.svg
  SvgGenImage get email => const SvgGenImage('assets/images/auth/email.svg');

  /// File path: assets/images/auth/eye.svg
  SvgGenImage get eye => const SvgGenImage('assets/images/auth/eye.svg');

  /// File path: assets/images/auth/lock.svg
  SvgGenImage get lock => const SvgGenImage('assets/images/auth/lock.svg');

  /// File path: assets/images/auth/panel_logo.svg
  SvgGenImage get panelLogo =>
      const SvgGenImage('assets/images/auth/panel_logo.svg');

  /// File path: assets/images/auth/patient.svg
  SvgGenImage get patient =>
      const SvgGenImage('assets/images/auth/patient.svg');

  /// File path: assets/images/auth/sign_in_logo.svg
  SvgGenImage get signInLogo =>
      const SvgGenImage('assets/images/auth/sign_in_logo.svg');

  /// File path: assets/images/auth/staff.svg
  SvgGenImage get staff => const SvgGenImage('assets/images/auth/staff.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
    admin,
    back,
    email,
    eye,
    lock,
    panelLogo,
    patient,
    signInLogo,
    staff,
  ];
}

class $AssetsImagesBrandGen {
  const $AssetsImagesBrandGen();

  /// File path: assets/images/brand/clinic_logo.svg
  SvgGenImage get clinicLogo =>
      const SvgGenImage('assets/images/brand/clinic_logo.svg');

  /// File path: assets/images/brand/native_splash.png
  AssetGenImage get nativeSplash =>
      const AssetGenImage('assets/images/brand/native_splash.png');

  /// File path: assets/images/brand/native_splash_android12.png
  AssetGenImage get nativeSplashAndroid12 =>
      const AssetGenImage('assets/images/brand/native_splash_android12.png');

  /// File path: assets/images/brand/splash_logo.svg
  SvgGenImage get splashLogo =>
      const SvgGenImage('assets/images/brand/splash_logo.svg');

  /// List of all assets
  List<dynamic> get values => [
    clinicLogo,
    nativeSplash,
    nativeSplashAndroid12,
    splashLogo,
  ];
}

class $AssetsImagesStatusGen {
  const $AssetsImagesStatusGen();

  /// File path: assets/images/status/error.svg
  SvgGenImage get error => const SvgGenImage('assets/images/status/error.svg');

  /// File path: assets/images/status/offline.svg
  SvgGenImage get offline =>
      const SvgGenImage('assets/images/status/offline.svg');

  /// File path: assets/images/status/retry.svg
  SvgGenImage get retry => const SvgGenImage('assets/images/status/retry.svg');

  /// List of all assets
  List<SvgGenImage> get values => [error, offline, retry];
}

abstract final class Assets {
  static const $AssetsColorsGen colors = $AssetsColorsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsTranslationsGen translations = $AssetsTranslationsGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
