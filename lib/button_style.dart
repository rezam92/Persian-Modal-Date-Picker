import 'package:flutter/material.dart';

class ButtonsStyle {
  final Color? backgroundColor;
  final Color? textColor;
  final double radius;
  final bool visible;
  final String? text;

  const ButtonsStyle({
    @required this.text,
    this.backgroundColor,
    this.textColor,
    this.radius = 5,
    this.visible = true,
  }) : assert(text != null);

  ButtonsStyle copyWith({
    Color? backgroundColor,
    Color? textColor,
    double? radius,
    bool? visible,
    String? text,
  }) {
    return new ButtonsStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      radius: radius ?? this.radius,
      visible: visible ?? this.visible,
      text: text ?? this.text,
    );
  }
}
