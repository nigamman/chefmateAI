import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../core/constants.dart';
import '../widgets/loading_overlay.dart';
import 'recipe_result_screen.dart';

class IngredientInputScreen extends StatefulWidget {
  const IngredientInputScreen({super.key});

  @override
  State<IngredientInputScreen> createState() => _IngredientInputScreenState();
}

class _IngredientInputScreenState extends State<IngredientInputScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitIngredients() async {
    final ingredients = _controller.text.trim();
    if (ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppConstants.noIngredientsError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final provider = Provider.of<RecipeProvider>(context, listen: false);
    await provider.generateRecipeFromIngredients(ingredients);

    if (provider.error != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else if (provider.currentRecipe != null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeResultScreen(recipe: provider.currentRecipe!),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.enterIngredients),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<RecipeProvider>(
        builder: (context, provider, child) {
          return LoadingOverlay(
            isLoading: provider.isLoading,
            loadingText: AppConstants.loading,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'आपके पास कौन सी सामग्री है?',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'जो भी सामग्री घर में उपलब्ध है, उसे नीचे लिखें',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: 4,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submitIngredients(),
                    decoration: const InputDecoration(
                      hintText: AppConstants.ingredientsHint,
                      labelText: 'सामग्री',
                      alignLabelWithHint: true,
                    ),
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    onPressed: provider.isLoading ? null : _submitIngredients,
                    icon: const Icon(Icons.restaurant_menu),
                    label: const Text(
                      AppConstants.getRecipe,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 56),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Quick suggestions
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'कुछ सुझाव:',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              'आलू, प्याज, टमाटर',
                              'चावल, दाल',
                              'पनीर, मिर्च',
                              'चना, मसाले',
                              'रोटी का आटा',
                            ].map((suggestion) => ActionChip(
                              label: Text(suggestion),
                              onPressed: () {
                                _controller.text = suggestion;
                              },
                            )).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  Text(
                    '💡 टिप: जितनी ज्यादा सामग्री बताएंगे, उतनी बेहतर रेसिपी मिलेगी!',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}