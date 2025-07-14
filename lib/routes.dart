import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/camera_imu_screen.dart';
import 'screens/review_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/permission_screen.dart';

class Routes {
  static const home = '/';
  static const cameraImu = '/camera_imu';
  static const review = '/review';
  static const onboarding = '/onboarding';
  static const permission = '/permission';
}

final Map<String, WidgetBuilder> routes = {
  Routes.home: (ctx) => const HomeScreen(),
  Routes.cameraImu: (ctx) => const CameraImuScreen(),
  Routes.onboarding: (ctx) => const OnboardingScreen(),
  Routes.permission: (ctx) => const PermissionScreen(),
  Routes.review: (ctx) {
    final args = ModalRoute.of(ctx)!.settings.arguments as ReviewScreenArgs;
    return ReviewScreen(imageFile: args.imageFile);
  },
};
