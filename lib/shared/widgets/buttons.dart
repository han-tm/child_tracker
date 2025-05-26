import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

class FilledAppButton extends StatelessWidget {
  final double height;
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isActive;
  final double fontSize;
  final FontWeight fw;
  const FilledAppButton({
    super.key,
    this.height = 58,
    this.text = 'Продолжить',
    this.onTap,
    this.isLoading = false,
    this.isActive = true,
    this.fontSize = 16,
    this.fw = FontWeight.w700,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isActive ? primary900 : disabledColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : AppText(
                  text: text,
                  size: fontSize,
                  fw: fw,
                  color: white,
                ),
        ),
      ),
    );
  }
}
