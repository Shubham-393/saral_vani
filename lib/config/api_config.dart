class ApiConfig {
  // OpenAI API Configuration
  static const String openaiApiKey = String.fromEnvironment('OPENAI_API_KEY');

  static const String openaiApiUrl = 'https://api.openai.com/v1/chat/completions';
  
  // Local AI Service Configuration
  static const String localSimplificationUrl = 'http://localhost:8000/simplify';
  static const String localISLServiceUrl = 'http://localhost:8000/isl';
  
  // Vosk Model Configuration
  static const String voskModelPath = 'assets/models/vosk-model';
  static const String voskHindiModelUrl = 'https://alphacephei.com/vosk/models/vosk-model-small-hi-0.22.zip';
  static const String voskEnglishModelUrl = 'https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip';
  
  // ISL Animation Assets
  static const String islAnimationBasePath = 'assets/animations/';
  
  // Sound Classification Configuration
  static const Map<String, String> soundModelPaths = {
    'doorbell': 'assets/models/doorbell_model.tflite',
    'alarm': 'assets/models/alarm_model.tflite',
    'phone': 'assets/models/phone_model.tflite',
    'notification': 'assets/models/notification_model.tflite',
  };
  
  // Default Settings
  static const Map<String, dynamic> defaultSettings = {
    'primaryLanguage': 'hi',
    'secondaryLanguage': 'en',
    'textSize': 1.0,
    'captionOpacity': 0.9,
    'speechConfidenceThreshold': 0.7,
    'maxTranscriptHistory': 100,
  };
  
  // ISL Keyword Mappings
  static const Map<String, String> islKeywordMap = {
    'hello': 'assets/animations/hello.json',
    'नमस्ते': 'assets/animations/namaste.json',
    'thank': 'assets/animations/thank_you.json',
    'धन्यवाद': 'assets/animations/dhanyawad.json',
    'help': 'assets/animations/help.json',
    'मदद': 'assets/animations/madad.json',
    'water': 'assets/animations/water.json',
    'पानी': 'assets/animations/pani.json',
    'food': 'assets/animations/food.json',
    'भोजन': 'assets/animations/bhojan.json',
    'yes': 'assets/animations/yes.json',
    'हां': 'assets/animations/haan.json',
    'no': 'assets/animations/no.json',
    'नहीं': 'assets/animations/nahi.json',
    'please': 'assets/animations/please.json',
    'कृपया': 'assets/animations/kripya.json',
    'sorry': 'assets/animations/sorry.json',
    'क्षमा करें': 'assets/animations/kshama.json',
    'excuse': 'assets/animations/excuse.json',
    'माफ करें': 'assets/animations/maaf.json',
    'emergency': 'assets/animations/emergency.json',
    'आपातकाल': 'assets/animations/aapatkal.json',
    'doctor': 'assets/animations/doctor.json',
    'डॉक्टर': 'assets/animations/daktar.json',
    'hospital': 'assets/animations/hospital.json',
    'अस्पताल': 'assets/animations/aspatal.json',
    'medicine': 'assets/animations/medicine.json',
    'दवा': 'assets/animations/dava.json',
    'danger': 'assets/animations/danger.json',
    'खतरा': 'assets/animations/khatra.json',
    'safe': 'assets/animations/safe.json',
    'सुरक्षित': 'assets/animations/surakshit.json',
    'weather': 'assets/animations/weather.json',
    'मौसम': 'assets/animations/mausam.json',
    'hot': 'assets/animations/hot.json',
    'गर्म': 'assets/animations/garam.json',
    'cold': 'assets/animations/cold.json',
    'ठंडा': 'assets/animations/thanda.json',
    'rain': 'assets/animations/rain.json',
    'बारिश': 'assets/animations/barish.json',
    'sunny': 'assets/animations/sunny.json',
    'धूप': 'assets/animations/dhoop.json',
    'time': 'assets/animations/time.json',
    'समय': 'assets/animations/samay.json',
    'today': 'assets/animations/today.json',
    'आज': 'assets/animations/aaj.json',
    'tomorrow': 'assets/animations/tomorrow.json',
    'कल': 'assets/animations/kal.json',
    'yesterday': 'assets/animations/yesterday.json',
    'बीता हुआ कल': 'assets/animations/bita_hua_kal.json',
  };
  
  // Language Support
  static const Map<String, String> languageNames = {
    'hi': 'हिंदी',
    'en': 'English',
    'bn': 'বাংলা',
    'ta': 'தமிழ்',
    'te': 'తెలుగు',
    'mr': 'मराठी',
    'gu': 'ગુજરાતી',
    'kn': 'ಕನ್ನಡ',
    'ml': 'മലയാളം',
    'pa': 'ਪੰਜਾਬੀ',
    'or': 'ଓଡ଼ିଆ',
    'as': 'অসমীয়া',
  };
  
  // Text Simplification Rules
  static const Map<String, String> simplificationRules = {
    // English to Hindi simplifications
    'hello': 'नमस्ते',
    'how are you': 'आप कैसे हैं',
    'thank you': 'धन्यवाद',
    'good morning': 'सुप्रभात',
    'good evening': 'शुभ संध्या',
    'excuse me': 'माफ करें',
    'sorry': 'क्षमा करें',
    'please': 'कृपया',
    'yes': 'हां',
    'no': 'नहीं',
    'help': 'मदद',
    'water': 'पानी',
    'food': 'भोजन',
    'medicine': 'दवा',
    'hospital': 'अस्पताल',
    'doctor': 'डॉक्टर',
    'emergency': 'आपातकाल',
    'danger': 'खतरा',
    'safe': 'सुरक्षित',
    'weather': 'मौसम',
    'hot': 'गर्म',
    'cold': 'ठंडा',
    'rain': 'बारिश',
    'sunny': 'धूप',
    'time': 'समय',
    'today': 'आज',
    'tomorrow': 'कल',
    'yesterday': 'बीता हुआ कल',
    
    // Complex to simple transformations
    'how do you do': 'आप कैसे हैं',
    'nice to meet you': 'आपसे मिलकर खुशी हुई',
    'have a good day': 'अच्छा दिन बिताएं',
    'take care': 'ध्यान रखें',
    'see you later': 'बाद में मिलते हैं',
    'good night': 'शुभ रात्रि',
    'welcome': 'स्वागत है',
    'congratulations': 'बधाई हो',
    'happy birthday': 'जन्मदिन मुबारक',
    'happy new year': 'नया साल मुबारक',
  };
  
  // Vibration Patterns for Different Alerts
  static const Map<String, List<int>> vibrationPatterns = {
    'doorbell': [0, 200, 100, 200, 100, 200],
    'alarm': [0, 500, 100, 500, 100, 500, 100, 500],
    'phone': [0, 300, 100, 300, 100, 300],
    'notification': [0, 200],
    'speech_detected': [0, 100],
    'error': [0, 100, 50, 100, 50, 100],
  };
  
  // Accessibility Configuration
  static const Map<String, dynamic> accessibilityConfig = {
    'minTouchTargetSize': 48.0,
    'maxTextScaleFactor': 1.5,
    'minTextScaleFactor': 1.0,
    'highContrastThreshold': 4.5,
    'animationDuration': 300,
    'hapticFeedbackEnabled': true,
    'screenReaderSupport': true,
  };
}
