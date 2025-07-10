# Sound Assets

This directory contains sound files for the LDR Gotchi app.

## Expected Sound Files

The app expects the following sound files (all in MP3 format):

- `feed.mp3` - Sound played when feeding the pet
- `play.mp3` - Sound played when playing with the pet  
- `clean.mp3` - Sound played when cleaning the pet
- `sleep.mp3` - Sound played when putting pet to sleep
- `achievement.mp3` - Sound played when unlocking achievements
- `message.mp3` - Sound played when sending messages

## Fallback System

If sound files are not present, the app will gracefully fallback to:
1. System sounds (click/tap feedback)
2. Silent operation if system sounds are unavailable

## Adding Sound Files

To add custom sounds:
1. Place MP3 files in this directory with the exact names listed above
2. Ensure the pubspec.yaml file includes this directory in assets
3. Rebuild the app to include the new assets

## File Requirements

- Format: MP3
- Duration: 0.5-2 seconds recommended
- Size: Keep under 100KB per file for optimal performance
- Quality: 44.1kHz, 128kbps recommended 