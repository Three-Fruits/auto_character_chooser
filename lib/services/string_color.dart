import 'dart:ui';

class ColorConvert {
  static Color converColor(String color) {
    return Color(int.parse(color, radix: 16));
  }
}
