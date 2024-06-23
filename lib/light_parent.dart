import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class BackgroundModel with ChangeNotifier {
  Color? _color;
  double? _blur;
  DecorationImage? _image;
  BlendMode? _blendMode;

  Color? get exportBackgroundColor => _color;

  double? get exportBackgroundBlur => _blur;

  DecorationImage? get exportBackgroundImage => _image;

  BlendMode? get exportBackgroundBlendMode => _blendMode;

  void color(Color color) {
    _color = color;
    notifyListeners();
  }

  void rgba(int r, int g, int b, [double opacity = 1.0]) {
    _color = Color.fromRGBO(r, g, b, opacity);
    notifyListeners();
  }

  void hex(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex..replaceFirst('#', ''));
    _color = Color(int.parse(buffer.toString(), radix: 16));
    notifyListeners();
  }

  void blur(double blur) {
    _blur = blur;
    notifyListeners();
  }

  void image({
    String? url,
    String? path,
    ImageProvider<dynamic>? imageProvider,
    ColorFilter? colorFilter,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
  }) {
    if ((url ?? path ?? imageProvider) == null) {
      throw ('Either the [imageProvider], [url] or the [path] has to be provided');
    }

    ImageProvider<dynamic> image;
    if (imageProvider != null) {
      image = imageProvider;
    } else if (path != null) {
      image = AssetImage(path);
    } else {
      image = NetworkImage(url!);
    }

    _image = DecorationImage(
      image: image as ImageProvider<Object>,
      colorFilter: colorFilter,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
    );
    notifyListeners();
  }

  void blendMode(BlendMode blendMode) => _blendMode = blendMode;
}

class AlignmentModel with ChangeNotifier {
  late AlignmentGeometry _alignment;

  AlignmentGeometry get getAlignment => _alignment;

  void topLeft([bool enable = true]) => _updateAlignment(Alignment.topLeft, enable);

  void topCenter([bool enable = true]) => _updateAlignment(Alignment.topCenter, enable);

  void topRight([bool enable = true]) => _updateAlignment(Alignment.topRight, enable);

  void bottomLeft([bool enable = true]) => _updateAlignment(Alignment.bottomLeft, enable);

  void bottomCenter([bool enable = true]) => _updateAlignment(Alignment.bottomCenter, enable);

  void bottomRight([bool enable = true]) => _updateAlignment(Alignment.bottomRight, enable);

  void centerLeft([bool enable = true]) => _updateAlignment(Alignment.centerLeft, enable);

  void center([bool enable = true]) => _updateAlignment(Alignment.center, enable);

  void centerRight([bool enable = true]) => _updateAlignment(Alignment.centerRight, enable);

  void coordinate(double x, double y, [bool enable = true]) => _updateAlignment(Alignment(x, y), enable);

  void _updateAlignment(AlignmentGeometry alignment, bool enable) {
    if (enable) {
      _alignment = alignment;
      notifyListeners();
    }
  }
}

enum AngleFormat { degree, radians, cycles }

class RippleModel {
  final bool? enable;
  final Color? highlightColor;
  final Color? splashColor;

  RippleModel({this.enable, this.highlightColor, this.splashColor});
}

class ParentStyle {
  ParentStyle({this.angleFormat = AngleFormat.cycles}) {
    background.addListener(() {
      _backgroundColor = background.exportBackgroundColor;
      _backgroundBlur = background.exportBackgroundBlur;
      _backgroundImage = background.exportBackgroundImage;
      _backgroundBlendMode = background.exportBackgroundBlendMode;
    });

    alignment.addListener(() => _alignment = alignment.getAlignment);
    alignmentContent.addListener(() => _alignmentContent = alignmentContent.getAlignment);
  }

  final AngleFormat angleFormat;
  EdgeInsets? _margin;
  EdgeInsets? _padding;
  Border? _border;
  BorderRadius? _borderRadius;
  double? _opacity;
  double? _rotate;
  RippleModel? _ripple;
  List<BoxShadow>? _boxShadow;
  Color? _backgroundColor;
  double? _backgroundBlur;
  DecorationImage? _backgroundImage;
  BlendMode? _backgroundBlendMode;
  AlignmentGeometry? _alignment;
  double? _scale;
  Offset? _offset;
  BoxShape? _boxShape;
  Gradient? _gradient;
  AlignmentGeometry? _alignmentContent;
  double? _width;
  double? _maxWidth;
  double? _minWidth;
  double? _height;
  double? _maxHeight;
  double? _minHeight;

  final BackgroundModel background = BackgroundModel();
  final AlignmentModel alignment = AlignmentModel();
  final AlignmentModel alignmentContent = AlignmentModel();

  void linearGradient({
    AlignmentGeometry begin = Alignment.centerLeft,
    AlignmentGeometry end = Alignment.centerRight,
    required List<Color> colors,
    TileMode tileMode = TileMode.clamp,
    List<double>? stops,
  }) {
    _gradient = LinearGradient(begin: begin, end: end, colors: colors, tileMode: tileMode, stops: stops);
  }

  void radialGradient(
      {AlignmentGeometry center = Alignment.center,
      required double radius,
      required List<Color> colors,
      TileMode tileMode = TileMode.clamp,
      List<double>? stops}) {
    _gradient = RadialGradient(
      center: center,
      radius: radius,
      colors: colors,
      tileMode: tileMode,
      stops: stops,
    );
  }

  void sweepGradient(
      {AlignmentGeometry center = Alignment.center,
      double startAngle = 0.0,
      required double endAngle,
      required List<Color> colors,
      TileMode tileMode = TileMode.clamp,
      List<double>? stops}) {
    _gradient = SweepGradient(
      center: center,
      startAngle: angleToRadians(startAngle, angleFormat),
      endAngle: angleToRadians(endAngle, angleFormat),
      colors: colors,
      stops: stops,
      tileMode: tileMode,
    );
  }

  void circle([enable = true]) => enable ? _boxShape = BoxShape.circle : null;

  void scale(double ratio) => _scale = ratio;

  void offset(double dx, double dy) => _offset = Offset(dx, dy);

  void boxShadow(
          {Color color = const Color(0x33000000),
          double blur = 0.0,
          Offset offset = Offset.zero,
          double spread = 0.0}) =>
      _boxShadow = [
        BoxShadow(
          color: color,
          blurRadius: blur,
          spreadRadius: spread,
          offset: offset,
        ),
      ];

  void ripple(bool enable, {Color? splashColor, Color? highlightColor}) {
    _ripple = RippleModel(
      enable: enable,
      splashColor: splashColor,
      highlightColor: highlightColor,
    );
  }

  void margin({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    _margin = EdgeInsets.only(
      top: top ?? vertical ?? all ?? 0.0,
      bottom: bottom ?? vertical ?? all ?? 0.0,
      left: left ?? horizontal ?? all ?? 0.0,
      right: right ?? horizontal ?? all ?? 0.0,
    );
  }

  void padding({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    _padding = EdgeInsets.only(
      top: top ?? vertical ?? all ?? 0.0,
      bottom: bottom ?? vertical ?? all ?? 0.0,
      left: left ?? horizontal ?? all ?? 0.0,
      right: right ?? horizontal ?? all ?? 0.0,
    );
  }

  void border({
    double? all,
    double? left,
    double? right,
    double? top,
    double? bottom,
    Color color = const Color(0xFF000000),
    BorderStyle style = BorderStyle.solid,
  }) {
    _border = Border(
      left: (left ?? all) == null ? BorderSide.none : BorderSide(color: color, width: left ?? all!, style: style),
      right: (right ?? all) == null ? BorderSide.none : BorderSide(color: color, width: right ?? all!, style: style),
      top: (top ?? all) == null ? BorderSide.none : BorderSide(color: color, width: top ?? all!, style: style),
      bottom: (bottom ?? all) == null ? BorderSide.none : BorderSide(color: color, width: bottom ?? all!, style: style),
    );
  }

  void borderRadius({double? all, double? topLeft, double? topRight, double? bottomLeft, double? bottomRight}) {
    _borderRadius = BorderRadius.only(
      topLeft: Radius.circular(topLeft ?? all ?? 0.0),
      topRight: Radius.circular(topRight ?? all ?? 0.0),
      bottomLeft: Radius.circular(bottomLeft ?? all ?? 0.0),
      bottomRight: Radius.circular(bottomRight ?? all ?? 0.0),
    );
  }

  void width(double width) => _width = width;

  void maxWidth(double width) => _maxWidth = width;

  void minWidth(double width) => _minWidth = width;

  void height(double height) => _height = height;

  void maxHeight(double height) => _maxHeight = height;

  void minHeight(double height) => _minHeight = height;

  void rotate(double angle) => _rotate = angleToRadians(angle, angleFormat);

  void opacity(double opacity) => _opacity = opacity;

  double angleToRadians(double value, AngleFormat angleFormat) {
    switch (angleFormat) {
      case AngleFormat.radians:
        break;
      case AngleFormat.cycles:
        value = value * 2 * pi;
        break;
      case AngleFormat.degree:
        value = (value / 360) * 2 * pi;
        break;
    }
    return value;
  }

  BoxDecoration? get decoration {
    BoxDecoration boxDecoration = BoxDecoration(
      color: _backgroundColor,
      image: _backgroundImage,
      gradient: _gradient,
      border: _border,
      borderRadius: _borderRadius,
      shape: _boxShape ?? BoxShape.rectangle,
      backgroundBlendMode: _backgroundBlendMode,
      boxShadow: _boxShadow,
    );
    return boxDecoration;
  }

  Matrix4? get transform {
    if ((_scale ?? _rotate ?? _offset) != null) {
      return Matrix4.rotationZ(_rotate ?? 0.0)
        ..scale(_scale ?? 1.0)
        ..translate(
          _offset?.dx ?? 0.0,
          _offset?.dy ?? 0.0,
        );
    }
    return null;
  }

  BoxConstraints? get constraints {
    BoxConstraints? boxConstraints;
    if ((_minHeight ?? _maxHeight ?? _minWidth ?? _maxWidth) != null) {
      boxConstraints = BoxConstraints(
        minWidth: _minWidth ?? 0.0,
        maxWidth: _maxWidth ?? double.infinity,
        minHeight: _minHeight ?? 0.0,
        maxHeight: _maxHeight ?? double.infinity,
      );
    }
    boxConstraints = (_width != null || _height != null)
        ? boxConstraints?.tighten(width: _width, height: _height) ??
            BoxConstraints.tightFor(width: _width, height: _height)
        : boxConstraints;

    return boxConstraints;
  }
}

class Gestures {
  void Function()? _onTap;
  void Function()? _onLongPress;

  void onTap(void Function() function) => _onTap = function;

  void onLongPress(void Function() function) => _onLongPress = function;
}

class LightParent extends StatelessWidget {
  const LightParent({super.key, this.child, this.style, this.gesture});

  final Widget? child;
  final ParentStyle? style;
  final Gestures? gesture;

  @override
  Widget build(BuildContext context) {
    if (child == null) return Container();
    Widget tree = child!;

    if (style?._alignmentContent != null) {
      tree = Align(alignment: style!._alignmentContent!, child: tree);
    }

    if (style?._padding != null) {
      tree = Padding(padding: style!._padding!, child: child);
    }

    if (style?._ripple != null && style?._ripple?.enable == true) {
      tree = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: gesture?._onTap ?? () {},
          onLongPress: gesture?._onLongPress ?? () {},
          borderRadius: style?._borderRadius,
          highlightColor: style?._ripple?.highlightColor,
          splashColor: style?._ripple?.splashColor,
          child: tree,
        ),
      );
    }

    if (style?.decoration != null) {
      tree = DecoratedBox(decoration: style!.decoration!, child: tree);
    }

    if (gesture != null && style?._ripple == null) {
      tree = GestureDetector(onLongPress: gesture!._onLongPress, onTap: gesture!._onTap, child: tree);
    }

    if (style?.constraints != null) {
      tree = ConstrainedBox(constraints: style!.constraints!, child: tree);
    }

    if (style?._margin != null) {
      tree = Padding(padding: style!._margin!, child: tree);
    }

    if (style?._backgroundBlur != null) {
      tree = ClipRRect(
        borderRadius: style?._borderRadius ?? BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: style!._backgroundBlur!, sigmaY: style!._backgroundBlur!),
          child: tree,
        ),
      );
    }

    if (style?._alignment != null) {
      tree = Align(alignment: style!._alignment!, child: tree);
    }

    if (style?._opacity != null) {
      tree = Opacity(opacity: style!._opacity!, child: tree);
    }

    if (style?.transform != null) {
      tree = Transform(alignment: FractionalOffset.center, transform: style!.transform!, child: tree);
    }
    return tree;
  }
}
