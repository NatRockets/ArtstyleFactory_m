# ArtStyle Factory - Application Structure

## 📁 File Structure

```
artstyle_factory/
├── lib/
│   ├── main.dart                          # Entry point
│   ├── app/
│   │   └── my_app.dart                   # Root widget, theme setup
│   ├── models/
│   │   └── idea.dart                     # Data model for ideas
│   ├── screens/                          # UI Screens
│   │   ├── art_spin_screen.dart         # Main screen with wheels
│   │   ├── favorites_screen.dart        # Saved ideas list
│   │   ├── idea_detail_screen.dart      # Idea details + tips
│   │   └── knowledge_base_screen.dart   # Educational content
│   ├── services/
│   │   └── data_service.dart            # Data management, storage
│   ├── theme/
│   │   └── app_theme.dart               # Colors, gradients, theme
│   └── widgets/
│       └── wheel_widget.dart            # Spinning wheel component
├── pubspec.yaml                          # Dependencies
├── README.md                             # Full documentation
├── QUICK_START.md                        # Usage guide
└── CUSTOMIZATION.md                      # Customization guide
```

## 🔄 Data Flow

```
User Interaction
      ↓
 Screen (UI)
      ↓
 DataService
      ↓
 shared_preferences (Storage)
```

## 🎯 Screen Navigation Map

```
┌─────────────────────────┐
│   ArtSpinScreen         │ ← Home/Main
│   (Spinning Wheels)     │
└───────┬─────────┬───────┘
        │         │
        │         └─────────────────┐
        │                           │
        ↓                           ↓
┌───────────────┐          ┌────────────────┐
│ FavoritesScreen│         │ KnowledgeBase  │
│ (Saved Ideas)  │         │ (Education)    │
└───────┬────────┘         └────────────────┘
        │
        ↓
┌─────────────────┐
│ IdeaDetailScreen│
│ (Tips & Share)  │
└─────────────────┘
```

## 🎨 Component Hierarchy

### ArtSpinScreen
```
Scaffold
└── SingleChildScrollView
    └── Column
        ├── Title Text
        ├── Wrap (4 WheelWidgets)
        │   ├── WheelWidget (Category)
        │   ├── WheelWidget (Style)
        │   ├── WheelWidget (Technique)
        │   └── WheelWidget (Material)
        ├── FloatingActionButton (Generate)
        ├── Row (Action Buttons)
        │   ├── Save Button
        │   └── Share Button
        └── ElevatedButton (Get Tips)
```

### FavoritesScreen
```
Scaffold
└── ListView.builder
    └── Card
        └── ListTile
            ├── Icon (leading)
            ├── Title & Subtitle
            └── Delete Button (trailing)
```

### IdeaDetailScreen
```
Scaffold
└── SingleChildScrollView
    └── Column
        ├── Idea Card (Gradient)
        │   ├── Category Row
        │   ├── Style Row
        │   ├── Technique Row
        │   └── Material Row
        ├── Tips Section Header
        └── Tips Card
            └── Text (Implementation Tips)
```

### KnowledgeBaseScreen
```
DefaultTabController
└── Scaffold
    └── TabBarView
        ├── Tab 1: Styles
        ├── Tab 2: Techniques
        └── Tab 3: Materials
            └── ListView.builder
                └── ExpansionTile
```

## 🔧 Service Architecture

### DataService (Singleton)
```
DataService
├── Data Lists
│   ├── categories: List<String>
│   ├── styles: List<String>
│   ├── techniques: List<String>
│   └── materials: List<String>
│
├── Knowledge Base
│   ├── styleDescriptions: Map<String, String>
│   ├── techniqueDescriptions: Map<String, String>
│   └── materialDescriptions: Map<String, String>
│
├── Random Generation
│   ├── generateRandomIdea() → Idea
│   └── getRandomValue(List) → String
│
└── Storage Operations
    ├── getFavorites() → Future<List<Idea>>
    ├── addFavorite(Idea) → Future<void>
    ├── removeFavorite(Idea) → Future<void>
    └── isFavorite(Idea) → Future<bool>
```

## 📊 Data Model

### Idea Class
```dart
Idea {
  String category
  String style
  String technique
  String material
  DateTime timestamp
  
  // Methods
  + toJson() → Map<String, dynamic>
  + fromJson(Map) → Idea
  + shortTitle → String
  + fullDescription → String
  + shareText → String
  + operator == → bool
  + hashCode → int
}
```

## 🎨 Theme Structure

### AppTheme
```
AppTheme
├── Colors
│   ├── Primary (Blue/Cyan)
│   ├── Accent (Orange/Red/Yellow/Green)
│   └── Neutral (Background/Surface/Text)
│
├── Gradients
│   ├── primaryGradient
│   └── accentGradient
│
├── Theme Data
│   ├── ColorScheme
│   ├── AppBarTheme
│   ├── CardTheme
│   ├── ButtonThemes
│   └── TextTheme
│
└── Utilities
    ├── glowShadow(Color)
    └── cardDecoration(Gradient?)
```

## 🎡 Wheel Animation Flow

```
User Taps Wheel
       ↓
setState(isSpinning = true)
       ↓
AnimationController.forward()
       ↓
RotationTransition (0 → 4π)
       ↓
Wait 2 seconds
       ↓
setState(new random values)
       ↓
setState(isSpinning = false)
       ↓
Check if favorited
```

## 💾 Storage Format

### SharedPreferences Key: 'favorites'
```json
[
  {
    "category": "Portrait",
    "style": "Pop Art",
    "technique": "Collage",
    "material": "Canvas",
    "timestamp": "2026-01-14T10:30:00.000Z"
  },
  {
    "category": "Landscape",
    "style": "Impressionism",
    "technique": "Watercolor",
    "material": "Paper",
    "timestamp": "2026-01-14T11:45:00.000Z"
  }
]
```

## 🚀 App Lifecycle

```
main()
  ↓
MyApp.build()
  ↓
DataService.init() (async)
  ↓
MaterialApp
  ↓
ArtSpinScreen
  ↓
initState()
  ↓
_initializeValues() (random)
  ↓
_checkIfFavorite() (async)
  ↓
Build UI
```

## 🎯 Key Features Implementation

### 1. Spinning Wheels
- **Widget**: `WheelWidget` (StatefulWidget)
- **Animation**: `AnimationController` + `RotationTransition`
- **Duration**: 2000ms with `Curves.easeOut`
- **Visual**: Radial gradient, segmented circle, glow shadow

### 2. Favorites
- **Storage**: `shared_preferences` (JSON)
- **Operations**: Add, Remove, Check, List All
- **UI**: Heart icon toggle, confirmation dialog on delete

### 3. Sharing
- **Package**: `share_plus`
- **Format**: "My new idea from ArtStyle Factory: [Category] in [Style] style, technique [Technique] on [Material]"
- **Platforms**: All installed sharing apps

### 4. Tips Generation
- **Source**: Predefined maps in `DataService`
- **Types**: Style tips, Technique tips, Material tips
- **Display**: Combined view or random single tip

### 5. Knowledge Base
- **UI**: `DefaultTabController` with 3 tabs
- **Widget**: `ExpansionTile` for each item
- **Sorting**: Alphabetical by key
- **Content**: Rich text descriptions

## 📐 Responsive Design

### Wheel Layout
- Uses `Wrap` widget for responsive grid
- Automatically wraps on smaller screens
- Fixed size: 160x160 per wheel
- Spacing: 20px horizontal and vertical

### Screen Padding
- All screens: 16px horizontal
- Cards: 16px margin horizontal, 8px vertical
- Consistent spacing throughout

## 🎨 Color Usage Map

| Component | Color |
|-----------|-------|
| AppBar | Primary Blue |
| Wheel 1 (Category) | Orange |
| Wheel 2 (Style) | Red |
| Wheel 3 (Technique) | Yellow |
| Wheel 4 (Material) | Green |
| FAB | Primary Blue |
| Save (unfilled) | Primary Blue |
| Save (filled) | Red |
| Share | Primary Blue |
| Idea Card | Blue-Cyan Gradient |
| Cards | White with shadow |
| Background | Light Gray (#F5F5F5) |

## 🔄 State Management Pattern

**Pattern Used**: `setState` with `StatefulWidget`

### Why StatefulWidget?
- Simple state management
- Perfect for isolated component state
- No external dependencies
- Easy to understand and maintain
- Suitable for app size and complexity

### State Locations
- `ArtSpinScreen`: Current values, spinning state, favorite state
- `FavoritesScreen`: List of favorites, loading state
- `IdeaDetailScreen`: Favorite state, current tip
- `WheelWidget`: Animation state

## 📱 Platform Support

- ✅ iOS
- ✅ Android
- ⚠️ Web (works but sharing limited)
- ⚠️ Desktop (works but sharing limited)

---

**This structure provides a clean, maintainable codebase with clear separation of concerns.**
