import 'package:flutter/widgets.dart';

// This file provides a patch for the FixedScrollMetrics constructor
// to add the required devicePixelRatio parameter that's missing in the original package

// Create a wrapper for FixedScrollMetrics that provides the missing parameter
class PatchedFixedScrollMetrics extends FixedScrollMetrics {
  PatchedFixedScrollMetrics({
    required double minScrollExtent,
    required double maxScrollExtent,
    required double pixels,
    required double viewportDimension,
    required AxisDirection axisDirection,
  }) : super(
          minScrollExtent: minScrollExtent,
          maxScrollExtent: maxScrollExtent,
          pixels: pixels,
          viewportDimension: viewportDimension,
          axisDirection: axisDirection,
          devicePixelRatio: WidgetsBinding.instance.window.devicePixelRatio,
        );
}
