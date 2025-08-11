import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:child_tracker/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:qr_flutter/qr_flutter.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void showQRModalBottomSheet(BuildContext context, String id) async {
  showModalBottomSheet(
    context: context,
    backgroundColor: white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return _ShowQRModalContent(id: id);
    },
  );
}

class _ShowQRModalContent extends StatefulWidget {
  final String id;
  const _ShowQRModalContent({required this.id});

  @override
  State<_ShowQRModalContent> createState() => __ShowQRModalContentState();
}

class __ShowQRModalContentState extends State<_ShowQRModalContent> {
  final GlobalKey _qrKey = GlobalKey();

  // void onTapShare() {}

  Future<Uint8List?> _capturePng() async {
    try {
      RenderRepaintBoundary boundary = _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print("QR capture error: $e");
      return null;
    }
  }

  Future<void> _shareQrCode() async {
    final Uint8List? qrImageBytes = await _capturePng();
    if (qrImageBytes == null) {
      SnackBarSerive.showErrorSnackBar('share_qr_code_error'.tr());
      return;
    }

    try {
      // final tempDir = await getTemporaryDirectory();
      // final file = await File('${tempDir.path}/qr_code.png').create();
      // await file.writeAsBytes(qrImageBytes);
      // final param = ShareParams(
      //   title: 'myQrCodeTitle'.tr(),
      //   previewThumbnail: XFile(file.path),
      //   files: [XFile(file.path)],
      // );
      // await SharePlus.instance.share(param);
      _shareOnWeb(qrImageBytes);
    } catch (e) {
      print("QR share error: $e");
      SnackBarSerive.showErrorSnackBar('share_qr_code_error'.tr());
    }
  }

  Future<void> _shareOnWeb(Uint8List imageBytes) async {
    // Проверяем поддержку Web Share API

    try {
      // Создаем File object для веба
      final blob = html.Blob([imageBytes], 'image/png');
      final file = html.File([blob], 'qr_code.png', {'type': 'image/png'});

      // Используем Web Share API
      await html.window.navigator.share({
        'title': 'myQrCodeTitle'.tr(),
        'files': [file],
      });
      return;
    } catch (e) {
      print("Web Share API failed: $e");
      // Fallback к скачиванию
    }

    // Fallback: скачивание файла
    // _downloadFile(imageBytes, 'qr_code.png');
  }

  // void _downloadFile(Uint8List bytes, String fileName) {
  //   // Создаем blob и ссылку для скачивания
  //   final blob = html.Blob([bytes]);
  //   final url = html.Url.createObjectUrlFromBlob(blob);

  //   // Создаем временную ссылку и кликаем по ней
  //   final anchor = html.AnchorElement(href: url)
  //     ..setAttribute('download', fileName)
  //     ..style.display = 'none';

  //   html.document.body?.children.add(anchor);
  //   anchor.click();

  //   // Очищаем ресурсы
  //   html.document.body?.children.remove(anchor);
  //   html.Url.revokeObjectUrl(url);
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final qrSize = size.width - 88;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: greyscale200,
                ),
              )
            ],
          ),
          const SizedBox(height: 24),
          AppText(text: 'share_qr_code'.tr(), size: 24, fw: FontWeight.w700),
          const Divider(height: 48, thickness: 1, color: greyscale200),
          RepaintBoundary(
            key: _qrKey,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(color: greyscale200),
              ),
              child: QrImageView(
                key: ValueKey(widget.id),
                data: widget.id,
                padding: EdgeInsets.zero,
                version: QrVersions.auto,
                backgroundColor: white,
                size: qrSize,
              ),
            ),
          ),
          const Divider(height: 48, thickness: 1, color: greyscale200),
          FilledAppButton(
            text: 'share'.tr(),
            onTap: () {
              _shareQrCode();
            },
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}
