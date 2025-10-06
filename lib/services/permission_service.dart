import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionService {
  static Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  static Future<bool> requestSystemOverlayPermission() async {
    if (await Permission.systemAlertWindow.isGranted) {
      return true;
    }
    
    final status = await Permission.systemAlertWindow.request();
    return status.isGranted;
  }

  static Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  static Future<bool> requestAllPermissions() async {
    final permissions = [
      Permission.microphone,
      Permission.systemAlertWindow,
      Permission.storage,
      Permission.notification,
    ];

    final statuses = await permissions.request();
    
    return statuses.values.every((status) => status.isGranted);
  }

  static Future<Map<Permission, PermissionStatus>> checkAllPermissions() async {
    final permissions = [
      Permission.microphone,
      Permission.systemAlertWindow,
      Permission.storage,
      Permission.notification,
    ];

    return await permissions.request();
  }

  static Future<void> openAppSettings() async {
    await openAppSettings();
  }

  static Future<bool> isMicrophonePermissionGranted() async {
    return await Permission.microphone.isGranted;
  }

  static Future<bool> isSystemOverlayPermissionGranted() async {
    return await Permission.systemAlertWindow.isGranted;
  }

  static Future<bool> isStoragePermissionGranted() async {
    return await Permission.storage.isGranted;
  }

  static Future<void> showPermissionDialog(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onGranted,
    VoidCallback? onDenied,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                onDenied?.call();
              },
            ),
            ElevatedButton(
              child: Text('Grant Permission'),
              onPressed: () {
                Navigator.of(context).pop();
                onGranted();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showPermissionRequiredDialog(
    BuildContext context, {
    required String permissionType,
    required VoidCallback onSettingsPressed,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission Required'),
          content: Text(
            '$permissionType permission is required for SaralVani to work properly. '
            'Please grant this permission in the app settings.',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Open Settings'),
              onPressed: () {
                Navigator.of(context).pop();
                onSettingsPressed();
              },
            ),
          ],
        );
      },
    );
  }
}
