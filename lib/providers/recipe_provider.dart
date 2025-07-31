import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe_model.dart';
import '../services/ai_service.dart';
import '../core/constants.dart';
import '../core/exceptions.dart';

class RecipeProvider extends ChangeNotifier {
  final AIService _aiService = AIService();

  Recipe? _currentRecipe;
  Recipe? _dailyRecipe;
  bool _isLoading = false;
  String? _error;
  List<Recipe> _recentRecipes = [];

  Recipe? get currentRecipe => _currentRecipe;
  Recipe? get dailyRecipe => _dailyRecipe;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Recipe> get recentRecipes => _recentRecipes;

  RecipeProvider() {
    _loadStoredData();
  }

  Future<void> _loadStoredData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load daily recipe
      final dailyRecipeJson = prefs.getString(AppConstants.dailyRecipeKey);
      final lastRecipeDate = prefs.getString(AppConstants.lastRecipeDate);
      final today = DateTime.now().toIso8601String().substring(0, 10);

      if (dailyRecipeJson != null && lastRecipeDate == today) {
        _dailyRecipe = Recipe.fromJson(jsonDecode(dailyRecipeJson));
      } else {
        await generateDailyRecipe();
      }

      // Load recent recipes
      final recentRecipesJson = prefs.getStringList('recent_recipes') ?? [];
      _recentRecipes = recentRecipesJson
          .map((json) => Recipe.fromJson(jsonDecode(json)))
          .toList();

      notifyListeners();
    } catch (e) {
      _error = 'Failed to load stored data';
      notifyListeners();
    }
  }

  Future<void> generateRecipeFromIngredients(String ingredients) async {
    if (ingredients.trim().isEmpty) {
      _error = AppConstants.noIngredientsError;
      notifyListeners();
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      final recipe = await _aiService.generateRecipeFromIngredients(ingredients);
      _currentRecipe = recipe;
      await _addToRecentRecipes(recipe);
    } on NetworkException catch (e) {
      _error = AppConstants.networkError;
    } on APIException catch (e) {
      _error = AppConstants.apiError;
    } catch (e) {
      _error = AppConstants.apiError;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> generateDailyRecipe() async {
    try {
      final recipe = await _aiService.generateDailyRecipe();
      _dailyRecipe = recipe;
      await _storeDailyRecipe(recipe);
      notifyListeners();
    } catch (e) {
      // Silent fail for daily recipe - keep old one if exists
    }
  }

  Future<void> _storeDailyRecipe(Recipe recipe) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.dailyRecipeKey, jsonEncode(recipe.toJson()));
    await prefs.setString(AppConstants.lastRecipeDate,
        DateTime.now().toIso8601String().substring(0, 10));
  }

  Future<void> _addToRecentRecipes(Recipe recipe) async {
    _recentRecipes.insert(0, recipe);
    if (_recentRecipes.length > 10) {
      _recentRecipes = _recentRecipes.take(10).toList();
    }

    final prefs = await SharedPreferences.getInstance();
    final jsonList = _recentRecipes.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList('recent_recipes', jsonList);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearCurrentRecipe() {
    _currentRecipe = null;
    notifyListeners();
  }
}