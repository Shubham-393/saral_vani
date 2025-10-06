import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/settings.dart';

class AISimplificationService {
  static final AISimplificationService _instance = AISimplificationService._internal();
  factory AISimplificationService() => _instance;
  AISimplificationService._internal();

  // Placeholder API configuration - replace with actual API endpoints
  static const String _openaiApiKey = 'sk-your-openai-key-here';
  static const String _openaiApiUrl = 'https://api.openai.com/v1/chat/completions';
  static const String _localSimplificationUrl = 'http://localhost:8000/simplify';

  Future<String> simplifyText(String originalText, Settings settings) async {
    try {
      // First try local simplification service
      final localResult = await _simplifyLocally(originalText, settings);
      if (localResult != null) {
        return localResult;
      }

      // Fallback to OpenAI API
      return await _simplifyWithOpenAI(originalText, settings);
    } catch (e) {
      // Fallback to rule-based simplification
      return _simplifyWithRules(originalText, settings);
    }
  }

  Future<String?> _simplifyLocally(String text, Settings settings) async {
    try {
      final response = await http.post(
        Uri.parse(_localSimplificationUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'text': text,
          'source_language': settings.primaryLanguage,
          'target_language': settings.secondaryLanguage,
          'simplification_level': 'high',
        }),
      ).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['simplified_text'] as String?;
      }
    } catch (e) {
      // Local service not available, continue to next method
    }
    return null;
  }

  Future<String> _simplifyWithOpenAI(String text, Settings settings) async {
    if (_openaiApiKey == 'sk-your-openai-key-here') {
      throw Exception('OpenAI API key not configured');
    }

    final prompt = _buildSimplificationPrompt(text, settings);
    
    final response = await http.post(
      Uri.parse(_openaiApiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_openaiApiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'system',
            'content': 'You are an AI assistant that simplifies complex text for hearing-impaired users. Make text clear, simple, and easy to understand.',
          },
          {
            'role': 'user',
            'content': prompt,
          }
        ],
        'max_tokens': 150,
        'temperature': 0.3,
      }),
    ).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      throw Exception('OpenAI API error: ${response.statusCode}');
    }
  }

  String _buildSimplificationPrompt(String text, Settings settings) {
    final sourceLang = _getLanguageName(settings.primaryLanguage);
    final targetLang = _getLanguageName(settings.secondaryLanguage);
    
    return '''
Simplify the following text for hearing-impaired users:

Original text ($sourceLang): "$text"

Requirements:
1. Use simple, clear language
2. Break down complex sentences
3. Use common words
4. Keep the meaning intact
5. If the original is in $sourceLang, provide simplified version in $targetLang
6. Make it accessible and easy to understand

Simplified text:''';
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'hi':
        return 'Hindi';
      case 'en':
        return 'English';
      case 'bn':
        return 'Bengali';
      case 'ta':
        return 'Tamil';
      case 'te':
        return 'Telugu';
      case 'mr':
        return 'Marathi';
      default:
        return 'Hindi';
    }
  }

  String _simplifyWithRules(String text, Settings settings) {
    // Rule-based simplification as fallback
    String simplified = text;
    
    // Common phrase simplifications
    final simplifications = {
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
    };

    // Apply simplifications
    simplifications.forEach((english, hindi) {
      simplified = simplified.replaceAll(RegExp(english, caseSensitive: false), hindi);
    });

    // Simplify punctuation
    simplified = simplified.replaceAll('!', '।');
    simplified = simplified.replaceAll('?', '?');
    
    // Remove extra spaces
    simplified = simplified.replaceAll(RegExp(r'\s+'), ' ').trim();

    return simplified.isEmpty ? text : simplified;
  }

  Future<List<String>> detectISLKeywords(String text) async {
    // Keywords that should trigger ISL animations
    final islKeywords = [
      'hello', 'नमस्ते', 'hi',
      'thank', 'धन्यवाद', 'thanks',
      'help', 'मदद', 'assist',
      'water', 'पानी',
      'food', 'भोजन', 'khana',
      'medicine', 'दवा',
      'doctor', 'डॉक्टर',
      'emergency', 'आपातकाल',
      'danger', 'खतरा',
      'safe', 'सुरक्षित',
      'yes', 'हां',
      'no', 'नहीं',
      'please', 'कृपया',
      'sorry', 'क्षमा करें',
      'excuse', 'माफ करें',
    ];

    final detectedKeywords = <String>[];
    final lowerText = text.toLowerCase();

    for (final keyword in islKeywords) {
      if (lowerText.contains(keyword.toLowerCase())) {
        detectedKeywords.add(keyword);
      }
    }

    return detectedKeywords;
  }

  Future<String?> getISLAnimationPath(String keyword) async {
    // Map keywords to ISL animation file paths
    final animationMap = {
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
    };

    return animationMap[keyword.toLowerCase()];
  }

  Future<double> calculateConfidence(String originalText, String simplifiedText) async {
    // Simple confidence calculation based on text similarity and simplification rules
    if (originalText.isEmpty || simplifiedText.isEmpty) {
      return 0.0;
    }

    // Basic checks
    double confidence = 0.5; // Base confidence

    // Check if simplified text is shorter (usually a good sign)
    if (simplifiedText.length < originalText.length) {
      confidence += 0.2;
    }

    // Check if common words are present
    final commonWords = ['हां', 'नहीं', 'धन्यवाद', 'नमस्ते', 'मदद', 'पानी', 'भोजन'];
    for (final word in commonWords) {
      if (simplifiedText.contains(word)) {
        confidence += 0.1;
        break;
      }
    }

    // Ensure confidence is between 0 and 1
    return confidence.clamp(0.0, 1.0);
  }
}
