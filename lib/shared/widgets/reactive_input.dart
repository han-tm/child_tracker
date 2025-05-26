
import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ReactiveCustomInput extends StatelessWidget {
  final String formName;
  final String label;
  final String hint;
  final String iconPath;
  final int maxLines;
  final int minLines;
  final TextInputType inputType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Map<String, String Function(Object)>? validationMessages;
  final bool obscure;
  final bool enabled;
  final Function(FormControl<Object?>)? onSubmitted;
  final Color? color;
  final bool hasAsyncValidator;
  final int maxLenght;

  const ReactiveCustomInput({
    super.key,
    required this.formName,
    this.label = 'Email',
    this.hint = 'Email',
    this.iconPath = 'email.svg',
    this.maxLines = 1,
    this.minLines = 1,
    this.inputType = TextInputType.text,
    this.textCapitalization = TextCapitalization.sentences,
    this.textInputAction,
    this.inputFormatters,
    this.validationMessages,
    this.obscure = false,
    this.enabled = true,
    this.onSubmitted,
    this.color,
    this.hasAsyncValidator = false,
    this.maxLenght = 500,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) AppText(text: label),
        if (label.isNotEmpty) const SizedBox(height: 8),
        ReactiveTextField(
          onSubmitted: onSubmitted,
          key: ValueKey(formName),
          readOnly: !enabled,
          showErrors: (control) => control.invalid && control.touched && enabled,
          formControlName: formName,
          validationMessages: validationMessages,
          maxLines: maxLines,
          minLines: minLines,
          keyboardType: inputType,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          obscureText: obscure,
          style: const TextStyle(fontSize: 16, color: greyscale900, fontWeight: FontWeight.normal),
          maxLength: maxLenght,
          decoration: InputDecoration(
            enabled: enabled,
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            filled: color != null ? true : !enabled,
            fillColor: color ?? (enabled ? null : const Color(0xFFF8F8F8)),
            isDense: true,
            hintText: hint,
            errorMaxLines: 4,
            counterText: '',
            errorStyle: const TextStyle(fontSize: 14, color: red, fontWeight: FontWeight.normal),
            hintStyle: const TextStyle(fontSize: 16, color: greyscale200, fontWeight: FontWeight.normal),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: greyscale200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: greyscale200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: primary900),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: red),
            ),
            suffix: ReactiveFormConsumer(builder: (context, form, child) {
              return hasAsyncValidator && form.control(formName).pending
                  ? const SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: primary900,
                      ))
                  : const SizedBox();
            }),
          ),
        ),
      ],
    );
  }
}
