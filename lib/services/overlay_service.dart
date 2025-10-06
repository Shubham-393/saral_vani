import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:system_alert_window/system_alert_window.dart';
import '../models/settings.dart';

class OverlayService {
  static final OverlayService _instance = OverlayService._internal();
  factory OverlayService() => _instance;
  OverlayService._internal();

  static const MethodChannel _channel = MethodChannel('overlay_service');
  
  bool _isOverlayActive = false;
  String _currentCaption = '';
  String _currentSimplifiedCaption = '';
  Settings? _currentSettings;

  StreamController<String> _captionController = StreamController<String>.broadcast();
  Stream<String> get captionStream => _captionController.stream;

  Future<void> initialize() async {
    try {
      // TODO: Initialize system alert window when dependency is available
      // await SystemAlertWindow.requestPermissions;
      
      // Set up method channel for overlay communication
      _channel.setMethodCallHandler(_handleMethodCall);
    } catch (e) {
      print('Failed to initialize overlay service: $e');
    }
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'updateCaption':
        final caption = call.arguments as String;
        _captionController.add(caption);
        break;
      case 'hideOverlay':
        await hideOverlay();
        break;
      default:
        throw PlatformException(
          code: 'UNIMPLEMENTED',
          message: 'OverlayService does not implement ${call.method}',
        );
    }
  }

  Future<void> showOverlay({
    required String originalCaption,
    required String simplifiedCaption,
    required Settings settings,
  }) async {
    if (_isOverlayActive) {
      await updateOverlay(originalCaption, simplifiedCaption);
      return;
    }

    try {
      _currentCaption = originalCaption;
      _currentSimplifiedCaption = simplifiedCaption;
      _currentSettings = settings;

      final overlayContent = _buildOverlayContent();

      // TODO: Implement system overlay when dependency is available
      // await SystemAlertWindow.showSystemWindow(
      //   height: 200,
      //   width: 350,
      //   gravity: SystemWindowGravity.center,
      //   notificationTitle: "SaralVani Captions",
      //   notificationBody: "Real-time captions are now active",
      //   systemWindowType: SystemWindowType.overlay,
      //   headerColor: SystemWindowMethod.setColor(settings.highContrastMode ? Colors.black : Colors.blue),
      //   statusBarColor: SystemWindowMethod.setColor(Colors.transparent),
      //   contentView: overlayContent,
      // );

      _isOverlayActive = true;
    } catch (e) {
      print('Failed to show overlay: $e');
    }
  }

  Future<void> updateOverlay(String originalCaption, String simplifiedCaption) async {
    if (!_isOverlayActive) return;

    _currentCaption = originalCaption;
    _currentSimplifiedCaption = simplifiedCaption;

    try {
      // TODO: Update the overlay content when dependency is available
      // await SystemAlertWindow.updateContent(
      //   _buildOverlayContent(),
      // );
    } catch (e) {
      print('Failed to update overlay: $e');
    }
  }

  Future<void> hideOverlay() async {
    if (!_isOverlayActive) return;

    try {
      // TODO: Close system window when dependency is available
      // await SystemAlertWindow.closeSystemWindow();
      _isOverlayActive = false;
    } catch (e) {
      print('Failed to hide overlay: $e');
    }
  }

  Widget _buildOverlayContent() {
    return Container(
      width: 350,
      height: 200,
      decoration: BoxDecoration(
        color: _currentSettings?.highContrastMode == true
            ? Colors.black
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _currentSettings?.highContrastMode == true
                  ? Colors.white
                  : Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.hearing,
                  color: _currentSettings?.highContrastMode == true
                      ? Colors.black
                      : Colors.white,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  'SaralVani',
                  style: TextStyle(
                    color: _currentSettings?.highContrastMode == true
                        ? Colors.black
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () => hideOverlay(),
                  child: Icon(
                    Icons.close,
                    color: _currentSettings?.highContrastMode == true
                        ? Colors.black
                        : Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Original caption (if available)
                  if (_currentCaption.isNotEmpty) ...[
                    Text(
                      'Original:',
                      style: TextStyle(
                        color: _currentSettings?.highContrastMode == true
                            ? Colors.white
                            : Colors.grey[600],
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _currentCaption,
                      style: TextStyle(
                        color: _currentSettings?.highContrastMode == true
                            ? Colors.white
                            : Colors.black,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                  ],
                  
                  // Simplified caption
                  if (_currentSimplifiedCaption.isNotEmpty) ...[
                    Text(
                      'Simplified:',
                      style: TextStyle(
                        color: _currentSettings?.highContrastMode == true
                            ? Colors.white
                            : Colors.grey[600],
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        _currentSimplifiedCaption,
                        style: TextStyle(
                          color: _currentSettings?.highContrastMode == true
                              ? Colors.white
                              : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: Center(
                        child: Text(
                          'Listening...',
                          style: TextStyle(
                            color: _currentSettings?.highContrastMode == true
                                ? Colors.white
                                : Colors.grey[600],
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get isOverlayActive => _isOverlayActive;

  Future<void> dispose() async {
    await hideOverlay();
    await _captionController.close();
  }
}

// Helper class for overlay positioning
class OverlayPosition {
  final double x;
  final double y;
  final String gravity;

  const OverlayPosition({
    required this.x,
    required this.y,
    this.gravity = 'center',
  });

  static const OverlayPosition center = OverlayPosition(
    x: 0,
    y: 0,
    gravity: 'center',
  );

  static const OverlayPosition topCenter = OverlayPosition(
    x: 0,
    y: 50,
    gravity: 'top',
  );

  static const OverlayPosition bottomCenter = OverlayPosition(
    x: 0,
    y: 50,
    gravity: 'bottom',
  );
}
