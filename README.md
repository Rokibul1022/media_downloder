# Social Media Downloader

A modern Flutter app for downloading videos and audio from various social media platforms.

## Features

- 🎥 Download videos (.mp4) and audio (.mp3) from multiple platforms
- 🔐 User authentication with Firebase
- 📱 Support for YouTube, Facebook, Instagram, Twitter/X, TikTok, LinkedIn, Telegram, WhatsApp
- 🌙 Dark/Light mode toggle
- 📊 Download history tracking
- 🎨 Modern, elegant UI design

## Setup Instructions

### 1. Firebase Configuration
1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Authentication and Firestore Database
3. Add your Android/iOS app to the Firebase project
4. Download the configuration files:
   - `google-services.json` for Android (place in `android/app/`)
   - `GoogleService-Info.plist` for iOS (place in `ios/Runner/`)
5. Update `lib/firebase_options.dart` with your Firebase project configuration

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run the App
```bash
flutter run
```

## Tech Stack

- **Flutter** - Cross-platform mobile development
- **Firebase Auth** - User authentication
- **Cloud Firestore** - Database for user data and download history
- **Material 3** - Modern UI design system

## App Flow

1. **Home Screen** - Welcome screen with app introduction
2. **Authentication** - Login/Signup for user accounts
3. **Platform Selection** - Grid of supported social media platforms
4. **Download Screen** - URL input and format selection (video/audio)
5. **History Screen** - Track all downloaded content

## Note

This is a demonstration app. For production use, you would need to:
- Implement actual video/audio extraction APIs
- Add proper error handling and validation
- Implement real download functionality with libraries like yt-dlp
- Add proper file management and storage
- Handle platform-specific URL parsing
