# LDR Gotchi - Flutter App

A Flutter-based long-distance relationship Tamagotchi-style virtual pet app. Care for your shared virtual companion together with your partner across web and mobile platforms!

## 🚀 Features

### Core Pet System
- **Pet Evolution**: Your pet grows from egg → baby → child → adult based on real-time aging
- **Vital Stats**: Health, hunger, happiness, and energy that decay over time
- **Personality Traits**: Playful, Smart, and Affection levels that develop based on interactions
- **Mood System**: Pet face changes based on current stats and needs

### 🎮 Interactive Features
- **Memory Game**: Help your pet exercise their brain with a matching pairs mini-game
- **Sound Effects**: Audio feedback for all actions (can be toggled on/off)
- **Visual Animations**: Smooth transitions, confetti celebrations, and glowing effects
- **Action Cooldowns**: Realistic 10-minute cooldowns between major actions

### 🏆 Achievement System
- **First Meal**: Feed your pet for the first time
- **Happy Pet**: Keep happiness above 80%
- **One Week Old**: Pet survives for a week
- **Brain Games**: Win 3 memory games
- **Social Butterfly**: Send 10 messages
- **All Grown Up**: Pet reaches adulthood

### 💌 Messaging System
- **Partner Messages**: Send messages to your partner through the shared pet
- **Message History**: View recent messages exchanged
- **Real-time Updates**: Messages sync when importing partner's data

### 🔄 Enhanced Sharing
- **Data Export/Import**: Share pet progress with your partner
- **Cross-platform**: Works on web, iOS, and Android
- **Automatic Clipboard**: Data is automatically copied when exporting

## 🛠 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or later)
- Dart SDK (included with Flutter)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd llm_gotchi
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   
   For web:
   ```bash
   flutter run -d chrome
   ```
   
   For mobile (with device/emulator connected):
   ```bash
   flutter run
   ```

   For all platforms:
   ```bash
   flutter run -d all
   ```

## 📱 Platform Support

- ✅ **Web** - Fully supported
- ✅ **Android** - Fully supported  
- ✅ **iOS** - Fully supported
- ✅ **Desktop** - Supported (Windows, macOS, Linux)

## 📂 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── pet.dart             # Pet model with stats and methods
│   ├── achievement.dart     # Achievement system
│   └── memory_game.dart     # Memory game logic
├── services/                # Business logic
│   ├── pet_service.dart     # Core pet management
│   └── sound_service.dart   # Audio management
├── screens/                 # UI screens
│   ├── home_screen.dart     # Main app screen
│   └── memory_game_screen.dart # Memory game screen
└── widgets/                 # Reusable UI components
    ├── pet_display.dart     # Pet visualization
    ├── stats_grid.dart      # Stats display
    ├── action_buttons.dart  # Pet care actions
    ├── achievements_section.dart # Achievement display
    ├── message_section.dart # Messaging interface
    └── sharing_section.dart # Import/export functionality
```

## 🎵 Sound Setup (Optional)

Add sound files to `assets/sounds/` directory for enhanced experience:
- `beep.mp3` - General sound effect
- Additional specific sound files (see `assets/sounds/README.md`)

The app works perfectly without sound files - they're purely for enhancement.

## 💡 Usage Guide

### Basic Pet Care
1. **Feed** your pet when hunger is high
2. **Play** to increase happiness
3. **Clean** to maintain health
4. **Put to sleep** when energy is low

### Memory Game
- Tap cards to flip them
- Match pairs of identical symbols
- Winning increases pet's intelligence and happiness

### Partner Sharing
1. **Export** your pet data
2. Share the exported code with your partner
3. Your partner can **import** the data to sync up
4. Both partners can care for the same pet

### Achievements
- Unlock achievements by meeting specific conditions
- Track progress in the achievements section
- Celebrate milestones together!

## 🧮 Technical Details

- **State Management**: Provider pattern
- **Persistence**: SharedPreferences for local storage
- **Animations**: flutter_animate package
- **UI**: Material Design 3 with custom theming
- **Cross-platform audio**: audioplayers package

## 🔧 Development

### Adding New Features
1. Create models in `lib/models/`
2. Add business logic to `lib/services/`
3. Create UI components in `lib/widgets/`
4. Update the main screens in `lib/screens/`

### Building for Production

**Web:**
```bash
flutter build web
```

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

**Perfect for maintaining connection and shared responsibility in long-distance relationships!** 💕 