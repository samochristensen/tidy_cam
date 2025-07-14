import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../services/camera_service.dart';
import '../services/imu_service.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImuService _imu = ImuService();

  AccelerometerEvent? _accel;
  GyroscopeEvent? _gyro;
  StreamSubscription? _subAccel, _subGyro;

  CameraController? _cameraController;
  bool _cameraReady = false;
  String? _cameraError;

  @override
  void initState() {
    super.initState();
    _initIMUStreams();
    _initCamera();
  }

  void _initIMUStreams() {
    _subAccel = _imu.accelStream.listen(
      (e) => setState(() => _accel = e),
      onError: (e) => debugPrint('Accel error: $e'),
    );
    _subGyro = _imu.gyroStream.listen(
      (e) => setState(() => _gyro = e),
      onError: (e) => debugPrint('Gyro error: $e'),
    );
  }

  Future<void> _initCamera() async {
    final cams = CameraService.cameras;
    if (cams.isEmpty) {
      setState(() => _cameraError = 'No cameras found');
      return;
    }

    _cameraController = CameraController(cams.first, ResolutionPreset.medium);
    try {
      await _cameraController!.initialize();
      setState(() => _cameraReady = true);
    } catch (e) {
      setState(() => _cameraError = 'Camera init failed: $e');
    }
  }

  @override
  void dispose() {
    _subAccel?.cancel();
    _subGyro?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IMU + Camera Test')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            if (_cameraError != null)
              Text(_cameraError!, style: const TextStyle(color: Colors.red))
            else if (_cameraReady && _cameraController != null)
              AspectRatio(
                aspectRatio: _cameraController!.value.aspectRatio,
                child: CameraPreview(_cameraController!),
              )
            else
              const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text('Accelerometer: ${_accel ?? 'Loading...'}'),
            Text('Gyroscope: ${_gyro ?? 'Loading...'}'),
          ],
        ),
      ),
    );
  }
}
