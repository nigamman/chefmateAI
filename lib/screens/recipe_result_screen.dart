import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/recipe_model.dart';
import '../widgets/recipe_card.dart';

class RecipeResultScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeResultScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareRecipe(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: RecipeCard(
          recipe: recipe,
          showFullDetails: true,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        icon: const Icon(Icons.home),
        label: const Text('घर वापस'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  void _shareRecipe(BuildContext context) {
    final recipeText = '''
${recipe.name}

सामग्री:
${recipe.ingredients.map((ingredient) => '• $ingredient').join('\n')}

बनाने की विधि:
${recipe.instructions.asMap().entries.map((entry) => '${entry.key + 1}. ${entry.value}').join('\n')}

- ChefmateAI से प्राप्त
''';

    Clipboard.setData(ClipboardData(text: recipeText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('रेसिपी कॉपी हो गई!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return RecipeResultScreen(recipe: recipe);
  }
}
