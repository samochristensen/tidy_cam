import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../services/camera_service.dart';
import '../services/imu_service.dart';
import '../services/photo_service.dart';
import './review_screen.dart';

class CameraImuScreen extends StatefulWidget {
  const CameraImuScreen({super.key});
  @override
  State<CameraImuScreen> createState() => _CameraImuScreenState();
}

class _CameraImuScreenState extends State<CameraImuScreen> {
  final cameraService = CameraService();
  final imuService = ImuService();

  AccelerometerEvent? _accel;
  StreamSubscription? _accelSub;
  bool _cameraReady = false;
  String? _cameraError;

  @override
  void initState() {
    super.initState();
    _accelSub = imuService.accelStream.listen(
      (e) => setState(() => _accel = e),
      onError: (e) => debugPrint('IMU accel error: $e'),
    );
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      await cameraService.initCamera();
      setState(() => _cameraReady = true);
    } catch (e) {
      debugPrint('Camera init failed: $e');
      setState(() => _cameraError = e.toString());
    }
  }

  @override
  void dispose() {
    _accelSub?.cancel();
    cameraService.dispose();
    super.dispose();
  }

  Future<void> _onCapture() async {
    try {
      final raw = await cameraService.takePicture();
      final saved = await PhotoService.savePhoto(raw);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ReviewScreen(imageFile: saved)),
      );
    } catch (e) {
      debugPrint('Capture failed: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Capture error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera + IMU')),
      body: _cameraError != null
          ? Center(
              child: Text(
                _cameraError!,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : _cameraReady
          ? Stack(
              children: [
                CameraPreview(cameraService.controller!),
                _buildOverlays(),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: _cameraReady
          ? FloatingActionButton(
              onPressed: _onCapture,
              child: const Icon(Icons.camera_alt),
            )
          : null,
    );
  }

  Widget _buildOverlays() {
    return LayoutBuilder(
      builder: (ctx, b) {
        final w = b.maxWidth, h = b.maxHeight;
        final cx = w / 2, cy = h / 2;
        final dx = ((_accel?.x ?? 0) * 10).clamp(-50, 50);
        final dy = ((_accel?.y ?? 0) * 10).clamp(-50, 50);

        return Stack(
          children: [
            Positioned(
              left: cx - 100,
              top: cy - 150,
              width: 200,
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.7),
                    width: 2,
                  ),
                ),
              ),
            ),
            Positioned(
              left: cx - 5 + dx,
              top: cy - 5 + dy,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
