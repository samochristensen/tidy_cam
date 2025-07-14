import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraService {
  static List<CameraDescription> cameras = [];
  CameraController? controller;

  static Future<void> initializeCameras() async {
    try {
      cameras = await availableCameras();
      debugPrint('Available cameras: ${cameras.length}');
    } catch (e) {
      debugPrint('Error initializing cameras: $e');
    }
  }

  Future<void> initCamera({
    int index = 0,
    ResolutionPreset preset = ResolutionPreset.medium,
  }) async {
    final cam = cameras.isNotEmpty
        ? cameras[index]
        : throw CameraException('NoCamera', 'No cameras found.');
    controller = CameraController(cam, preset);
    await controller!.initialize();
  }

  Future<XFile> takePicture() async {
    if (controller == null || !controller!.value.isInitialized) {
      throw CameraException(
        'Uninitialized',
        'CameraController is not initialized.',
      );
    }
    if (controller!.value.isTakingPicture) {
      throw CameraException('Busy', 'Camera is already taking a picture.');
    }
    return await controller!.takePicture();
  }

  void dispose() => controller?.dispose();
}
