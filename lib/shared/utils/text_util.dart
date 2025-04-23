

import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

class RobotoText extends StatelessWidget {
  final String text;
  final double size;
   final double? height;
  final Color color;
  final FontWeight fw;
  final int maxLine;
  final TextAlign? textAlign;
  final TextDecoration? decoration;

  const RobotoText({
    super.key,
    required this.text,
    this.size = 16,
    this.color = primaryText,
    this.fw = FontWeight.w400,
    this.maxLine = 10,
    this.height,
    this.textAlign,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fw,
        decoration: decoration,
        decorationColor: color,
        decorationThickness: 1,
        height: height,
      ),
      textAlign: textAlign,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
    );
  }
}
