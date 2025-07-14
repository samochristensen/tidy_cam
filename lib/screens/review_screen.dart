import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/photo_service.dart';

class ReviewScreen extends StatefulWidget {
  final File imageFile;
  const ReviewScreen({super.key, required this.imageFile});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool _isSaving = false;

  Future<bool> _requestGalleryPermission() async {
    final status = await Permission.photos.request();
    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      if (!mounted) return false;
      return await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Permission Required'),
              content: const Text(
                'Access to Photos is permanently denied. Please enable it from settings.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => openAppSettings(),
                  child: const Text('Settings'),
                ),
              ],
            ),
          ) ??
          false;
    } else {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo library permission is required')),
      );
      return false;
    }
  }

  Future<void> _onSave() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final granted = await _requestGalleryPermission();
    if (!granted) {
      setState(() => _isSaving = false);
      return;
    }

    final success = await PhotoService.saveToGallery(widget.imageFile);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success == true ? 'Photo saved!' : 'Failed to save photo',
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review Photo')),
      body: Center(child: Image.file(widget.imageFile)),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.refresh),
              label: const Text('Retake'),
            ),
            ElevatedButton.icon(
              onPressed: _isSaving ? null : _onSave,
              icon: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_alt),
              label: Text(_isSaving ? 'Saving...' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}
