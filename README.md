# VedicMind - Vedic Mathematics Learning App# vedic_maths



A comprehensive Flutter application for learning Vedic Mathematics through interactive lessons, practice exercises, and gamification.A new Flutter project.



## 🌟 Features## Getting Started



- **16 Vedic Sutras** with interactive step-by-step lessonsThis project is a starting point for a Flutter application.

- **Tactical Lessons** for practical applications

- **Multi-type Practice System** (Arithmetic, Sutras, Tactics, Tables)A few resources to get you started if this is your first Flutter project:

- **16 Mini-Games** - one for each sutra

- **Global Progress Tracking** across all sections- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)

- **Firebase Authentication** (Email & Google Sign-In)- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

- **History & Analytics** for all practice sessions

- **Leaderboard** systemFor help getting started with Flutter development, view the

- **Fully Responsive** design for all screen sizes[online documentation](https://docs.flutter.dev/), which offers tutorials,

- **Dark/Light Theme** supportsamples, guidance on mobile development, and a full API reference.


## 📱 Responsive Design

The app is fully responsive using the `sizer` package. See [`RESPONSIVE_DESIGN_GUIDE.md`](RESPONSIVE_DESIGN_GUIDE.md) for detailed implementation guide.

## 🚀 Getting Started

### Prerequisites
- Flutter 3.9.2 or higher
- Dart 3.9.2 or higher
- Firebase account (for authentication & database)

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd vedic_maths
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
- Add `google-services.json` to `android/app/`
- Add `GoogleService-Info.plist` to `ios/Runner/`

4. Run the app
```bash
flutter run
```

## 📚 Documentation

- **[RESPONSIVE_DESIGN_GUIDE.md](RESPONSIVE_DESIGN_GUIDE.md)** - Complete responsive design implementation
- **[DESIGN_GUIDE.md](DESIGN_GUIDE.md)** - UI/UX design specifications
- **[ALL_LESSONS_IMPLEMENTATION.md](ALL_LESSONS_IMPLEMENTATION.md)** - Lessons structure
- **[ENHANCED_PRACTICE_IMPLEMENTATION.md](ENHANCED_PRACTICE_IMPLEMENTATION.md)** - Practice system
- **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** - General implementation notes
- **[UI_CHANGES_GUIDE.md](UI_CHANGES_GUIDE.md)** - UI update history

## 🏗️ Project Structure

```
lib/
├── app/
│   ├── bindings/          # GetX dependency injection
│   ├── controllers/       # Business logic
│   ├── data/             # Models, repositories, providers
│   ├── routes/           # Navigation
│   ├── services/         # App services
│   ├── ui/               # Views, widgets, theming
│   └── utils/            # Utilities including responsive_utils.dart
└── main.dart             # App entry point

assets/
├── data/                 # JSON data
├── fonts/                # Custom fonts
└── icons/illustrations/images/  # Assets
```

## 🎨 Responsive Sizing

All UI elements use responsive units:

```dart
// Text
Text('Hello', style: TextStyle(fontSize: 16.sp));

// Containers
Container(
  width: 80.w,   // 80% of screen width
  height: 30.h,  // 30% of screen height
  padding: EdgeInsets.all(4.w),
);

// Using AppTextStyles
Text('Title', style: AppTextStyles.h1);  // Auto-responsive
```

## 🛠️ Tech Stack

- **Framework**: Flutter 3.9.2+
- **State Management**: GetX
- **Database**: Firebase Firestore
- **Authentication**: Firebase Auth
- **Local Storage**: GetStorage, SharedPreferences
- **Responsive Design**: Sizer
- **UI**: Material Design with custom theming

## 🎯 Key Features Implementation

### 1. Arithmetic Practice
- Multi-operator selection (+, −, ×, ÷)
- Random operator per question
- Customizable question count and time

### 2. Sutra & Tactics Practice
- Random questions from all topics
- 20 questions per session
- Hints system
- Progress tracking

### 3. 16 Mini-Games
- One game per sutra
- Interactive and educational
- XP and achievement system

### 4. Global Progress
- Unified tracking across Sutras, Tactics, Tables, Games
- Overall completion percentage
- Accuracy tracking
- XP system

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📦 Build

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

[Add your license here]

## 📧 Contact

[Add contact information]

---

Made with ❤️ using Flutter
