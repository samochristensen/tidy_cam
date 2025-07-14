import 'package:flutter/material.dart';
import 'package:tidy_cam/services/permission_service.dart';
import '../routes.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _initPermissions();
  }

  Future<void> _initPermissions() async {
    // Bypass actual permission checks
    final granted = await PermissionsService.checkPermissions();
    if (granted && mounted) {
      Navigator.pushReplacementNamed(context, Routes.cameraImu);
    } else if (mounted) {
      setState(() => _checking = false);
    }
  }

  Future<void> _onContinuePressed() async {
    setState(() => _checking = true);
    // Simulate successful permission granting
    final granted = await PermissionsService.requestPermissions();
    if (!mounted) return;
    setState(() => _checking = false);
    if (granted) {
      Navigator.pushReplacementNamed(context, Routes.cameraImu);
    } else {
      // This branch is not expected in bypass mode
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unexpected permission error.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permissions (Bypass Mode)')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _checking
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_open, size: 72),
                  const SizedBox(height: 20),
                  const Text(
                    'Bypass mode active: permissions are auto-granted.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Continue'),
                    onPressed: _onContinuePressed,
                  ),
                ],
              ),
      ),
    );
  }
}
