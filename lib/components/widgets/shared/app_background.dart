import 'package:flutter/material.dart';
import 'package:video_chat/app/app.export.dart';

/// Builds a background with a gradient from top to bottom.
///
/// The [colors] default to the [AppTheme.backgroundColors] if omitted.
class AppBackground extends StatelessWidget {
  const AppBackground({
    this.child,
    this.colors,
    this.borderRadius,
  });

  final Widget? child;
  final List<Color>? colors;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    final backgroundColors = colors ?? appTheme.backgroundColors;

    if (backgroundColors?.length == 1) {
      backgroundColors?.add(backgroundColors.first);
    }

    return Container(
      child: Stack(
        children: [
          // Image.asset(
          //   "IMAGENAME",
          //   width: MathUtilities.screenWidth(context),
          //   height: MathUtilities.screenHeight(context),
          //   fit: BoxFit.cover,
          // ),
          AnimatedContainer(
            duration: kThemeAnimationDuration,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors ?? [Colors.white],
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: child ?? Container()),
            ),
          ),
        ],
      ),
    );
  }
}
