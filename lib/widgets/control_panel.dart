import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/settings.dart';

class ControlPanel extends StatefulWidget {
  final bool isListening;
  final VoidCallback onToggleListening;
  final VoidCallback onSettingsPressed;
  final Settings settings;

  const ControlPanel({
    Key? key,
    required this.isListening,
    required this.onToggleListening,
    required this.onSettingsPressed,
    required this.settings,
  }) : super(key: key);

  @override
  _ControlPanelState createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel>
    with TickerProviderStateMixin {
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _buttonAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  void _handleButtonPress(VoidCallback onPressed) {
    _buttonAnimationController.forward().then((_) {
      _buttonAnimationController.reverse();
    });
    
    if (widget.settings.hapticFeedbackEnabled) {
      HapticFeedback.lightImpact();
    }
    
    onPressed();
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quick Settings Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickSettingButton(
                icon: Icons.volume_up,
                label: 'Volume',
                isActive: widget.settings.enableSoundAlerts,
                onTap: () {
                  // TODO: Toggle sound alerts
                },
              ),
              _buildQuickSettingButton(
                icon: Icons.vibration,
                label: 'Vibration',
                isActive: widget.settings.enableVibration,
                onTap: () {
                  // TODO: Toggle vibration
                },
              ),
              _buildQuickSettingButton(
                icon: Icons.accessibility,
                label: 'ISL',
                isActive: widget.settings.enableISLAnimations,
                onTap: () {
                  // TODO: Toggle ISL animations
                },
              ),
              _buildQuickSettingButton(
                icon: Icons.layers,
                label: 'Overlay',
                isActive: widget.settings.enableSystemOverlay,
                onTap: () {
                  // TODO: Toggle system overlay
                },
              ),
            ],
          ),
          
          SizedBox(height: 20),
          
          // Main Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Settings Button
              AnimatedBuilder(
                animation: _buttonScaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _buttonScaleAnimation.value,
                    child: ElevatedButton.icon(
                      onPressed: () => _handleButtonPress(widget.onSettingsPressed),
                      icon: Icon(Icons.settings),
                      label: Text('Settings'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        minimumSize: Size(120, 48),
                      ),
                    ),
                  );
                },
              ),
              
              // Main Listen/Stop Button
              AnimatedBuilder(
                animation: _buttonScaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _buttonScaleAnimation.value,
                    child: ElevatedButton.icon(
                      onPressed: () => _handleButtonPress(widget.onToggleListening),
                      icon: Icon(widget.isListening ? Icons.stop : Icons.mic),
                      label: Text(widget.isListening ? 'Stop' : 'Listen'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.isListening
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        minimumSize: Size(140, 56),
                        elevation: 8,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          
          SizedBox(height: 16),
          
          // Status Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatusIndicator(
                icon: Icons.mic,
                label: 'Microphone',
                isActive: true, // TODO: Check actual mic status
              ),
              _buildStatusIndicator(
                icon: Icons.wifi,
                label: 'Network',
                isActive: true, // TODO: Check network status
              ),
              _buildStatusIndicator(
                icon: Icons.battery_full,
                label: 'Battery',
                isActive: true, // TODO: Check battery status
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSettingButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () => _handleButtonPress(onTap),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isActive
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
            ),
          ),
          child: Icon(
            icon,
            color: isActive
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface,
            size: 20,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
