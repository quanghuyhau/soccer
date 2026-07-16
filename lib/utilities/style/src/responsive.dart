part of '../style.dart';

class Responsive {
  static double fontResize = 1;

  static update() {
    if (isSmallMobile) {
      fontResize = 0.82;
    } else if (isTablet) {
      fontResize = 1.16;
    } else {
      fontResize = 1;
    }
  }

  static double get screenWidth {
    var pixelRatio = window.devicePixelRatio;

    //Size in logical pixels
    var logicalScreenSize = window.physicalSize / pixelRatio;
    var logicalWidth = logicalScreenSize.width;

    //Safe area paddings in logical pixels
    var paddingLeft = window.padding.left / window.devicePixelRatio;
    var paddingRight = window.padding.right / window.devicePixelRatio;

    //Safe area in logical pixels
    return logicalWidth - paddingLeft - paddingRight;
  }

  static double get screenHeight {
    var pixelRatio = window.devicePixelRatio;

    //Size in logical pixels
    var logicalScreenSize = window.physicalSize / pixelRatio;
    var logicalHeight = logicalScreenSize.height;

    //Safe area paddings in logical pixels
    var paddingLeft = window.padding.top / window.devicePixelRatio;
    var paddingRight = window.padding.bottom / window.devicePixelRatio;

    //Safe area in logical pixels
    return logicalHeight - paddingLeft - paddingRight;
  }

  static bool get isTablet => type == TypeResponsive.tablet;

  static bool get isSmallMobile => type == TypeResponsive.smallMobile;

  static TypeResponsive get type {
    if (screenWidth <= 320) {
      return TypeResponsive.smallMobile;
    } else if (screenWidth >= 670) {
      return TypeResponsive.tablet;
    }

    return TypeResponsive.mobile;
  }
}

enum TypeResponsive {
  smallMobile,
  mobile,
  tablet,
}
