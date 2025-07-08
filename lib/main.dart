import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:camera/camera.dart';
import 'dart:async';

List<CameraDescription> _cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMU + Camera Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AccelerometerEvent? _accelerometer;
  GyroscopeEvent? _gyroscope;
  StreamSubscription? _accelSub;
  StreamSubscription? _gyroSub;

  late CameraController _cameraController;
  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();

    _accelSub = accelerometerEvents.listen((event) {
      setState(() {
        _accelerometer = event;
      });
    });

    _gyroSub = gyroscopeEvents.listen((event) {
      setState(() {
        _gyroscope = event;
      });
    });

    if (_cameras.isNotEmpty) {
      _cameraController = CameraController(
        _cameras.first,
        ResolutionPreset.medium,
      );
      _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() => _isCameraReady = true);
      });
    }
  }

  @override
  void dispose() {
    _accelSub?.cancel();
    _gyroSub?.cancel();
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('IMU + Camera Test')),
      body: Column(
        children: [
          if (_isCameraReady)
            AspectRatio(
              aspectRatio: _cameraController.value.aspectRatio,
              child: CameraPreview(_cameraController),
            ),
          SizedBox(height: 20),
          Text('Accelerometer: ${_accelerometer ?? "Loading..."}'),
          Text('Gyroscope: ${_gyroscope ?? "Loading..."}'),
        ],
      ),
    );
  }
}
