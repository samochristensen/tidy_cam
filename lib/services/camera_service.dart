import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraService {
  static List<CameraDescription> cameras = [];

  static Future<void> initializeCameras() async {
    try {
      cameras = await availableCameras();
      debugPrint('Available cameras: ${cameras.length}');
    } catch (e) {
      debugPrint('Error initializing cameras: $e');
    }
  }
}
