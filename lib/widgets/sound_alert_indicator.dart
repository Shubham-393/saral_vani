import 'package:flutter/material.dart';

class SoundAlertIndicator extends StatefulWidget {
  final String alertType;
  final bool isVisible;

  const SoundAlertIndicator({
    Key? key,
    required this.alertType,
    required this.isVisible,
  }) : super(key: key);

  @override
  _SoundAlertIndicatorState createState() => _SoundAlertIndicatorState();
}

class _SoundAlertIndicatorState extends State<SoundAlertIndicator>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _slideController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(SoundAlertIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isVisible && !oldWidget.isVisible) {
      _slideController.forward();
      _pulseController.repeat(reverse: true);
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _slideController.reverse();
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return SizedBox.shrink();

    return SlideTransition(
      position: _slideAnimation,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: _getAlertColor(),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: _getAlertColor().withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getAlertIcon(),
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getAlertTitle(),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _getAlertMessage(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      // TODO: Dismiss alert
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getAlertColor() {
    switch (widget.alertType.toLowerCase()) {
      case 'doorbell':
        return Colors.orange;
      case 'alarm':
        return Colors.red;
      case 'phone':
        return Colors.green;
      case 'notification':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getAlertIcon() {
    switch (widget.alertType.toLowerCase()) {
      case 'doorbell':
        return Icons.doorbell;
      case 'alarm':
        return Icons.alarm;
      case 'phone':
        return Icons.phone;
      case 'notification':
        return Icons.notifications;
      default:
        return Icons.volume_up;
    }
  }

  String _getAlertTitle() {
    switch (widget.alertType.toLowerCase()) {
      case 'doorbell':
        return 'Doorbell Ringing';
      case 'alarm':
        return 'Alarm Sound';
      case 'phone':
        return 'Incoming Call';
      case 'notification':
        return 'Notification';
      default:
        return 'Sound Alert';
    }
  }

  String _getAlertMessage() {
    switch (widget.alertType.toLowerCase()) {
      case 'doorbell':
        return 'Someone is at the door';
      case 'alarm':
        return 'Alarm is going off';
      case 'phone':
        return 'Your phone is ringing';
      case 'notification':
        return 'You have a new notification';
      default:
        return 'Important sound detected';
    }
  }
}
