import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:soccer/utilities/style/style.dart';

enum TypeReadImage { svgAsset, svgNetWork, imageAsset, imageNetWork }

enum TypeImage { doubleImage, singleImage }

enum ErrorType { unknown, warning }

class LoadImage extends StatelessWidget {
  /// single
  final String? url;
  final BorderRadius? borderRadius;
  final BoxFit? boxFit;
  final double? width;
  final double? height;

  /// double
  final String? urlIconLeft;
  final BorderRadius? borderRadiusLeft;
  final BoxFit? boxFitLeft;
  final double? widthLeft;
  final double? heightLeft;
  final String? urlIconRight;
  final BorderRadius? borderRadiusRight;
  final BoxFit? boxFitRight;
  final double? widthRight;
  final double? heightRight;
  final double? widthBox;
  final double? heightBox;
  final Color? colors;
  final ErrorType errorType;
  final Widget? errorWidget;
  final Widget? placeholder;
  final Color? colorShimmer;
  final double? circular;

  ///get type double or single image
  final TypeImage? typeImage;

  final TypeReadImage? readType;

  const LoadImage({
    Key? key,
    this.url,
    this.colors,
    this.borderRadius,
    this.boxFit,
    this.width,
    this.height,
    this.urlIconLeft,
    this.borderRadiusLeft,
    this.boxFitLeft,
    this.widthLeft,
    this.heightLeft,
    this.urlIconRight,
    this.borderRadiusRight,
    this.boxFitRight,
    this.heightRight,
    this.widthRight,
    this.widthBox,
    this.heightBox,
    this.typeImage = TypeImage.singleImage,
    this.errorType = ErrorType.warning,
    this.errorWidget,
    this.placeholder,
    this.readType,
    this.colorShimmer,
    this.circular,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    theme.registerNotifyUpdated(context);
    if (typeImage == TypeImage.singleImage) {
      return _loadImageSingle(url ?? '');
    }

    return _loadImageDouble();
  }

  _loadImageSingle(String urlPath) {
    final typeReadImage = readType ?? getTypeReadImage(urlPath);

    switch (typeReadImage) {
      case TypeReadImage.svgAsset:
        return ClipRRect(
          borderRadius:
              borderRadius ?? const BorderRadius.all(Radius.circular(0)),
          child: SvgPicture.asset(
            urlPath,
            color: colors,
            fit: boxFit ?? BoxFit.contain,
            width: width,
            height: height,
          ),
        );
      case TypeReadImage.imageAsset:
        return ClipRRect(
          borderRadius:
              borderRadius ?? const BorderRadius.all(Radius.circular(0)),
          child: Image.asset(
            urlPath,
            fit: boxFit ?? BoxFit.contain,
            width: width,
            height: height,
            color: colors,
          ),
        );
      case TypeReadImage.imageNetWork:
        return CachedNetworkImage(
          width: width,
          height: height,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius:
                  borderRadius ?? const BorderRadius.all(Radius.circular(0)),
              image: DecorationImage(
                image: imageProvider,
                fit: boxFit ?? BoxFit.contain,
              ),
            ),
          ),
          imageUrl: urlPath,
          placeholder: (context, url) =>
              placeholder ?? _shimmer(context, colorShimmer, circular),
          errorWidget: (context, url, error) {
            if (errorWidget != null) return errorWidget!;

            switch (errorType) {
              case ErrorType.warning:
                return Icon(
                  Icons.error,
                  size: width,
                  color: theme.color.red500,
                );
              case ErrorType.unknown:
                return Icon(
                  Icons.help_outline,
                  size: width,
                );
            }
          },
        );
      case TypeReadImage.svgNetWork:
        return SvgPicture.network(
          urlPath,
          fit: boxFit ?? BoxFit.contain,
          placeholderBuilder: (context) =>
              placeholder ?? _shimmer(context, colorShimmer, circular),
          width: width,
          height: height,
          color: colors,
        );
    }
  }

  _loadImageDouble() {
    return SizedBox(
      width: widthBox ?? 30,
      height: heightBox ?? 28,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: _loadImageSingle(
              urlIconLeft ?? '',
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: _loadImageSingle(
              urlIconRight ?? '',
            ),
          ),
        ],
      ),
    );
  }

  TypeReadImage getTypeReadImage(String path) {
    if (path.contains('https://') && path.contains('svg')) {
      return TypeReadImage.svgNetWork;
    } else if (path.contains('svg')) {
      return TypeReadImage.svgAsset;
    } else if (path.contains('https://') || path.isEmpty) {
      return TypeReadImage.imageNetWork;
    }

    return TypeReadImage.imageAsset;
  }

  _shimmer(BuildContext context, Color? colorShimmer, double? circular) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Shimmer.fromColors(
        baseColor: colorShimmer ?? Colors.grey,
        highlightColor: Colors.grey.withOpacity(0.2),
        child: Container(
          decoration: BoxDecoration(
            color: colorShimmer ?? Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(circular ?? 8)),
          ),
          width: MediaQuery.of(context).size.width - 32,
          height: (MediaQuery.of(context).size.width - 32) * (231 / 480),
        ),
      ),
    );
  }
}
