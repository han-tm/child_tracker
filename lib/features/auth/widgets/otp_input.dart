import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpInput extends StatelessWidget {
  final bool enabled;
  final String? errorText;
  final Function(String)? onChanged;
  final Function(String)? onCompleted;

  const OtpInput({
    super.key,
    this.enabled = true,
    this.errorText,
    this.onChanged,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Pinput(
      length: 6,
      onCompleted: onCompleted,
      onChanged: onChanged,
      separatorBuilder: (index) => const SizedBox(width: 12),
      errorText: errorText,
      forceErrorState: errorText != null,
      errorBuilder: (errorText, pin) {
        if (errorText != null) {
          return Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: const Color(0xFFFE3323).withOpacity(0.08),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.info_rounded, color: error, size: 18),
                const SizedBox(width: 8),
                AppText(
                  text: errorText,
                  color: error,
                  size: 14,
                  fw: FontWeight.normal,
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
      enabled: enabled,
      defaultPinTheme: PinTheme(
        height: 70,
        width: 50,
        textStyle: const TextStyle(
          fontSize: 24,
          color: greyscale900,
          fontWeight: FontWeight.w700,
          fontFamily: Involve,
          height: 1.6,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: greyscale50,
        ),
      ),
      focusedPinTheme: PinTheme(
        height: 70,
        width: 50,
        textStyle: const TextStyle(
          fontSize: 24,
          color: greyscale900,
          fontWeight: FontWeight.w700,
          fontFamily: Involve,
          height: 1.6,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primary900, width: 2),
          color: greyscale50,
        ),
      ),
      followingPinTheme: PinTheme(
        height: 70,
        width: 50,
        textStyle: const TextStyle(
          fontSize: 24,
          color: greyscale900,
          fontWeight: FontWeight.w700,
          fontFamily: Involve,
          height: 1.6,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: greyscale50,
        ),
      ),
      submittedPinTheme: PinTheme(
        height: 70,
        width: 50,
        textStyle: const TextStyle(
          fontSize: 24,
          color: greyscale900,
          fontWeight: FontWeight.w700,
          fontFamily: Involve,
          height: 1.6,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: greyscale50,
        ),
      ),
      errorPinTheme: PinTheme(
        height: 70,
        width: 50,
        textStyle: const TextStyle(
          fontSize: 24,
          color: greyscale900,
          fontWeight: FontWeight.w700,
          fontFamily: Involve,
          height: 1.6,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: greyscale50,
          border: Border.all(color: error),
        ),
      ),
    );
  }
}
