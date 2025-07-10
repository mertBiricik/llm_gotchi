# TenderTouch - Virtual Pet for Couples

A Flutter virtual pet app where couples share gentle, loving care for their digital companion across any distance.

## ✨ Recent Optimizations (v3.0)

This app has been fully optimized with the following improvements:

### 🏗️ Architecture Improvements
- **Immutable State Management**: All models are now immutable using `copyWith` patterns
- **Memory Leak Prevention**: Proper resource disposal in services and timers
- **Error Handling**: Comprehensive try-catch blocks and graceful fallbacks
- **Null Safety**: Enhanced null safety throughout the codebase

### 🚀 Performance Optimizations
- **Efficient Emoji Generation**: Removed inefficient `DateTime.now()` randomization
- **Constants for Magic Numbers**: Business logic constants extracted for maintainability
- **Optimized Widget Rebuilds**: Reduced unnecessary UI updates
- **Better JSON Serialization**: Robust data validation and type safety

### 🔧 Technical Improvements
- **Sound Service**: Graceful fallback system for missing audio assets
- **Data Persistence**: Enhanced SharedPreferences with error recovery
- **Achievement System**: Immutable achievement state management
- **Memory Game**: Complete rewrite with immutable state patterns

## Features

- 🐱 Virtual pet with multiple growth stages (egg → baby → child → adult)
- 📊 Pet stats: Health, Hunger, Happiness, Energy
- 🎮 Interactive actions: Feed, Play, Clean, Sleep
- 🧠 Memory game to increase pet intelligence
- 🏆 Achievement system with unlockable rewards
- 💌 Messaging system for sharing thoughts
- 📱 Data export/import for sharing between partners
- 🔊 Sound effects with graceful fallbacks
- 🎨 Beautiful Material 3 UI with animations

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd llm_gotchi
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Optional: Adding Sound Assets

To enhance the experience with custom sounds:

1. Add MP3 files to `assets/sounds/` directory:
   - `feed.mp3` - Feeding sound effect
   - `play.mp3` - Playing sound effect
   - `clean.mp3` - Cleaning sound effect
   - `sleep.mp3` - Sleep sound effect
   - `achievement.mp3` - Achievement unlock sound
   - `message.mp3` - Message notification sound

2. Rebuild the app to include the new assets

**Note**: The app works perfectly without sound files - it will use system sounds as fallback.

## Architecture

```
lib/
├── models/          # Immutable data models
│   ├── pet.dart           # Pet state with business logic constants
│   ├── achievement.dart   # Achievement system
│   ├── memory_game.dart   # Memory game logic
│   └── ...
├── services/        # Business logic services
│   ├── pet_service.dart   # Main pet management with proper error handling
│   └── sound_service.dart # Audio management with fallback system
├── screens/         # UI screens
├── widgets/         # Reusable UI components
└── main.dart       # App entry point
```

## Key Design Patterns

- **Immutable State**: All models use `copyWith` for safe state updates
- **Provider Pattern**: State management using Flutter Provider
- **Factory Constructors**: Safe object creation with validation
- **Error Boundaries**: Comprehensive error handling and recovery
- **Resource Management**: Proper disposal of timers and audio players

## Data Persistence

- Pet state automatically saved to device storage
- Achievement progress persisted across sessions
- Robust error recovery for corrupted data
- Export/import functionality for sharing between devices

## Contributing

1. Follow the established immutable patterns
2. Add proper error handling for all async operations
3. Include constants for any magic numbers
4. Write descriptive commit messages
5. Test on both Android and iOS if possible

## Performance Notes

- All models are optimized for minimal memory usage
- Sound system gracefully handles missing assets
- Efficient emoji randomization without performance impact
- Optimized widget rebuilds through proper state management

## Troubleshooting

### Common Issues:

**App crashes on startup**: 
- Ensure Flutter SDK is up to date
- Run `flutter clean && flutter pub get`

**No sound effects**:
- This is normal if no sound assets are provided
- App uses system sounds as fallback

**Data not persisting**:
- Check device storage permissions
- App automatically recovers from corrupted data

## License

This project is open source and available under the MIT License.

## Version History

- **v3.0.0**: Major optimization release with immutable architecture
- **v2.0.0**: Enhanced features and UI improvements  
- **v1.0.0**: Initial release with basic pet functionality 