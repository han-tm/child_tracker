import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CachedClickableImage extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final double? circularRadius;
  final VoidCallback? onTap;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CachedClickableImage({
    super.key,
    this.imageUrl,
    this.imageFile,
    this.width,
    this.height,
    this.borderRadius,
    this.circularRadius,
    this.onTap,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  })  : assert(imageUrl != null || imageFile != null, 'Необходимо предоставить либо URL изображения, либо File.'),
        assert(!(borderRadius != null && circularRadius != null),
            'Нельзя одновременно указывать borderRadius и circularRadius.');

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (imageFile != null) {
      imageWidget = Image.file(
        imageFile!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          return errorWidget ?? const Icon(Icons.error);
        },
      );
    } else if (imageUrl != null) {
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => Container(
          color: Colors.grey.shade300,
          child: placeholder ?? const CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade300,
          child: errorWidget ?? const Icon(Icons.error),
        ),
      );
    } else {
      // Этого блока никогда не должно быть из-за assert
      imageWidget = const SizedBox.shrink();
    }

    if (circularRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(circularRadius!),
        child: imageWidget,
      );
    } else if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return InkWell(
      onTap: onTap,
      child: imageWidget,
    );
  }
}
