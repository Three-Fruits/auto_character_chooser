import 'package:auto_character_chooser/themes/my_colors.dart';
import 'package:flutter/material.dart';

class DefaultTheme {
  ThemeData defaultTheme() {
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
      backgroundColor: MyColors.xiketic,
      scaffoldBackgroundColor: MyColors.xiketic,
      focusColor: MyColors.yellow,
      colorScheme: _defaultColorCheme,
      appBarTheme: AppBarTheme(backgroundColor: MyColors.xiketic),
      drawerTheme: DrawerThemeData(backgroundColor: MyColors.xiketic),
      textTheme: _buildDefaultTextTheme(base.textTheme),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.black,
          primary: buttonColors,
        ),
      ),
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

const ColorScheme _defaultColorCheme = ColorScheme(
  brightness: Brightness.dark,
  primary: MyColors.yellow,
  onPrimary: MyColors.yellow,
  secondary: MyColors.yellow,
  onSecondary: MyColors.black,
  error: MyColors.yellow,
  onError: MyColors.yellow,
  background: MyColors.yellow,
  onBackground: MyColors.yellow,
  surface: MyColors.yellow,
  onSurface: MyColors.yellow,
);

const Color mainColor = Color(0xFF64056F);
const Color secondaryColor = Color(0xFFFAF4FB);
const Color buttonColors = Colors.green;

const defaultLetterSpacing = 0.03;
