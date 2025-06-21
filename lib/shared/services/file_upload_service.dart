import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

enum UploadType {
  user, // Для аватарки пользователя
  task, // Для задач
  chat, // Для файлов чата
}

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadFile({
    required XFile file,
    required UploadType type,
    String? uid,
    String? customFileName,
  }) async {
    try {
      // Генерируем путь для загрузки
      final path = _generatePath(type, uid, file.path);

      // Создаем reference для файла
      final ref = _storage.ref(path);

      // Загружаем файл
      final uploadTask = ref.putFile(File(file.path));

      // Следим за прогрессом (опционально)
      uploadTask.snapshotEvents.listen((taskSnapshot) {
        final progress = (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes) * 100;
        print('Upload progress: ${progress.toStringAsFixed(2)}%');
      });

      // Ждем завершения загрузки
      final taskSnapshot = await uploadTask;
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      print('Firebase Storage Error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('General Error: $e');
      return null;
    }
  }

  String _generatePath(UploadType type, String? uid, String filePath) {
    final fileName = p.basename(filePath);
    final uuid = uid ?? '${DateTime.now().millisecondsSinceEpoch}';

    switch (type) {
      case UploadType.user:
        return 'users/$uuid/${DateTime.now().millisecondsSinceEpoch}_$fileName';
      case UploadType.task:
        return 'task/$uuid/${DateTime.now().millisecondsSinceEpoch}_$fileName';
      case UploadType.chat:
        return 'chats/$uuid/${DateTime.now().millisecondsSinceEpoch}_$fileName';
    }
  }

  Future<void> deleteFile(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } on FirebaseException catch (e) {
      print('Error deleting file: ${e.message}');
      rethrow;
    }
  }
}
