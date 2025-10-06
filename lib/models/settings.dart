import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 1)
class Settings extends HiveObject {
  @HiveField(0)
  final bool isDarkMode;
  
  @HiveField(1)
  final String primaryLanguage;
  
  @HiveField(2)
  final String secondaryLanguage;
  
  @HiveField(3)
  final double textSize;
  
  @HiveField(4)
  final double captionOpacity;
  
  @HiveField(5)
  final bool enableVibration;
  
  @HiveField(6)
  final bool enableISLAnimations;
  
  @HiveField(7)
  final bool enableSoundAlerts;
  
  @HiveField(8)
  final bool enableSystemOverlay;
  
  @HiveField(9)
  final bool autoSaveTranscripts;
  
  @HiveField(10)
  final int maxTranscriptHistory;
  
  @HiveField(11)
  final bool highContrastMode;
  
  @HiveField(12)
  final bool screenReaderEnabled;
  
  @HiveField(13)
  final bool hapticFeedbackEnabled;
  
  @HiveField(14)
  final double speechConfidenceThreshold;

  Settings({
    required this.isDarkMode,
    required this.primaryLanguage,
    required this.secondaryLanguage,
    required this.textSize,
    required this.captionOpacity,
    required this.enableVibration,
    required this.enableISLAnimations,
    required this.enableSoundAlerts,
    required this.enableSystemOverlay,
    required this.autoSaveTranscripts,
    required this.maxTranscriptHistory,
    required this.highContrastMode,
    required this.screenReaderEnabled,
    required this.hapticFeedbackEnabled,
    required this.speechConfidenceThreshold,
  });

  factory Settings.defaultSettings() {
    return Settings(
      isDarkMode: false,
      primaryLanguage: 'hi', // Hindi
      secondaryLanguage: 'en', // English
      textSize: 1.0,
      captionOpacity: 0.9,
      enableVibration: true,
      enableISLAnimations: true,
      enableSoundAlerts: true,
      enableSystemOverlay: true,
      autoSaveTranscripts: true,
      maxTranscriptHistory: 100,
      highContrastMode: true,
      screenReaderEnabled: true,
      hapticFeedbackEnabled: true,
      speechConfidenceThreshold: 0.7,
    );
  }

  Settings copyWith({
    bool? isDarkMode,
    String? primaryLanguage,
    String? secondaryLanguage,
    double? textSize,
    double? captionOpacity,
    bool? enableVibration,
    bool? enableISLAnimations,
    bool? enableSoundAlerts,
    bool? enableSystemOverlay,
    bool? autoSaveTranscripts,
    int? maxTranscriptHistory,
    bool? highContrastMode,
    bool? screenReaderEnabled,
    bool? hapticFeedbackEnabled,
    double? speechConfidenceThreshold,
  }) {
    return Settings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      primaryLanguage: primaryLanguage ?? this.primaryLanguage,
      secondaryLanguage: secondaryLanguage ?? this.secondaryLanguage,
      textSize: textSize ?? this.textSize,
      captionOpacity: captionOpacity ?? this.captionOpacity,
      enableVibration: enableVibration ?? this.enableVibration,
      enableISLAnimations: enableISLAnimations ?? this.enableISLAnimations,
      enableSoundAlerts: enableSoundAlerts ?? this.enableSoundAlerts,
      enableSystemOverlay: enableSystemOverlay ?? this.enableSystemOverlay,
      autoSaveTranscripts: autoSaveTranscripts ?? this.autoSaveTranscripts,
      maxTranscriptHistory: maxTranscriptHistory ?? this.maxTranscriptHistory,
      highContrastMode: highContrastMode ?? this.highContrastMode,
      screenReaderEnabled: screenReaderEnabled ?? this.screenReaderEnabled,
      hapticFeedbackEnabled: hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      speechConfidenceThreshold: speechConfidenceThreshold ?? this.speechConfidenceThreshold,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'primaryLanguage': primaryLanguage,
      'secondaryLanguage': secondaryLanguage,
      'textSize': textSize,
      'captionOpacity': captionOpacity,
      'enableVibration': enableVibration,
      'enableISLAnimations': enableISLAnimations,
      'enableSoundAlerts': enableSoundAlerts,
      'enableSystemOverlay': enableSystemOverlay,
      'autoSaveTranscripts': autoSaveTranscripts,
      'maxTranscriptHistory': maxTranscriptHistory,
      'highContrastMode': highContrastMode,
      'screenReaderEnabled': screenReaderEnabled,
      'hapticFeedbackEnabled': hapticFeedbackEnabled,
      'speechConfidenceThreshold': speechConfidenceThreshold,
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      isDarkMode: json['isDarkMode'] ?? false,
      primaryLanguage: json['primaryLanguage'] ?? 'hi',
      secondaryLanguage: json['secondaryLanguage'] ?? 'en',
      textSize: json['textSize']?.toDouble() ?? 1.0,
      captionOpacity: json['captionOpacity']?.toDouble() ?? 0.9,
      enableVibration: json['enableVibration'] ?? true,
      enableISLAnimations: json['enableISLAnimations'] ?? true,
      enableSoundAlerts: json['enableSoundAlerts'] ?? true,
      enableSystemOverlay: json['enableSystemOverlay'] ?? true,
      autoSaveTranscripts: json['autoSaveTranscripts'] ?? true,
      maxTranscriptHistory: json['maxTranscriptHistory'] ?? 100,
      highContrastMode: json['highContrastMode'] ?? true,
      screenReaderEnabled: json['screenReaderEnabled'] ?? true,
      hapticFeedbackEnabled: json['hapticFeedbackEnabled'] ?? true,
      speechConfidenceThreshold: json['speechConfidenceThreshold']?.toDouble() ?? 0.7,
    );
  }
}
