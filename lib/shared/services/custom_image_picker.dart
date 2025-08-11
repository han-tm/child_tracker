import 'dart:typed_data';

import 'package:child_tracker/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';

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
    'video/quicktime',
    'video/x-matroska',
    'video/webm',
    'video/3gpp',
    'video/avi',
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

  static const allowedPhotoOrVideoTypes = [
    'image/jpeg',
    'image/png',
    'image/gif',
    'image/webp',
    'image/heic',
    'image/heif',
    'video/mp4',
    'video/quicktime',
    'video/x-matroska',
    'video/webm',
    'video/3gpp',
    'video/avi',
  ];

  static final _picker = ImagePicker();

  static Future<XFile?> pickAvatarFromGallery(BuildContext context, {ImageSource? source}) async {
    // source ??= await showImageSourceSelectModalBottomSheet(context);

    // if (source == null) return null;

    final XFile? xfile = await _picker.pickImage(source: ImageSource.gallery);

    if (xfile == null) return null;

    if (xfile.mimeType == null) {
      return xfile;
    } else {
      final mimeType = xfile.mimeType!;

      if (!allowedMimeTypes.contains(mimeType)) {
        SnackBarSerive.showErrorSnackBar('onlyPhoto'.tr());
        return null;
      }
    }

    return xfile;
  }

  // static Future<XFile?> pickVideoFromGallery() async {
  //   final XFile? xfile = await _picker.pickVideo(source: ImageSource.gallery);

  //   if (xfile == null) return null;

  //   final mimeType = lookupMimeType(xfile.path);

  //   if (mimeType == null || !allowedVideoMimeTypes.contains(mimeType)) {
  //     SnackBarSerive.showErrorSnackBar('Можно выбрать только видео');
  //     return null;
  //   }

  //   return xfile;
  // }

  static Future<XFile?> pickPhotoOrVideo(BuildContext context) async {
    final XFile? xfile = await _picker.pickMedia();

    if (xfile == null) return null;

    final mimeType = xfile.mimeType;

    // final mimeType = lookupMimeType(xfile.path);

    if (mimeType == null || !allowedPhotoOrVideoTypes.contains(mimeType)) {
      SnackBarSerive.showErrorSnackBar('onlyPhotoOrVideo'.tr());
      return null;
    }

    return xfile;
  }

  static bool isVideo(String path) {
    final mimeType = lookupMimeType(path);
    return allowedVideoMimeTypes.contains(mimeType);
  }

  static bool isVideoForWeb(XFile file) {
    final mimeType = file.mimeType;

    return allowedVideoMimeTypes.contains(mimeType);
  }

  static Future<bool> isVideoUrl(String url) async {
    return await _detectFromFirebaseMetadata(url);

    // final String path = url.split('?').first;
    // final lowerCaseUrl = path.toLowerCase();
    // return lowerCaseUrl.endsWith('.mp4') ||
    //     lowerCaseUrl.endsWith('.mov') ||
    //     lowerCaseUrl.endsWith('.avi') ||
    //     lowerCaseUrl.endsWith('.mkv') ||
    //     lowerCaseUrl.endsWith('.webm') ||
    //     lowerCaseUrl.endsWith('.flv') ||
    //     lowerCaseUrl.endsWith('.wmv');
  }

  static Future<Uint8List?> getFileVideoThumbnail(String path) async {
    final thumb = await VideoThumbnail.thumbnailData(
      video: path,
      maxHeight: 120,
      maxWidth: 120,
      quality: 75,
    );
    return thumb;
  }

  static Future<bool> _detectFromFirebaseMetadata(String url) async {
    try {
      // Извлекаем путь из URL
      final path = _extractPathFromUrl(url);
      if (path == null) return false;

      // Получаем ссылку на файл в Firebase Storage
      final ref = FirebaseStorage.instance.ref(path);
      final metadata = await ref.getMetadata();

      final contentType = metadata.contentType;
      return _getFileTypeFromMimeType(contentType);
    } catch (e) {
      print('Failed to get Firebase metadata: $e');
      return false;
    }
  }

  static String? _extractPathFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.pathSegments.contains('o')) {
        final oIndex = uri.pathSegments.indexOf('o');
        if (oIndex + 1 < uri.pathSegments.length) {
          return Uri.decodeComponent(uri.pathSegments[oIndex + 1]);
        }
      }
      return null;
    } catch (e) {
      print('Failed to extract path from URL: $e');
      return null;
    }
  }

  static bool _getFileTypeFromMimeType(String? mimeType) {
    if (mimeType == null) return false;

    final lowerMimeType = mimeType.toLowerCase();

    if (lowerMimeType.startsWith('image/')) {
      return false;
    } else {
      return true;
    }
  }

  static Future<XFile?> getFileVideoThumbnailFromUrl(String url) async {
    final thumb = await VideoThumbnail.thumbnailFile(
      video: url,
      // thumbnailPath: (await getTemporaryDirectory()).path,
      maxHeight: 100,
      maxWidth: 100,
      quality: 75,
    );
    return thumb;
  }
}
