import 'package:flutter/material.dart';

class Styles {
  static const _textSizeLarge = 14.0;
  static const _textSizeNormal = 14.0;
  static const _textSizeSmall = 12.0;
  static final Color _textColorStrong = _hexToColor('000000');

  static headerLarge() {
    return TextStyle(
        fontSize: _textSizeLarge,
        color: _textColorStrong,
        fontWeight: FontWeight.bold);
  }

  static final headerLargeDetail = TextStyle(
      fontSize: 22, color: _textColorStrong, fontWeight: FontWeight.bold);

  static final authorText =
      TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade600);

  static final contentText = TextStyle(fontSize: _textSizeNormal, height: 1.4);

  static final excerptText = TextStyle(fontSize: _textSizeSmall, height: 1.2);

  static final tagText =
      TextStyle(color: _textColorStrong, fontStyle: FontStyle.italic);

  static final appBarText = TextStyle(color: _textColorStrong);

  static final appBgColor = Colors.lightGreen[200];

  static Color _hexToColor(String code) {
    return Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
  }
}
