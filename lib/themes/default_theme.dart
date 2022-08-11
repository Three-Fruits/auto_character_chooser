import 'package:flutter/material.dart';

class DefaultTheme {
  ThemeData defaultTheme() {
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
      // colorScheme: _defaultColorCheme,
      textTheme: _buildDefaultTextTheme(base.textTheme),
    );
  }
}

TextTheme _buildDefaultTextTheme(TextTheme base) {
  return base
      .copyWith(
        caption: base.caption?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          letterSpacing: defaultLetterSpacing,
        ),
        button: base.button?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          letterSpacing: defaultLetterSpacing,
        ),
      )
      .apply(
        fontFamily: 'Rubik',
        bodyColor: secondaryColor,
      );
}

// const ColorScheme _defaultColorCheme = ColorScheme(
//   primary: mainColor,
//   secondary: shrinePink50,
//   surface: shrineSurfaceWhite,
//   background: shrineBackgroundWhite,
//   error: shrineErrorRed,
//   onPrimary: shrineBrown900,
//   onSecondary: shrineBrown900,
//   onSurface: shrineBrown900,
//   onBackground: shrineBrown900,
//   onError: shrineSurfaceWhite,
//   brightness: Brightness.dark,
// );

const Color mainColor = Color(0xFF64056F);
const Color secondaryColor = Color(0xFFFAF4FB);

const defaultLetterSpacing = 0.03;
