# ArtStyle Factory - Quick Start Guide

## What is this app?

ArtStyle Factory is a creative inspiration tool for artists and designers. It generates random combinations of:
- **Category** (what to create)
- **Style** (how it should look)
- **Technique** (how to make it)
- **Material** (what to use)

## How to use:

### 1. Main Screen (Art Spin)
- **Tap any wheel** or the "Generate Idea" button to spin
- All 4 wheels spin together and land on random values
- Each wheel has a different color:
  - 🟠 Orange = Category
  - 🔴 Red = Style
  - 🟡 Yellow = Technique
  - 🟢 Green = Material

### 2. Save Your Favorites
- Tap the **heart icon** to save an idea
- The icon turns solid red when saved
- Access saved ideas via the heart icon in the top bar

### 3. Get Implementation Tips
- Tap **"Get Implementation Tips"** button
- Read professional guidance for your combination
- Use **"Random Tip"** for quick inspiration
- Tap **"Reload All Tips"** to see complete details again

### 4. Share Ideas
- Tap the **share icon** to share via any app
- Share from main screen or details screen
- Format: "My new idea from ArtStyle Factory: Portrait in Pop Art style, technique Collage on Glossy Magazine"

### 5. Knowledge Base
- Tap the **help icon (?)** in the top bar
- Browse 3 tabs: Styles, Techniques, Materials
- Tap any item to expand and read details
- Use as a reference guide while creating

### 6. Manage Favorites
- Tap heart icon in top bar
- View all saved ideas
- Tap any idea to see details
- Tap trash icon to delete (with confirmation)

## Example Workflow:

1. Open app → See 4 spinning wheels
2. Tap "Generate Idea" → Wheels spin
3. Result: "Portrait in Cyberpunk style, 3D Modeling on Metal"
4. Tap "Get Implementation Tips" → Read guidance
5. Like it? Tap heart to save
6. Want to share? Tap share icon
7. Need more info? Check Knowledge Base

## Tips:

- **Wheels won't spin while already spinning** - wait for animation to finish
- **Favorites are saved locally** - they won't be lost when you close the app
- **All text is in English** - as per design requirements
- **Blue theme** - Main colors are blue and cyan with colorful accents

## Screens Summary:

1. **Art Spin Screen** (Main) - Generate ideas with spinning wheels
2. **Favorites Screen** - View and manage saved ideas
3. **Idea Detail Screen** - See full details and tips for an idea
4. **Knowledge Base Screen** - Educational content about art

## Technical Notes:

- Uses `shared_preferences` for local storage
- All data is stored on device
- No internet connection required
- Smooth animations with 2-second spin duration
- Random generation uses Dart's built-in Random class

Enjoy creating! 🎨✨
