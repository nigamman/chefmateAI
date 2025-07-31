# ChefmateAI - Smart Recipe Assistant

A production-ready Flutter app that helps Indian households decide "Aaj kya banaayein?" using AI-powered recipe suggestions.

## Features

- **Daily Recipe Suggestions**: Get fresh recipe ideas every day
- **Ingredient-based Recipes**: Enter available ingredients and get personalized recipes
- **Hindi/Hinglish Support**: User-friendly interface in Hindi/Hinglish
- **Offline Caching**: Recent recipes stored locally
- **Network Awareness**: Shows connectivity status
- **Production Ready**: Error handling, loading states, and robust architecture

## Architecture

```
lib/
├── core/              # App-wide configurations
│   ├── app_theme.dart
│   ├── constants.dart
│   └── exceptions.dart
├── models/            # Data models
│   └── recipe_model.dart
├── providers/         # State management
│   ├── recipe_provider.dart
│   └── connectivity_provider.dart
├── services/          # External services
│   └── ai_service.dart
├── screens/           # UI screens
│   ├── home_screen.dart
│   ├── ingredient_input_screen.dart
│   └── recipe_result_screen.dart
├── widgets/           # Reusable widgets
│   ├── daily_recipe_card.dart
│   ├── recipe_card.dart
│   ├── loading_overlay.dart
│   └── connectivity_banner.dart
└── main.dart
```

## Setup Instructions

### 1. Prerequisites
- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Groq API access

### 2. Installation

```bash
# Clone and setup
git clone <repository>
cd chefmate_ai

# Install dependencies
flutter pub get

# Create .env file in root directory
echo "GROQ_API_KEY=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" > .env
echo "GROQ_API_URL=https://api.groq.com/openai/v1/chat/completions" >> .env
echo "MODEL_NAME=mixtral-8x7b-32768" >> .env

# Run the app
flutter run
```

### 3. Build for Production

```bash
# Build APK
flutter build apk --release

# Build AAB for Play Store
flutter build appbundle --release

# Build iOS (requires macOS)
flutter build ios --release
```

## Key Production Features

### Error Handling
- Network connectivity monitoring
- API failure recovery
- User-friendly error messages in Hindi
- Graceful degradation when offline

### Performance
- Efficient state management with Provider
- Local caching with SharedPreferences
- Optimized API calls with timeout handling
- Memory-efficient image loading

### User Experience
- Loading indicators with contextual messages
- Smooth transitions and animations
- Intuitive Hindi/Hinglish interface
- Quick ingredient suggestions

### Security
- Environment variables for API keys
- Network security configuration
- Input validation and sanitization
- Safe error message display

## API Integration

The app uses Groq's Mixtral-8x7b model for recipe generation:

```dart
// Example API call structure
{
  "model": "mixtral-8x7b-32768",
  "messages": [
    {
      "role": "user", 
      "content": "Generate Indian recipe for: tomato, onion, potato"
    }
  ],
  "max_tokens": 1000,
  "temperature": 0.7
}
```

## Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter drive --target=test_driver/app.dart

# Generate coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Deployment Checklist

- [ ] API keys secured in environment variables
- [ ] Network permissions configured
- [ ] App icons and splash screen added
- [ ] Version numbers updated
- [ ] ProGuard rules configured (Android)
- [ ] App Store/Play Store metadata prepared
- [ ] Privacy policy and terms of service
- [ ] Analytics and crash reporting configured
- [ ] Performance monitoring enabled

## Future Enhancements

- [ ] User authentication with Firebase
- [ ] Recipe bookmarking and favorites
- [ ] Voice input for ingredients
- [ ] Meal planning and weekly suggestions
- [ ] Nutritional information
- [ ] Multiple cuisine preferences
- [ ] Social sharing features
- [ ] Recipe rating and reviews

## Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/new-feature`
3. Commit changes: `git commit -am 'Add new feature'`
4. Push to branch: `git push origin feature/new-feature`
5. Submit pull request

## License

This project is licensed under the MIT License - see LICENSE file for details.

## Support

For support and queries:
- Email: support@chefmateai.com
- Issues: GitHub Issues
- Documentation: [Wiki](link-to-wiki)

---

**ChefmateAI** - Making cooking decisions easier for Indian families! 🍽️✨