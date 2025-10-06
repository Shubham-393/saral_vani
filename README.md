# SaralVani - Real-time Simplified Captions for Hearing-Impaired

SaralVani (Simple Voice) is a Flutter-based mobile application designed to provide real-time simplified captions for India's 63 million hearing-impaired individuals. The app converts complex speech into simple, accessible language and integrates Indian Sign Language (ISL) animations.

## 🎯 Key Features

### P0 - Core Features
- **Offline Speech-to-Text**: Hindi/English support with Vosk engine
- **AI Text Simplification**: Complex sentences → Simple language
- **High-Contrast Mobile UI**: WCAG compliant with large text
- **System Overlay**: Captions over any app (YouTube, WhatsApp)

### P1 - Advanced Features
- **ISL Avatar Integration**: Animated sign language for key phrases
- **Smart Sound Alerts**: Visual/vibration for doorbell, alarms, notifications
- **Transcript Management**: Save/share conversation history
- **Multi-language Support**: Hindi, English, Bengali, Tamil, Telugu, Marathi

## 🛠 Tech Stack

- **Frontend**: Flutter (Dart)
- **STT Engine**: Speech-to-Text (Flutter) + Vosk (Offline)
- **AI Models**: OpenAI GPT-3.5 + Local simplification service
- **Database**: Hive (Local storage)
- **Animations**: Lottie for ISL avatars
- **Accessibility**: WCAG 2.1 AA compliant

## 📱 Installation & Setup

### Prerequisites
- Flutter SDK (>=3.0.0)
- Android Studio / VS Code
- Android device/emulator (API level 21+)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd saral_vani
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate model adapters**
   ```bash
   dart run build_runner build
   ```

4. **Configure API keys**
   - Edit `lib/config/api_config.dart`
   - Add your OpenAI API key (optional)
   - Configure local AI service URLs (if available)

5. **Run the app**
   ```bash
   flutter run
   ```

## 🔧 Configuration

### API Configuration
Edit `lib/config/api_config.dart` to configure:

```dart
class ApiConfig {
  static const String openaiApiKey = 'sk-your-openai-key-here';
  static const String localSimplificationUrl = 'http://localhost:8000/simplify';
  // ... other configurations
}
```

### Permissions Required
The app requires the following Android permissions:
- `RECORD_AUDIO`: For speech recognition
- `SYSTEM_ALERT_WINDOW`: For overlay captions
- `VIBRATE`: For haptic feedback
- `INTERNET`: For AI services (optional)

### Assets Setup
Place the following assets in the specified directories:

```
assets/
├── animations/          # ISL Lottie animations
│   ├── hello.json
│   ├── namaste.json
│   └── ...
├── models/             # AI model files
│   ├── vosk-model/
│   └── sound-classification/
└── fonts/              # Custom fonts
    ├── NotoSans-Regular.ttf
    └── NotoSans-Bold.ttf
```

## 🎨 Accessibility Features

### WCAG 2.1 AA Compliance
- **Color Contrast**: Minimum 4.5:1 ratio
- **Touch Targets**: Minimum 48px size
- **Text Scaling**: Up to 150% support
- **Screen Reader**: Full TalkBack support

### Visual Accessibility
- High contrast mode
- Large text support
- Simplified UI design
- Clear visual feedback

### Haptic Feedback
- Vibration patterns for different alerts
- Customizable haptic intensity
- Context-aware feedback

## 🔄 App Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Microphone    │───▶│  STT Service    │───▶│ Simplification  │
│   Input         │    │  (Vosk/Flutter) │    │    Engine       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                        │
                       ┌─────────────────┐              ▼
                       │   ISL Avatar    │◀───┌─────────────────┐
                       │   Manager       │    │  Caption        │
                       └─────────────────┘    │  Display        │
                                              └─────────────────┘
                                                       │
                       ┌─────────────────┐              ▼
                       │ Sound           │◀───┌─────────────────┐
                       │ Classification  │    │ System Overlay  │
                       └─────────────────┘    └─────────────────┘
```

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Accessibility Testing
- Test with TalkBack enabled
- Verify color contrast ratios
- Test touch target sizes
- Validate keyboard navigation

## 📊 Performance Metrics

### Success Criteria
- [ ] **Offline STT**: Works without internet
- [ ] **Simplification**: Complex → Simple conversion visible
- [ ] **ISL Avatars**: Trigger on keyword detection
- [ ] **High Contrast UI**: WCAG compliant
- [ ] **System Overlay**: Works on other apps
- [ ] **Response Time**: <2 seconds for speech processing
- [ ] **Accuracy**: >85% speech recognition accuracy

## 🚀 Deployment

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### Play Store Requirements
- Target SDK: 34 (Android 14)
- Minimum SDK: 21 (Android 5.0)
- App size: <100MB
- Permissions: Clearly documented

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure accessibility compliance
6. Submit a pull request

### Code Style
- Follow Dart/Flutter conventions
- Use meaningful variable names
- Add comments for complex logic
- Maintain 80%+ test coverage

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Vosk**: Offline speech recognition
- **OpenAI**: Text simplification API
- **Lottie**: Animation framework
- **Flutter**: Cross-platform framework
- **Indian Sign Language Community**: ISL animations and guidance

## 📞 Support

For support, feature requests, or bug reports:
- Create an issue on GitHub
- Email: support@saralvani.app
- Documentation: [docs.saralvani.app](https://docs.saralvani.app)

## 🔮 Roadmap

### Version 1.1
- [ ] Offline AI models
- [ ] More ISL animations
- [ ] Voice commands
- [ ] Cloud sync

### Version 1.2
- [ ] iOS support
- [ ] Advanced sound classification
- [ ] Custom ISL animations
- [ ] Multi-user profiles

### Version 2.0
- [ ] Real-time translation
- [ ] AR/VR integration
- [ ] Smart home integration
- [ ] Community features

---

**Made with ❤️ for India's hearing-impaired community**