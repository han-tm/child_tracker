
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

class FilledSecondaryAppButton extends StatelessWidget {
  final double height;
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isActive;
  final double fontSize;
  final FontWeight fw;
  final Widget? icon;
  const FilledSecondaryAppButton({
    super.key,
    this.height = 58,
    this.text = 'Продолжить',
    this.onTap,
    this.isLoading = false,
    this.isActive = true,
    this.fontSize = 16,
    this.fw = FontWeight.w700,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE4E7FF) : disabledColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(icon != null) icon!,
                  Flexible(
                    child: AppText(
                        text: text,
                        size: fontSize,
                        fw: fw,
                        color: primary900,
                        textAlign: TextAlign.center,
                      ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}

class FilledDestructiveAppButton extends StatelessWidget {
  final double height;
  final Widget child;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isActive;
  final double fontSize;
  final FontWeight fw;
  const FilledDestructiveAppButton({
    super.key,
    this.height = 58,
    required this.child,
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
          color: isActive ? const Color(0xFFFFEFED) : disabledColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: isLoading ? const CircularProgressIndicator(color: Colors.white) : child,
        ),
      ),
    );
  }
}

class OutlinedAppButton extends StatelessWidget {
  final double height;
  final String text;
  final VoidCallback? onPress;
  final bool isLoading;
  final double fontSize;
  final FontWeight fw;
  final bool isActive;

  const OutlinedAppButton({
    super.key,
    this.height = 58,
    this.text = 'Продолжить',
    this.onPress,
    this.isLoading = false,
    this.fontSize = 16,
    this.fw = FontWeight.w700,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: null,
          border: Border.all(color: isActive ? primary900 : primary900.withOpacity(0.5), width: 2),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(color: primary900)
              : AppText(text: text, size: fontSize, fw: fw, color: isActive ? primary900 : primary900.withOpacity(0.5)),
        ),
      ),
    );
  }
}
