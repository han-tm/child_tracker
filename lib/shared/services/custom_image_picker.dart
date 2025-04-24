import 'package:child_tracker/index.dart';

import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class CustomImagePicker {
  static const allowedMimeTypes = [
    'image/jpeg',
    'image/png',
    'image/gif',
    'image/webp',
    'image/heic',
    'image/heif',
  ];

  static const allowedVideoMimeTypes = [
    'video/mp4',
    'video/quicktime', // .mov
    'video/x-matroska', // .mkv
    'video/webm',
    'video/3gpp',
    'video/avi', // может быть 'video/x-msvideo'
  ];

  static const allowedPhotoOrPdfMimeTypes = [
    'image/jpeg',
    'image/png',
    'image/gif',
    'image/webp',
    'image/heic',
    'image/heif',
    'application/pdf',
  ];

  static final _picker = ImagePicker();

  /// Показывает галерею и возвращает XFile только если это изображение.
  static Future<XFile?> pickAvatarFromGallery() async {
    final XFile? xfile = await _picker.pickImage(source: ImageSource.gallery);

    if (xfile == null) return null; // пользователь ничего не выбрал

    final mimeType = lookupMimeType(xfile.path);

    if (mimeType == null || !allowedMimeTypes.contains(mimeType)) {
      SnackBarSerive.showErrorSnackBar('Можно выбрать только фотографию');
      return null;
    }

    return xfile;
  }

  static Future<XFile?> pickVideoFromGallery() async {
    final XFile? xfile = await _picker.pickVideo(source: ImageSource.gallery);

    if (xfile == null) return null;

    final mimeType = lookupMimeType(xfile.path);

    if (mimeType == null || !allowedVideoMimeTypes.contains(mimeType)) {
      SnackBarSerive.showErrorSnackBar('Можно выбрать только видео');
      return null;
    }

    return xfile;
  }
}
