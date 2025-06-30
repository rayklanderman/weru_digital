# 📺 Weru Digital TV App

> **Empowering, Educating, and Entertaining Our Audience**

A comprehensive Flutter mobile application that brings Weru Digital's TV programming, radio content, and news directly to your mobile device. Stream live TV content, browse programming schedules, and stay connected with quality media content.

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Play Store](https://img.shields.io/badge/Play%20Store-Ready-brightgreen.svg)](https://play.google.com/store)

## 🌟 Features

### 📺 **Live TV Streaming**
- **HD Quality Streaming:** Seamless livestream integration with OK.ru platform
- **Overlay Protection:** Custom branding overlay system to maintain brand identity
- **Responsive Player:** 16:9 aspect ratio optimized for mobile viewing
- **CORS & HTTPS Compatible:** Secure streaming with modern web standards

### 📋 **TV Programming Schedule**
- **Comprehensive Show Listings:** Detailed information for all programs
- **6 Featured Shows:**
  - **URIA NDAGITARI** - Healthcare (Mondays, 6:30-7:20 PM)
  - **GIKARO NA KAUNTY** - Influencer Profiles (Mondays, 8:15-9:00 PM)
  - **TUTHUNKUME** - Business & Entrepreneurship (Wednesdays, 6:30-7:20 PM)
  - **RIIKONE** - Culinary Arts (Schedule TBD)
  - **MURIMI CARURUKU** - Smart Agriculture (Schedule TBD)
  - **NKATHA CIETU** - Women's Empowerment (Tuesdays, 8:20-8:45 PM)

### 🎵 **Radio Integration**
- Live radio streaming capabilities
- Audio player with modern controls
- Background playback support

### 📰 **News & Content**
- RSS feed integration for latest news
- Article reading with WebView
- Content sharing functionality

### 🛡️ **Privacy-First Design**
- **Zero Data Collection:** No personal information collected
- **Local Operation:** All functionality runs locally on device
- **Transparent Privacy Policy:** Clear and honest data practices
- **Google Play Compliant:** Meets all store requirements

## 🚀 Quick Start

### Prerequisites
- Flutter 3.0+ installed
- Android Studio or VS Code
- Android SDK configured
- Git installed

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/rayklanderman/weru_digital.git
   cd weru_digital
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Release

1. **Build APK**
   ```bash
   flutter build apk --release
   ```

2. **Build App Bundle (Play Store)**
   ```bash
   flutter build appbundle --release
   ```

## 🏗️ Architecture

### 📁 Project Structure
```
lib/
├── main.dart                 # App entry point
├── pages/
│   ├── splash_page.dart     # Splash screen
│   ├── tv_page.dart         # Main TV streaming page
│   ├── radio_page.dart      # Radio streaming
│   ├── news_page.dart       # News feed
│   ├── about_page.dart      # About information
│   └── privacy_policy_page.dart
├── models/                   # Data models
├── services/                 # API services
├── theme/                    # App theming
└── widgets/                  # Reusable widgets
```

### 🔧 Key Technologies
- **Flutter Framework:** Cross-platform mobile development
- **WebView Flutter:** Embedded web content display
- **Just Audio:** Audio streaming capabilities
- **HTTP:** Network requests and API calls
- **Provider:** State management
- **Cached Network Image:** Optimized image loading

## 📱 App Screenshots

### 🎬 TV Streaming
- Live video player with custom overlays
- Professional UI with Weru Digital branding
- Responsive design for all screen sizes

### 📋 Programming Guide
- Expandable program cards with detailed information
- Host information and show descriptions
- Schedule timing and focus areas

### 🎵 Radio Player
- Modern audio controls
- Background playback support
- Real-time streaming status

## 🔐 Security & Privacy

### Privacy-First Approach
- **No Data Collection:** The app doesn't collect any personal information
- **Local Processing:** All functionality operates on-device
- **Transparent Policy:** Clear privacy policy explaining data practices
- **Third-Party Disclosure:** Honest about OK.ru integration

### Google Play Compliance
- ✅ No sensitive permissions requested
- ✅ QUERY_ALL_PACKAGES permission removed
- ✅ Privacy policy compliant
- ✅ Release signing configured

## 🛠️ Development

### Running Tests
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

### Formatting
```bash
dart format .
```

### Dependencies Update
```bash
flutter pub upgrade
```

## 📦 Dependencies

### Core Dependencies
- `flutter`: SDK framework
- `webview_flutter`: Web content integration
- `just_audio`: Audio streaming
- `http`: Network requests
- `provider`: State management
- `google_fonts`: Typography

### UI/UX Dependencies
- `cached_network_image`: Image optimization
- `flutter_html`: HTML content rendering
- `url_launcher`: External link handling
- `share_plus`: Content sharing

## 🚀 Deployment

### Google Play Store
1. **Signed AAB:** Release bundle ready for upload
2. **Privacy Policy:** Comprehensive and compliant
3. **Store Listing:** Professional presentation
4. **Version:** 3.0.1 production ready

### Release Notes - v3.0.1
- Complete TV streaming functionality
- Professional UI/UX design
- Privacy-compliant architecture
- Google Play Store ready
- Comprehensive programming schedule
- Multi-platform responsive design

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines
- Follow Flutter/Dart style guide
- Write meaningful commit messages
- Add tests for new features
- Update documentation as needed

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Contact & Support

**Weru Digital**
- **Repository:** https://github.com/rayklanderman/weru_digital
- **Issues:** https://github.com/rayklanderman/weru_digital/issues
- **Email:** [Contact Information]

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- OK.ru for livestream platform integration
- Open source community for invaluable packages
- Beta testers and early users for feedback

---

**Made with ❤️ by the Weru Digital team**

*Empowering, Educating, and Entertaining Our Audience through Quality Mobile Media*
