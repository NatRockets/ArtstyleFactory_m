# Customization Guide

This guide explains how to customize various aspects of the ArtStyle Factory app.

## 🎨 Changing Colors

All colors are centralized in `/lib/theme/app_theme.dart`. Here's what you can modify:

### Primary Colors
```dart
static const Color primaryBlue = Color(0xFF1E88E5);
static const Color primaryCyan = Color(0xFF00ACC1);
static const Color darkBlue = Color(0xFF0D47A1);
static const Color lightBlue = Color(0xFF64B5F6);
```

### Wheel Colors
```dart
static const Color wheel1Color = Color(0xFFE67E22); // Orange - Category
static const Color wheel2Color = Color(0xFFE74C3C); // Red - Style
static const Color wheel3Color = Color(0xFFF39C12); // Yellow - Technique
static const Color wheel4Color = Color(0xFF95C946); // Green - Material
```

### Accent Colors
```dart
static const Color accentOrange = Color(0xFFE67E22);
static const Color accentRed = Color(0xFFE74C3C);
static const Color accentYellow = Color(0xFFF39C12);
static const Color accentGreen = Color(0xFF95C946);
```

### Gradients
```dart
static const LinearGradient primaryGradient = LinearGradient(
  colors: [primaryBlue, primaryCyan],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
```

## 📝 Adding New Data

Edit `/lib/services/data_service.dart` to add new options:

### Categories
```dart
final List<String> categories = [
  'Portrait',
  'Landscape',
  // Add your new category here
  'Your New Category',
];
```

### Styles
```dart
final List<String> styles = [
  'Realism',
  'Impressionism',
  // Add your new style here
  'Your New Style',
];
```

### Techniques
```dart
final List<String> techniques = [
  'Oil Painting',
  'Digital Graphics',
  // Add your new technique here
  'Your New Technique',
];
```

### Materials
```dart
final List<String> materials = [
  'Canvas',
  'Paper',
  // Add your new material here
  'Your New Material',
];
```

## 📚 Adding Knowledge Base Content

Add descriptions for new items in the knowledge base maps:

### Style Descriptions
```dart
final Map<String, String> styleDescriptions = {
  'Your New Style': 'Description of your new style. Include history, characteristics, and famous artists.',
  // ... other styles
};
```

### Technique Descriptions
```dart
final Map<String, String> techniqueDescriptions = {
  'Your New Technique': 'Description of the technique. Include process, tools, and tips.',
  // ... other techniques
};
```

### Material Descriptions
```dart
final Map<String, String> materialDescriptions = {
  'Your New Material': 'Description of the material. Include properties and usage tips.',
  // ... other materials
};
```

## 🎡 Customizing Wheel Animation

Edit `/lib/widgets/wheel_widget.dart`:

### Spin Duration
```dart
_controller = AnimationController(
  duration: const Duration(milliseconds: 2000), // Change this value
  vsync: this,
);
```

### Rotation Amount
```dart
_animation = Tween<double>(
  begin: 0,
  end: math.pi * 8, // Change multiplier (8 = 4 full rotations)
).animate(CurvedAnimation(
  parent: _controller,
  curve: Curves.easeOut, // Change animation curve
));
```

### Available Curves
- `Curves.easeOut` - Slow down at end (current)
- `Curves.easeIn` - Speed up at start
- `Curves.easeInOut` - Both
- `Curves.bounceOut` - Bouncy effect
- `Curves.elasticOut` - Elastic effect

### Wheel Size
In `/lib/screens/art_spin_screen.dart`, change wheel size:
```dart
WheelWidget(
  // Currently in wheel_widget.dart build method:
  width: 160,  // Change this
  height: 160, // Change this
  // ...
)
```

## 🎯 Customizing Wheel Appearance

Edit `/lib/widgets/wheel_widget.dart`:

### Segment Count
```dart
const segmentCount = 8; // Change number of alternating segments
```

### Shadow and Glow
```dart
boxShadow: [
  BoxShadow(
    color: widget.color.withOpacity(0.4), // Glow opacity
    blurRadius: 15, // Glow size
    spreadRadius: 3, // Glow spread
  ),
  BoxShadow(
    color: Colors.black.withOpacity(0.2), // Shadow opacity
    blurRadius: 8, // Shadow blur
    offset: const Offset(0, 4), // Shadow position
  ),
],
```

## 📱 Changing App Name

### In Code
Edit `/lib/app/my_app.dart`:
```dart
return MaterialApp(
  title: 'Your App Name',
  // ...
);
```

### In Android
Edit `/android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:label="Your App Name"
    ...>
```

### In iOS
Edit `/ios/Runner/Info.plist`:
```xml
<key>CFBundleName</key>
<string>Your App Name</string>
```

## 🔤 Changing Text Content

### Screen Titles
Edit each screen file in `/lib/screens/`:
```dart
appBar: AppBar(
  title: const Text('Your Custom Title'),
),
```

### Button Labels
Edit `/lib/screens/art_spin_screen.dart`:
```dart
FloatingActionButton.extended(
  // ...
  label: const Text('Your Button Text'),
),
```

## 🎨 Card and Container Styling

Edit `/lib/theme/app_theme.dart`:

### Card Theme
```dart
cardTheme: CardThemeData(
  elevation: 4,           // Shadow depth
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16), // Corner radius
  ),
  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
),
```

### Button Theme
```dart
elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: primaryBlue,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // Corner radius
    ),
  ),
),
```

## 💾 Storage Key

If you want to change the storage key for favorites:

Edit `/lib/services/data_service.dart`:
```dart
static const String _favoritesKey = 'your_custom_key';
```

## 🌐 Adding Translations

Currently, all text is hardcoded in English. To add translations:

1. Add `flutter_localizations` package
2. Create translation files
3. Wrap text widgets with localization
4. Update MaterialApp with localization delegates

Example:
```yaml
# pubspec.yaml
dependencies:
  flutter_localizations:
    sdk: flutter
```

## 🔧 Advanced Customization

### Adding New Screens
1. Create new file in `/lib/screens/`
2. Extend `StatefulWidget` or `StatelessWidget`
3. Add navigation in existing screens:
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => YourNewScreen()),
);
```

### Using GoRouter (Navigator 2.0)
Install package and configure routes for more advanced navigation needs.

### Adding Database (SQLite)
Replace `shared_preferences` with `sqflite` for more complex data needs.

### Adding State Management
Consider adding:
- Provider
- Riverpod
- Bloc
- GetX

## 📋 Testing Customizations

After making changes:

1. Format code: `dart format lib/`
2. Check for errors: `flutter analyze`
3. Run app: `flutter run`
4. Hot reload during development: Press `r` in terminal or save files

## 🎨 Design Tips

- Keep color contrast high for readability
- Test on both light and dark device themes
- Consider colorblind-friendly palettes
- Maintain consistent spacing and sizing
- Use Flutter DevTools for UI debugging

---

**Remember**: After any customization, run `flutter pub get` if you added dependencies, and test thoroughly on your target devices!
