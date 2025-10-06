import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'transcript.g.dart';

@HiveType(typeId: 0)
class Transcript extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String originalText;
  
  @HiveField(2)
  final String simplifiedText;
  
  @HiveField(3)
  final DateTime timestamp;
  
  @HiveField(4)
  final String language;
  
  @HiveField(5)
  final double confidence;
  
  @HiveField(6)
  final bool hasISLAnimation;
  
  @HiveField(7)
  final String? islAnimationPath;
  
  @HiveField(8)
  final List<String> tags;

  Transcript({
    required this.id,
    required this.originalText,
    required this.simplifiedText,
    required this.timestamp,
    required this.language,
    required this.confidence,
    this.hasISLAnimation = false,
    this.islAnimationPath,
    this.tags = const [],
  });

  factory Transcript.create({
    required String originalText,
    required String simplifiedText,
    required String language,
    required double confidence,
    bool hasISLAnimation = false,
    String? islAnimationPath,
    List<String> tags = const [],
  }) {
    return Transcript(
      id: const Uuid().v4(),
      originalText: originalText,
      simplifiedText: simplifiedText,
      timestamp: DateTime.now(),
      language: language,
      confidence: confidence,
      hasISLAnimation: hasISLAnimation,
      islAnimationPath: islAnimationPath,
      tags: tags,
    );
  }

  Transcript copyWith({
    String? id,
    String? originalText,
    String? simplifiedText,
    DateTime? timestamp,
    String? language,
    double? confidence,
    bool? hasISLAnimation,
    String? islAnimationPath,
    List<String>? tags,
  }) {
    return Transcript(
      id: id ?? this.id,
      originalText: originalText ?? this.originalText,
      simplifiedText: simplifiedText ?? this.simplifiedText,
      timestamp: timestamp ?? this.timestamp,
      language: language ?? this.language,
      confidence: confidence ?? this.confidence,
      hasISLAnimation: hasISLAnimation ?? this.hasISLAnimation,
      islAnimationPath: islAnimationPath ?? this.islAnimationPath,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originalText': originalText,
      'simplifiedText': simplifiedText,
      'timestamp': timestamp.toIso8601String(),
      'language': language,
      'confidence': confidence,
      'hasISLAnimation': hasISLAnimation,
      'islAnimationPath': islAnimationPath,
      'tags': tags,
    };
  }

  factory Transcript.fromJson(Map<String, dynamic> json) {
    return Transcript(
      id: json['id'],
      originalText: json['originalText'],
      simplifiedText: json['simplifiedText'],
      timestamp: DateTime.parse(json['timestamp']),
      language: json['language'],
      confidence: json['confidence'].toDouble(),
      hasISLAnimation: json['hasISLAnimation'] ?? false,
      islAnimationPath: json['islAnimationPath'],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}
