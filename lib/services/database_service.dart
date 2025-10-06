import 'package:hive_flutter/hive_flutter.dart';
import '../models/transcript.dart';
import '../models/settings.dart';

class DatabaseService {
  static const String transcriptBoxName = 'transcripts';
  static const String settingsBoxName = 'settings';
  
  static Box<Transcript>? _transcriptBox;
  static Box<Settings>? _settingsBox;
  
  static Future<void> initialize() async {
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TranscriptAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(SettingsAdapter());
    }
    
    // Open boxes
    _transcriptBox = await Hive.openBox<Transcript>(transcriptBoxName);
    _settingsBox = await Hive.openBox<Settings>(settingsBoxName);
    
    // Initialize default settings if not exists
    if (_settingsBox!.isEmpty) {
      await saveSettings(Settings.defaultSettings());
    }
  }
  
  // Transcript operations
  static Future<void> saveTranscript(Transcript transcript) async {
    await _transcriptBox!.put(transcript.id, transcript);
  }
  
  static List<Transcript> getAllTranscripts() {
    return _transcriptBox!.values.toList();
  }
  
  static Transcript? getTranscript(String id) {
    return _transcriptBox!.get(id);
  }
  
  static Future<void> deleteTranscript(String id) async {
    await _transcriptBox!.delete(id);
  }
  
  static Future<void> clearAllTranscripts() async {
    await _transcriptBox!.clear();
  }
  
  // Settings operations
  static Future<void> saveSettings(Settings settings) async {
    await _settingsBox!.put('settings', settings);
  }
  
  static Settings getSettings() {
    return _settingsBox!.get('settings') ?? Settings.defaultSettings();
  }
  
  static Future<void> close() async {
    await _transcriptBox?.close();
    await _settingsBox?.close();
  }
}
