import 'package:child_tracker/index.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';

import 'package:qr_flutter/qr_flutter.dart';

class GenerateQrCard extends StatefulWidget {
  final String id;
  const GenerateQrCard({super.key, required this.id});

  @override
  State<GenerateQrCard> createState() => _GenerateQrCardState();
}

class _GenerateQrCardState extends State<GenerateQrCard> {
  bool generate = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width - 48;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Builder(builder: (context) {
        if (!generate) {
          return DottedBorder(
            borderPadding: const EdgeInsets.only(top: 0),
            borderType: BorderType.RRect,
            radius: const Radius.circular(20),
            color: greyscale300,
            dashPattern: const [8, 8],
            child: GestureDetector(
              onTap: () {
                setState(() {
                  generate = true;
                });
              },
              child: Container(
                width: width,
                height: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: greyscale50,
                ),
                child: const Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.add, size: 32, color: primary900),
                    SizedBox(height: 16),
                    AppText(text: 'Сгенерировать', size: 14, color: primary900),
                  ],
                )),
              ),
            ),
          );
        } else {
          return Container(
            width: width,
            height: width,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(color: greyscale200),
            ),
            child: QrImageView(
              data: widget.id,
              version: QrVersions.auto,
              size: width,
            ),
          );
        }
      }),
    );
  }
}
