import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/settings.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Settings _settings;

  @override
  void initState() {
    super.initState();
    _settings = DatabaseService.getSettings();
  }

  Future<void> _saveSettings() async {
    await DatabaseService.saveSettings(_settings);
  }

  void _updateSettings(Settings newSettings) {
    setState(() {
      _settings = newSettings;
    });
    _saveSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _settings = DatabaseService.getSettings();
              });
            },
            tooltip: 'Reset to Defaults',
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Appearance Section
          _buildSectionHeader('Appearance'),
          _buildSwitchTile(
            title: 'Dark Mode',
            subtitle: 'Switch between light and dark theme',
            value: _settings.isDarkMode,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(isDarkMode: value));
            },
            icon: Icons.dark_mode,
          ),
          _buildSwitchTile(
            title: 'High Contrast Mode',
            subtitle: 'Enhanced contrast for better visibility',
            value: _settings.highContrastMode,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(highContrastMode: value));
            },
            icon: Icons.contrast,
          ),
          _buildSliderTile(
            title: 'Text Size',
            subtitle: 'Adjust caption text size',
            value: _settings.textSize,
            min: 0.8,
            max: 1.5,
            divisions: 7,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(textSize: value));
            },
            icon: Icons.text_fields,
          ),
          _buildSliderTile(
            title: 'Caption Opacity',
            subtitle: 'Adjust caption background opacity',
            value: _settings.captionOpacity,
            min: 0.5,
            max: 1.0,
            divisions: 5,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(captionOpacity: value));
            },
            icon: Icons.opacity,
          ),
          
          SizedBox(height: 20),
          
          // Language Settings
          _buildSectionHeader('Language'),
          _buildDropdownTile(
            title: 'Primary Language',
            subtitle: 'Main language for speech recognition',
            value: _settings.primaryLanguage,
            items: [
              DropdownMenuItem(value: 'hi', child: Text('हिंदी (Hindi)')),
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'bn', child: Text('বাংলা (Bengali)')),
              DropdownMenuItem(value: 'ta', child: Text('தமிழ் (Tamil)')),
              DropdownMenuItem(value: 'te', child: Text('తెలుగు (Telugu)')),
              DropdownMenuItem(value: 'mr', child: Text('मराठी (Marathi)')),
            ],
            onChanged: (value) {
              _updateSettings(_settings.copyWith(primaryLanguage: value!));
            },
            icon: Icons.language,
          ),
          _buildDropdownTile(
            title: 'Secondary Language',
            subtitle: 'Secondary language for translation',
            value: _settings.secondaryLanguage,
            items: [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'hi', child: Text('हिंदी (Hindi)')),
              DropdownMenuItem(value: 'bn', child: Text('বাংলা (Bengali)')),
              DropdownMenuItem(value: 'ta', child: Text('தமிழ் (Tamil)')),
              DropdownMenuItem(value: 'te', child: Text('తెలుగు (Telugu)')),
              DropdownMenuItem(value: 'mr', child: Text('मराठी (Marathi)')),
            ],
            onChanged: (value) {
              _updateSettings(_settings.copyWith(secondaryLanguage: value!));
            },
            icon: Icons.translate,
          ),
          
          SizedBox(height: 20),
          
          // Accessibility Features
          _buildSectionHeader('Accessibility'),
          _buildSwitchTile(
            title: 'Vibration Alerts',
            subtitle: 'Vibrate for important sounds and events',
            value: _settings.enableVibration,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(enableVibration: value));
            },
            icon: Icons.vibration,
          ),
          _buildSwitchTile(
            title: 'ISL Animations',
            subtitle: 'Show Indian Sign Language animations',
            value: _settings.enableISLAnimations,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(enableISLAnimations: value));
            },
            icon: Icons.accessibility_new,
          ),
          _buildSwitchTile(
            title: 'Sound Alerts',
            subtitle: 'Alert for doorbell, alarms, and notifications',
            value: _settings.enableSoundAlerts,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(enableSoundAlerts: value));
            },
            icon: Icons.volume_up,
          ),
          _buildSwitchTile(
            title: 'Haptic Feedback',
            subtitle: 'Provide tactile feedback for interactions',
            value: _settings.hapticFeedbackEnabled,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(hapticFeedbackEnabled: value));
            },
            icon: Icons.touch_app,
          ),
          _buildSwitchTile(
            title: 'Screen Reader Support',
            subtitle: 'Optimize for screen readers',
            value: _settings.screenReaderEnabled,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(screenReaderEnabled: value));
            },
            icon: Icons.accessibility,
          ),
          
          SizedBox(height: 20),
          
          // Advanced Settings
          _buildSectionHeader('Advanced'),
          _buildSwitchTile(
            title: 'System Overlay',
            subtitle: 'Show captions over other apps',
            value: _settings.enableSystemOverlay,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(enableSystemOverlay: value));
            },
            icon: Icons.layers,
          ),
          _buildSwitchTile(
            title: 'Auto-save Transcripts',
            subtitle: 'Automatically save conversation history',
            value: _settings.autoSaveTranscripts,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(autoSaveTranscripts: value));
            },
            icon: Icons.save,
          ),
          _buildSliderTile(
            title: 'Speech Confidence Threshold',
            subtitle: 'Minimum confidence for speech recognition',
            value: _settings.speechConfidenceThreshold,
            min: 0.5,
            max: 1.0,
            divisions: 10,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(speechConfidenceThreshold: value));
            },
            icon: Icons.record_voice_over,
          ),
          _buildSliderTile(
            title: 'Max Transcript History',
            subtitle: 'Maximum number of saved transcripts',
            value: _settings.maxTranscriptHistory.toDouble(),
            min: 10,
            max: 500,
            divisions: 49,
            onChanged: (value) {
              _updateSettings(_settings.copyWith(maxTranscriptHistory: value.toInt()));
            },
            icon: Icons.history,
          ),
          
          SizedBox(height: 20),
          
          // Reset Section
          _buildSectionHeader('Reset'),
          ListTile(
            leading: Icon(Icons.restore, color: Colors.red),
            title: Text('Reset to Defaults'),
            subtitle: Text('Restore all settings to default values'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              _showResetDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Card(
      child: SwitchListTile(
        secondary: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSliderTile({
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required IconData icon,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ],
        ),
        trailing: Text(
          '${(value * 100).round()}%',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          items: items,
        ),
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Settings'),
        content: Text('Are you sure you want to reset all settings to default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateSettings(Settings.defaultSettings());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }
}
