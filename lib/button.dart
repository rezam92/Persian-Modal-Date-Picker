import 'package:division/division.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final double? width;
  final double? height;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? radius;
  final double? border;
  final Color? backgroundColor;
  final Color? borderColor;
  final Widget? child;
  final Function? onPress;

  const Button({
    Key? key,
    this.width,
    this.height,
    this.verticalPadding,
    this.horizontalPadding,
    this.backgroundColor,
    this.border,
    this.borderColor,
    this.radius,
    this.onPress,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = ParentStyle()
      ..ripple(true)
      ..alignmentContent.center();
    if (width != null) style.width(width ?? 0);
    if (height != null) style.height(height ?? 0);
    // if(verticalPadding != null && horizontalPadding != null)
    style.padding(vertical: verticalPadding, horizontal: horizontalPadding);
    if (backgroundColor != null)
      style.background.color(backgroundColor ?? Colors.white);
    if (radius != null) style.borderRadius(all: radius);
    if (border != null)
      style.border(all: 1, color: borderColor ?? Colors.transparent);

    return Parent(
      style: style,
      gesture: Gestures()
        ..onTap(() async {
          await onPress?.call();
        }),
      child: child,
    );
  }
}

class ButtonsStyle {
  final Color backgroundColor;
  final Color textColor;
  final double radius;
  final bool visible;
  final String? text;

  const ButtonsStyle({
    @required this.text,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
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
