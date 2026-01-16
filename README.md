# ArtStyle Factory 🎨

A Flutter mobile application designed for artists and designers to generate random creative inspiration through interactive spinning wheels. Get unique combinations of categories, styles, techniques, and materials to spark your next project!

## Features ✨

### 🎡 Interactive Spinning Wheels
- **4 Fortune Wheels**: Each wheel represents a different creative parameter
  - **Category**: Portrait, Landscape, Abstract, Still Life, Concept Art, Logo, Poster, Infographic
  - **Style**: Realism, Impressionism, Cubism, Minimalism, Pop Art, Cyberpunk, Vintage, Grunge
  - **Technique**: Oil Painting, Digital Graphics, Collage, Graffiti, Embroidery, 3D Modeling, Linocut, Watercolor
  - **Material**: Canvas, Paper, Wood, Metal, Digital Canvas, Street Wall, Fabric, Plywood

### 💾 Save & Share
- Save your favorite idea combinations to a local database
- Share ideas via any installed sharing app
- Quick access to your saved ideas library

### 💡 Implementation Tips
- Get professional guidance for each generated combination
- Learn about styles, techniques, and materials
- Random tip generator for quick inspiration

### 📚 Knowledge Base
- Comprehensive information about art styles
- Detailed technique guides and best practices
- Material properties and usage tips
- Alphabetically organized for easy browsing

## Screenshots

### Main Screen
The main screen features 4 colorful spinning wheels. Tap any wheel or the "Generate Idea" button to spin all wheels simultaneously. The wheels animate with smooth rotation and settle on random values.

### Favorites Screen
Browse all your saved ideas in a beautiful list. Each idea shows the category, style, technique, and material. Delete unwanted ideas with a single tap.

### Idea Details
View complete details of any idea with color-coded parameter cards. Access implementation tips specific to your chosen combination.

### Knowledge Base
Three organized tabs provide in-depth information about all available styles, techniques, and materials.

## Architecture 🏗️

### Technology Stack
- **Framework**: Flutter
- **State Management**: StatefulWidgets with setState
- **Navigation**: Standard Navigator with MaterialPageRoute
- **Local Storage**: shared_preferences for favorites persistence
- **Random Generation**: Dart's math.Random
- **Sharing**: share_plus package

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── app/
│   └── my_app.dart          # Root app widget
├── models/
│   └── idea.dart            # Idea data model
├── screens/
│   ├── art_spin_screen.dart      # Main spinning wheels screen
│   ├── favorites_screen.dart     # Saved ideas list
│   ├── idea_detail_screen.dart   # Idea details and tips
│   └── knowledge_base_screen.dart # Educational content
├── services/
│   └── data_service.dart    # Data management and storage
├── theme/
│   └── app_theme.dart       # Color palette and theme configuration
└── widgets/
    └── wheel_widget.dart    # Reusable spinning wheel component
```

### Key Design Patterns
- **Singleton Pattern**: DataService uses singleton for global access
- **Model-View Pattern**: Clear separation between data (models) and UI (screens)
- **Widget Composition**: Reusable WheelWidget component
- **Future-based async**: All storage operations use async/await

## Color Theme 🎨

The app uses a blue and cyan color palette with creative accent colors:

- **Primary Colors**: Blue (#1E88E5) and Cyan (#00ACC1)
- **Wheel Colors**: 
  - Orange (#E67E22) for Category
  - Red (#E74C3C) for Style
  - Yellow (#F39C12) for Technique
  - Green (#95C946) for Material
- **Theme Configuration**: All colors centralized in `app_theme.dart` for easy customization

## Getting Started 🚀

### Prerequisites
- Flutter SDK (3.10.4 or higher)
- Dart SDK
- iOS Simulator / Android Emulator / Physical Device

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd artstyle_factory
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Usage Guide 📖

### Generating Ideas
1. Launch the app to see the main screen with 4 wheels
2. Tap any wheel or press the "Generate Idea" button
3. Watch the wheels spin and settle on random values
4. Your new creative combination is ready!

### Saving Ideas
1. After generating an idea you like, tap the "Save" button
2. The heart icon fills in to confirm it's saved
3. Access saved ideas from the favorites icon in the app bar

### Viewing Details
1. Tap "Get Implementation Tips" on the main screen
2. Or tap any saved idea in the favorites list
3. View detailed tips for style, technique, and material
4. Use "Random Tip" for quick inspiration
5. Share directly from the details screen

### Exploring Knowledge
1. Tap the help icon (?) in the app bar
2. Browse three tabs: Styles, Techniques, Materials
3. Tap any item to expand and read detailed information
4. Use as a reference while working on projects

## Customization 🛠️

### Changing Colors
Edit `/lib/theme/app_theme.dart` to modify:
- Primary and accent colors
- Wheel colors
- Gradients and shadows
- Text styles

### Adding New Options
Edit `/lib/services/data_service.dart` to add:
- New categories, styles, techniques, or materials to the lists
- New descriptions to the knowledge base maps

### Modifying Animations
Edit `/lib/widgets/wheel_widget.dart` to adjust:
- Spin duration
- Rotation amount (currently 4 full rotations)
- Animation curves

## Dependencies 📦

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.2.2  # Local data persistence
  share_plus: ^7.2.1          # Social sharing functionality
```

## Future Enhancements 🔮

Potential features for future versions:
- Custom idea creation and editing
- Export favorites as PDF or image
- Dark theme support
- Advanced filtering in knowledge base
- Cloud sync for favorites
- Community sharing platform
- AI-generated visual previews
- Project timeline tracking

## Contributing 🤝

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## License 📄

This project is open source and available under the MIT License.

## Contact 📧

For questions or feedback, please open an issue on the repository.

---

**Made with ❤️ for artists and designers worldwide**
