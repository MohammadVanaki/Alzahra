/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/about.png
  AssetGenImage get about => const AssetGenImage('assets/images/about.png');

  /// File path: assets/images/bg.jpg
  AssetGenImage get bg => const AssetGenImage('assets/images/bg.jpg');

  /// File path: assets/images/check-box.png
  AssetGenImage get checkBox =>
      const AssetGenImage('assets/images/check-box.png');

  /// File path: assets/images/co-mz-512.png
  AssetGenImage get coMz512 =>
      const AssetGenImage('assets/images/co-mz-512.png');

  /// File path: assets/images/curriculum.png
  AssetGenImage get curriculum =>
      const AssetGenImage('assets/images/curriculum.png');

  /// File path: assets/images/date.png
  AssetGenImage get date => const AssetGenImage('assets/images/date.png');

  /// File path: assets/images/exam.png
  AssetGenImage get exam => const AssetGenImage('assets/images/exam.png');

  /// File path: assets/images/gallery.png
  AssetGenImage get gallery => const AssetGenImage('assets/images/gallery.png');

  /// File path: assets/images/icons8-pdf-64.png
  AssetGenImage get icons8Pdf64 =>
      const AssetGenImage('assets/images/icons8-pdf-64.png');

  /// File path: assets/images/information.png
  AssetGenImage get information =>
      const AssetGenImage('assets/images/information.png');

  /// File path: assets/images/library.png
  AssetGenImage get library => const AssetGenImage('assets/images/library.png');

  /// File path: assets/images/live_video.png
  AssetGenImage get liveVideo =>
      const AssetGenImage('assets/images/live_video.png');

  /// File path: assets/images/messages.png
  AssetGenImage get messages =>
      const AssetGenImage('assets/images/messages.png');

  /// File path: assets/images/newspaper.png
  AssetGenImage get newspaper =>
      const AssetGenImage('assets/images/newspaper.png');

  /// File path: assets/images/notification.png
  AssetGenImage get notification =>
      const AssetGenImage('assets/images/notification.png');

  /// File path: assets/images/print.png
  AssetGenImage get print => const AssetGenImage('assets/images/print.png');

  /// File path: assets/images/profile-vector.jpg
  AssetGenImage get profileVector =>
      const AssetGenImage('assets/images/profile-vector.jpg');

  /// File path: assets/images/sound.png
  AssetGenImage get sound => const AssetGenImage('assets/images/sound.png');

  /// File path: assets/images/splash.jpg
  AssetGenImage get splash => const AssetGenImage('assets/images/splash.jpg');

  /// File path: assets/images/video.png
  AssetGenImage get video => const AssetGenImage('assets/images/video.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        about,
        bg,
        checkBox,
        coMz512,
        curriculum,
        date,
        exam,
        gallery,
        icons8Pdf64,
        information,
        library,
        liveVideo,
        messages,
        newspaper,
        notification,
        print,
        profileVector,
        sound,
        splash,
        video
      ];
}

class $AssetsLottiefilesGen {
  const $AssetsLottiefilesGen();

  /// File path: assets/lottiefiles/lottieError.json
  String get lottieError => 'assets/lottiefiles/lottieError.json';

  /// List of all assets
  List<String> get values => [lottieError];
}

class $AssetsSvgsGen {
  const $AssetsSvgsGen();

  /// File path: assets/svgs/Sprinkle.svg
  String get sprinkle => 'assets/svgs/Sprinkle.svg';

  /// File path: assets/svgs/check-box.svg
  String get checkBox => 'assets/svgs/check-box.svg';

  /// File path: assets/svgs/curriculum.svg
  String get curriculum => 'assets/svgs/curriculum.svg';

  /// File path: assets/svgs/date.svg
  String get date => 'assets/svgs/date.svg';

  /// File path: assets/svgs/gallery.svg
  String get gallery => 'assets/svgs/gallery.svg';

  /// File path: assets/svgs/information.svg
  String get information => 'assets/svgs/information.svg';

  /// File path: assets/svgs/library.svg
  String get library => 'assets/svgs/library.svg';

  /// File path: assets/svgs/live_video.svg
  String get liveVideo => 'assets/svgs/live_video.svg';

  /// File path: assets/svgs/messages.svg
  String get messages => 'assets/svgs/messages.svg';

  /// File path: assets/svgs/newspaper.svg
  String get newspaper => 'assets/svgs/newspaper.svg';

  /// File path: assets/svgs/notification.svg
  String get notification => 'assets/svgs/notification.svg';

  /// File path: assets/svgs/print.svg
  String get print => 'assets/svgs/print.svg';

  /// File path: assets/svgs/sound.svg
  String get sound => 'assets/svgs/sound.svg';

  /// File path: assets/svgs/video.svg
  String get video => 'assets/svgs/video.svg';

  /// List of all assets
  List<String> get values => [
        sprinkle,
        checkBox,
        curriculum,
        date,
        gallery,
        information,
        library,
        liveVideo,
        messages,
        newspaper,
        notification,
        print,
        sound,
        video
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLottiefilesGen lottiefiles = $AssetsLottiefilesGen();
  static const $AssetsSvgsGen svgs = $AssetsSvgsGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

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
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
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

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
