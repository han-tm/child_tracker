import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

class RoomInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSend;
  const RoomInputWidget({super.key, required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      color: const Color(0xFFF8F8F8),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(fontSize: 16, color: greyscale900, fontWeight: FontWeight.normal),
        minLines: 1,
        maxLines: 5,
        maxLength: 500,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            hintText: 'Сообщение',
            counterText: '',
            hintStyle: const TextStyle(fontSize: 16, color: greyscale200, fontWeight: FontWeight.normal),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, value, child) {
                  final hasText = value.text.trim().isNotEmpty;
                  return GestureDetector(
                    onTap: () {
                      if (!hasText) return;
                      onSend(controller.text);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Icon(Icons.send, color: hasText ? greyscale900 : secondary900),
                    ),
                  );
                }),
            suffixIconConstraints: const BoxConstraints(maxHeight: 21, maxWidth: 33)),
      ),
    );
  }
}
