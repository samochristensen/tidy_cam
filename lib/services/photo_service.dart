import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:gallery_saver_plus/gallery_saver.dart';

class PhotoService {
  /// Saves the photo to app directory; extendable for gallery-saving logic.
  static Future<File> savePhoto(XFile rawFile) async {
    final dir = await getApplicationDocumentsDirectory();
    final targetPath = join(
      dir.path,
      '${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    return await File(rawFile.path).copy(targetPath);
  }

  /// Save an image File to the device gallery.
  static Future<bool?> saveToGallery(File file) {
    return GallerySaver.saveImage(file.path);
  }
}
