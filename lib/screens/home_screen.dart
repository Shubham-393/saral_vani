import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import '../services/permission_service.dart';
import '../services/database_service.dart';
import '../services/stt_service.dart';
import '../services/ai_simplification_service.dart';
import '../services/sound_classification_service.dart';
import '../services/overlay_service.dart';
import '../models/settings.dart';
import '../models/transcript.dart';
import '../widgets/caption_display.dart';
import '../widgets/control_panel.dart';
import '../widgets/isl_avatar_widget.dart';
import '../widgets/sound_alert_indicator.dart';
import 'settings_screen.dart';
import 'transcript_history_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  bool _isListening = false;
  bool _permissionsGranted = false;
  String _currentCaption = '';
  String _simplifiedCaption = '';
  bool _showISLAnimation = false;
  String? _islAnimationPath;
  bool _soundAlertActive = false;
  String _soundAlertType = '';
  
  Settings _settings = Settings.defaultSettings();
  
  // Services
  final STTService _sttService = STTService();
  final AISimplificationService _aiService = AISimplificationService();
  final SoundClassificationService _soundService = SoundClassificationService();
  final OverlayService _overlayService = OverlayService();
  
  // Stream subscriptions
  StreamSubscription<String>? _sttResultSubscription;
  StreamSubscription<String>? _sttErrorSubscription;
  StreamSubscription<bool>? _sttStatusSubscription;
  StreamSubscription<SoundAlert>? _soundAlertSubscription;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadSettings();
    _checkPermissions();
    _initializeServices();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _loadSettings() async {
    final settings = DatabaseService.getSettings();
    setState(() {
      _settings = settings;
    });
  }

  Future<void> _initializeServices() async {
    try {
      await _sttService.initialize();
      await _soundService.initialize();
      await _overlayService.initialize();
      
      _setupStreamSubscriptions();
    } catch (e) {
      // Failed to initialize services
      debugPrint('Failed to initialize services: $e');
    }
  }

  void _setupStreamSubscriptions() {
    // STT result subscription
    _sttResultSubscription = _sttService.resultStream.listen((text) {
      if (text.isNotEmpty) {
        _processSpeechText(text);
      }
    });

    // STT error subscription
    _sttErrorSubscription = _sttService.errorStream.listen((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Speech recognition error: $error')),
        );
      }
    });

    // STT status subscription
    _sttStatusSubscription = _sttService.statusStream.listen((isListening) {
      setState(() {
        _isListening = isListening;
      });
    });

    // Sound alert subscription
    _soundAlertSubscription = _soundService.alertStream.listen((alert) {
      _triggerSoundAlert(alert.type);
    });
  }

  Future<void> _processSpeechText(String originalText) async {
    try {
      // Simplify the text using AI service
      final simplifiedText = await _aiService.simplifyText(originalText, _settings);
      
      // Check for ISL keywords
      final islKeywords = await _aiService.detectISLKeywords(originalText);
      String? islAnimationPath;
      
      if (islKeywords.isNotEmpty && _settings.enableISLAnimations) {
        islAnimationPath = await _aiService.getISLAnimationPath(islKeywords.first);
      }
      
      // Calculate confidence
      final confidence = await _aiService.calculateConfidence(originalText, simplifiedText);
      
      setState(() {
        _currentCaption = originalText;
        _simplifiedCaption = simplifiedText;
        _showISLAnimation = islKeywords.isNotEmpty && _settings.enableISLAnimations;
        _islAnimationPath = islAnimationPath;
      });

      // Save transcript if auto-save is enabled
      if (_settings.autoSaveTranscripts && confidence >= _settings.speechConfidenceThreshold) {
        final transcript = Transcript.create(
          originalText: originalText,
          simplifiedText: simplifiedText,
          language: _settings.primaryLanguage,
          confidence: confidence,
          hasISLAnimation: _showISLAnimation,
          islAnimationPath: islAnimationPath,
          tags: islKeywords,
        );
        
        await DatabaseService.saveTranscript(transcript);
      }

      // Update overlay if enabled
      if (_settings.enableSystemOverlay) {
        await _overlayService.updateOverlay(originalText, simplifiedText);
      }

      // Trigger vibration if enabled
      if (_settings.enableVibration && _settings.hapticFeedbackEnabled) {
        Vibration.vibrate(duration: 100);
      }
    } catch (e) {
      debugPrint('Failed to process speech text: $e');
    }
  }

  Future<void> _checkPermissions() async {
    final micGranted = await PermissionService.isMicrophonePermissionGranted();
    final overlayGranted = await PermissionService.isSystemOverlayPermissionGranted();
    
    setState(() {
      _permissionsGranted = micGranted && overlayGranted;
    });

    if (!_permissionsGranted) {
      _requestPermissions();
    }
  }

  Future<void> _requestPermissions() async {
    final granted = await PermissionService.requestAllPermissions();
    
    if (!granted) {
      _showPermissionDialog();
    } else {
      setState(() {
        _permissionsGranted = true;
      });
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Permissions Required'),
        content: Text(
          'SaralVani needs microphone and overlay permissions to work properly. '
          'Please grant these permissions in the app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              PermissionService.openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _toggleListening() {
    if (!_permissionsGranted) {
      _requestPermissions();
      return;
    }

    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      _startListening();
      _pulseController.repeat(reverse: true);
      _fadeController.forward();
      
      if (_settings.hapticFeedbackEnabled) {
        HapticFeedback.mediumImpact();
      }
    } else {
      _stopListening();
      _pulseController.stop();
      _fadeController.reverse();
      
      if (_settings.hapticFeedbackEnabled) {
        HapticFeedback.lightImpact();
      }
    }
  }

  void _startListening() async {
    if (!_permissionsGranted) {
      _requestPermissions();
      return;
    }

    try {
      await _sttService.startListening(settings: _settings);
      await _soundService.startListening(_settings);
      
      if (_settings.enableSystemOverlay) {
        await _overlayService.showOverlay(
          originalCaption: _currentCaption,
          simplifiedCaption: _simplifiedCaption,
          settings: _settings,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to start listening: $e')),
        );
      }
    }
  }

  void _stopListening() async {
    try {
      await _sttService.stopListening();
      await _soundService.stopListening();
      await _overlayService.hideOverlay();
    } catch (e) {
      debugPrint('Failed to stop listening: $e');
    }
  }

  void _simulateSpeechInput() {
    // Simulate speech input for demonstration
    final sampleTexts = [
      'Hello, how are you today?',
      'मैं आपसे मिलकर खुश हूं।',
      'The weather is very nice today.',
      'क्या आप मुझे मदद कर सकते हैं?',
      'Thank you for your help.',
    ];

    int index = 0;
    Timer.periodic(Duration(seconds: 3), (timer) {
      if (!_isListening) {
        timer.cancel();
        return;
      }

      if (index < sampleTexts.length) {
        setState(() {
          _currentCaption = sampleTexts[index];
          _simplifiedCaption = _simplifyText(sampleTexts[index]);
          _showISLAnimation = _shouldShowISLAnimation(sampleTexts[index]);
        });
        
        if (_settings.enableVibration) {
          Vibration.vibrate(duration: 100);
        }
        
        index++;
      } else {
        timer.cancel();
      }
    });
  }

  String _simplifyText(String text) {
    // TODO: Implement actual AI text simplification
    // This is a placeholder for the simplification service
    if (text.contains('Hello')) {
      return 'नमस्ते।';
    } else if (text.contains('weather')) {
      return 'आज मौसम अच्छा है।';
    } else if (text.contains('Thank you')) {
      return 'धन्यवाद।';
    } else if (text.contains('मदद')) {
      return 'मैं आपकी मदद करूंगा।';
    }
    return text;
  }

  bool _shouldShowISLAnimation(String text) {
    // TODO: Implement ISL animation detection logic
    final islKeywords = ['hello', 'thank', 'help', 'weather', 'नमस्ते', 'धन्यवाद', 'मदद'];
    return islKeywords.any((keyword) => text.toLowerCase().contains(keyword));
  }

  void _triggerSoundAlert(String alertType) {
    setState(() {
      _soundAlertActive = true;
      _soundAlertType = alertType;
    });

    if (_settings.enableVibration) {
      Vibration.vibrate(pattern: [0, 500, 200, 500]);
    }

    Timer(Duration(seconds: 3), () {
      setState(() {
        _soundAlertActive = false;
        _soundAlertType = '';
      });
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    
    // Dispose stream subscriptions
    _sttResultSubscription?.cancel();
    _sttErrorSubscription?.cancel();
    _sttStatusSubscription?.cancel();
    _soundAlertSubscription?.cancel();
    
    // Dispose services
    _sttService.dispose();
    _soundService.dispose();
    _overlayService.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('SaralVani'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TranscriptHistoryScreen()),
              );
            },
            tooltip: 'Transcript History',
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
              _loadSettings();
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Caption Display Area
              Expanded(
                flex: 3,
                child: CaptionDisplay(
                  originalText: _currentCaption,
                  simplifiedText: _simplifiedCaption,
                  isListening: _isListening,
                  settings: _settings,
                ),
              ),
              
              // ISL Avatar Area
              if (_showISLAnimation && _settings.enableISLAnimations)
                Expanded(
                  flex: 2,
                  child: ISLAvatarWidget(
                    animationPath: _islAnimationPath ?? 'assets/animations/hello.json',
                    isVisible: _showISLAnimation,
                  ),
                ),
              
              // Control Panel
              Expanded(
                flex: 1,
                child: ControlPanel(
                  isListening: _isListening,
                  onToggleListening: _toggleListening,
                  onSettingsPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                    _loadSettings();
                  },
                  settings: _settings,
                ),
              ),
            ],
          ),
          
          // Sound Alert Overlay
          if (_soundAlertActive)
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: SoundAlertIndicator(
                alertType: _soundAlertType,
                isVisible: _soundAlertActive,
              ),
            ),
          
          // Permission Request Overlay
          if (!_permissionsGranted)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.7),
                child: Center(
                  child: Card(
                    margin: EdgeInsets.all(20),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.mic_off,
                            size: 48,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Permissions Required',
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'SaralVani needs microphone and overlay permissions to provide real-time captions.',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _requestPermissions,
                            child: Text('Grant Permissions'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: _isListening
          ? AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: FloatingActionButton(
                    onPressed: _toggleListening,
                    backgroundColor: Theme.of(context).colorScheme.error,
                    child: Icon(Icons.stop),
                    tooltip: 'Stop Listening',
                  ),
                );
              },
            )
          : FloatingActionButton(
              onPressed: _toggleListening,
              backgroundColor: _permissionsGranted
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).disabledColor,
              child: Icon(Icons.mic),
              tooltip: 'Start Listening',
            ),
    );
  }
}
