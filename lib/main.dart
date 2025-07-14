import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:camera/camera.dart';
import 'dart:async';

List<CameraDescription> _cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    _cameras = await availableCameras();
    debugPrint('Available cameras: ${_cameras.length}');
  } catch (e) {
    debugPrint('Error getting available cameras: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMU + Camera Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AccelerometerEvent? _accelerometer;
  GyroscopeEvent? _gyroscope;
  StreamSubscription? _accelSub;
  StreamSubscription? _gyroSub;

  CameraController? _cameraController;
  bool _isCameraReady = false;
  String? _cameraError;

  @override
  void initState() {
    super.initState();

    debugPrint('Initializing IMU streams...');
    _accelSub = accelerometerEventStream().listen(
      (event) {
        setState(() => _accelerometer = event);
      },
      onError: (e) {
        debugPrint('Accelerometer error: $e');
      },
    );

    _gyroSub = gyroscopeEventStream().listen(
      (event) {
        setState(() => _gyroscope = event);
      },
      onError: (e) {
        debugPrint('Gyroscope error: $e');
      },
    );

    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (_cameras.isEmpty) {
      setState(() {
        _cameraError = 'No cameras found on device.';
      });
      debugPrint('Camera init error: No cameras available');
      return;
    }

    _cameraController = CameraController(
      _cameras.first,
      ResolutionPreset.medium,
    );

    try {
      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() => _isCameraReady = true);
      debugPrint('Camera initialized successfully.');
    } catch (e) {
      setState(() {
        _cameraError = 'Camera failed to initialize: $e';
      });
      debugPrint('Camera initialization error: $e');
    }
  }

  @override
  void dispose() {
    debugPrint('Disposing resources...');
    _accelSub?.cancel();
    _gyroSub?.cancel();
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
              Text(
                _cameraError!,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              )
            else if (_isCameraReady)
              AspectRatio(
                aspectRatio: _cameraController!.value.aspectRatio,
                child: CameraPreview(_cameraController!),
              )
            else
              const CircularProgressIndicator(),

            const SizedBox(height: 20),
            Text('Accelerometer: ${_accelerometer ?? "Loading..."}'),
            Text('Gyroscope: ${_gyroscope ?? "Loading..."}'),
          ],
        ),
      ),
    );
  }
}
