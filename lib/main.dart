import 'package:flutter/material.dart';
import '../services/camera_service.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize available cameras once (shared globally)
  await CameraService.initializeCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMU + Camera App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: Routes.home,
      routes: routes,
    );
  }
}
