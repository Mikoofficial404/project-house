import 'package:flutter/widgets.dart';

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
