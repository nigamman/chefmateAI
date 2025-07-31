import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/recipe_model.dart';
import '../core/exceptions.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  final String _apiKey = dotenv.env['GROQ_API_KEY'] ?? '';
  final String _apiUrl = dotenv.env['GROQ_API_URL'] ?? '';
  final String _modelName = dotenv.env['MODEL_NAME'] ?? '';

  Future<Recipe> generateRecipeFromIngredients(String ingredients) async {
    if (_apiKey.isEmpty) {
      throw const APIException('API key not found');
    }

    final prompt = '''
You are a smart Indian chef assistant. Based on the following ingredients, suggest one complete recipe in Hindi/Hinglish mix that Indian moms will love.

Return ONLY a JSON response in this exact format:
{
  "name": "Recipe name in Hindi/Hinglish",
  "ingredients": ["ingredient 1 with quantity", "ingredient 2 with quantity", ...],
  "instructions": ["step 1", "step 2", "step 3", ...]
}

Available ingredients: $ingredients

Make it authentic, easy to cook, and suitable for Indian households. Include quantities and cooking time estimates.
''';

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _modelName,
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'max_tokens': 1000,
          'temperature': 0.7,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];

        // Clean the response to extract JSON
        String cleanedContent = content.trim();
        if (cleanedContent.startsWith('```json')) {
          cleanedContent = cleanedContent.substring(7);
        }
        if (cleanedContent.endsWith('```')) {
          cleanedContent = cleanedContent.substring(0, cleanedContent.length - 3);
        }

        final recipeData = jsonDecode(cleanedContent);

        return Recipe(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: recipeData['name'] ?? 'नया रेसिपी',
          ingredients: List<String>.from(recipeData['ingredients'] ?? []),
          instructions: List<String>.from(recipeData['instructions'] ?? []),
          createdAt: DateTime.now(),
        );
      } else {
        throw APIException('API Error: ${response.statusCode}');
      }
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on FormatException {
      throw const APIException('Invalid response format');
    } catch (e) {
      throw APIException('Unexpected error: ${e.toString()}');
    }
  }

  Future<Recipe> generateDailyRecipe() async {
    final ingredients = [
      'आलू, प्याज, टमाटर',
      'चावल, दाल, हल्दी',
      'रोटी, सब्जी, दही',
      'चना, मसाले, अदरक',
      'पनीर, मिर्च, धनिया'
    ];

    final randomIngredients = ingredients[DateTime.now().day % ingredients.length];
    return generateRecipeFromIngredients(randomIngredients);
  }
}
