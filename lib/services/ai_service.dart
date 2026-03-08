import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  // IMPORTANT: For production, use a secure method to store and retrieve your API key.
  static const String _apiKey = 'YOUR_API_KEY';

  final GenerativeModel _model;

  AiService()
    : _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);

  Future<String> summarizeAbstract(String abstract) async {
    final prompt =
        '''
Summarize the following research paper abstract into exactly 3 concise, high-impact bullet points. 
Format each point starting with a "•" character.
Focus on:
1. The specific problem addressed.
2. The innovative methodology used.
3. The most significant finding or implication.

Abstract:
$abstract
''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? 'No summary generated.';
    } catch (e) {
      debugPrint('Error generating AI summary: $e');
      rethrow;
    }
  }
}
