
import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

class FilledAppButton extends StatelessWidget {
  final double height;
  final String text;
  final VoidCallback? onPress;
  final bool isLoading;
  final bool isActive;
  final double fontSize;
  final FontWeight fw;
  const FilledAppButton({
    super.key,
    this.height = 48,
    this.text = 'Продолжить',
    this.onPress,
    this.isLoading = false,
    this.isActive = true,
    this.fontSize = 17,
    this.fw = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isActive ? primary : secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : RobotoText(
                  text: text,
                  size: fontSize,
                  fw: fw,
                  color: isActive ? primaryText : const Color(0xFFA0A0A0),
                ),
        ),
      ),
    );
  }
}