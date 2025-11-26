# VedicMind - Vedic Mathematics Learning App# vedicmind



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
cd vedicmind
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

## Phone Auth & App Check Setup

Follow these steps to resolve `Invalid app info in play_integrity_token (17028)` and App Check placeholder token warnings when using Firebase Phone Authentication:

### 1. Add Signing Certificate Fingerprints
Run the following to get debug SHA-1 and SHA-256:

```bash
keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android -keypass android | grep -E "SHA1:|SHA-256:"
```
If you have a release keystore:
```bash
keytool -list -v -keystore /absolute/path/to/release.keystore -alias <alias>
```
Add both SHA-1 and SHA-256 to Firebase Console: Project Settings > Android app (com.vikrasoftech.vedicmind).

### 2. Enable Play Integrity API
In Google Cloud Console enable "Play Integrity API" for the linked project. Wait a few minutes.

### 3. Refresh Config Files
Download updated `google-services.json` after adding fingerprints and replace `android/app/google-services.json`.
Regenerate `firebase_options.dart`:
```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=vedic-maths-d7d74 --android-package-name=com.vikrasoftech.vedicmind
```

### 4. Clean & Rebuild
```bash
flutter clean
flutter pub get
flutter run
```

### 5. (Optional) Configure reCAPTCHA Enterprise
In Firebase Console > Authentication > Phone, enable reCAPTCHA Enterprise (auto-provision). Enable API in Google Cloud if prompted.

### 6. App Check Activation
In Firebase Console > App Check: Enable Play Integrity for Android, create a debug token if desired. Then in `lib/main.dart` App Check is activated:
```dart
await FirebaseAppCheck.instance.activate(androidProvider: AndroidProvider.playIntegrity);
```
For a debug token:
```bash
export FIREBASE_APP_CHECK_DEBUG_TOKEN=YOUR_DEBUG_TOKEN
flutter run
```

### 7. Verify
Observe logcat: Phone Auth should proceed without 17028. If still failing verify:
- SHA-256 fingerprint present
- Using a device/emulator with Google Play Services
- Play Integrity API enabled
- Latest `google-services.json` in place

### 8. Troubleshooting Quick List
| Issue | Action |
|-------|--------|
| 17028 persists | Re-download config, confirm fingerprints, enable API, wait propagation |
| Placeholder App Check token | Activate provider + debug token or disable enforcement |
| reCAPTCHA site key warning | Enable Enterprise or ignore if flow still works |

### 9. Resolving Dual Play Integrity Project Numbers
If logcat shows alternating `cloudProjectNumber` values (e.g. your valid one `1057656790392` and a stale one like `551503664846`), Firebase Phone Auth attestation will intermittently fail with 17028.

Steps:
1. Confirm Correct Project: The project number in `firebase_options.dart` (derived from `google-services.json`) must match the one shown as valid in your logs.
2. Remove Stale App Association: A previous Firebase project or test app may still be cached in Google Play Services.
  - Uninstall the app from the device.
  - Settings > Apps > Google Play Services: Storage > Clear Cache (avoid clearing all data unless needed).
  - Reboot device.
3. Rebuild With Fresh Config: Ensure the latest `google-services.json` is present; run `flutter clean && flutter pub get && flutter run`.
4. Release Keystore Consistency: If you signed a prior test build with a different keystore, add its SHA-1 & SHA-256 to the current Firebase project OR migrate fully to the new keystore and remove old fingerprints from the old project.
5. Package Name Uniqueness: If conflicts persist, create a dev flavor with a distinct `applicationId` (e.g. `com.vikrasoftech.vedicmind.devtest`) and register it as a separate Android app in the same Firebase project; this flushes stale Integrity state.
6. Propagation Window: Allow ~5–15 minutes after adding fingerprints / enabling APIs before retesting.

Verification: After these steps only the correct `cloudProjectNumber` should appear; 17028 errors should disappear (assuming fingerprints are correct).

### 10. Production Security Guidance
Never ship a production build with `appVerificationDisabledForTesting: true` or a permanently accepted debug App Check token.

Recommended hardening:
1. Guard Test Bypass:
  ```dart
  import 'package:flutter/foundation.dart';
  if (kDebugMode) {
    FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
  }
  ```
  (Using an `assert` already strips it out of release; explicit guard improves clarity.)
2. App Check Enforcement:
  - After verifying stability, enable enforcement in Firebase Console > App Check so requests without valid tokens are rejected.
3. Debug Tokens Rotation:
  - Use temporary debug tokens; revoke them when a developer leaves or a device is lost.
4. ReCAPTCHA Enterprise:
  - Enable to reduce visible browser challenges and leverage risk analysis.
5. Rate Limiting:
  - Keep server-side monitoring (Cloud Logging / BigQuery export) to detect abnormal OTP request spikes.
6. Release Signing:
  - Add release keystore SHA-1 & SHA-256 before first production rollout to avoid integrity mismatches.
7. Monitoring:
  - Set up Firebase Authentication usage alerts and App Check metrics dashboards.
8. Privacy / PII:
  - Avoid logging full phone numbers—log masked versions (`+91******1526`) in production.

Checklist Before Release:
| Item | Status |
|------|--------|
| SHA-1 & SHA-256 (debug + release) | ✅ |
| Single project number in logs | ✅ (verify) |
| App Check token (no placeholder) | ✅ |
| No test bypass present | ✅ |
| reCAPTCHA Enterprise enabled (optional but recommended) | ✅/N/A |
| Rate limit functioning (no 17010 spam) | ✅ |
| Masked logging | ✅ |

### 11. Common Error Codes Reference (Phone Auth)
| Code | Meaning | Typical Fix |
|------|---------|-------------|
| 17010 | Too many attempts | Add client throttle + wait cooldown | 
| 17028 | Invalid app info / integrity | Correct fingerprints, ensure single project number |
| 17042 | Invalid phone number format | Normalize to E.164 (`+<country><number>`) |
| 403 App attestation failed | Play Integrity not passing | Enable API, wait propagation, ensure device not rooted |
| Placeholder App Check token | Token retrieval failed | Activate App Check, provide debug token during dev |

## Email Verification Flow

When a user signs up with email/password, the app automatically triggers a Firebase email verification send. The user must click the link before being treated as fully verified (you can gate certain features).

### Code Path
Method `signUpWithEmailPassword` in `firebase_auth_data_source.dart` calls:
```dart
if (createdUser != null && !createdUser.emailVerified) {
  await createdUser.sendEmailVerification();
}
```

Helpers added:
```dart
Future<bool> sendEmailVerification();            // Resend link
Future<bool> isEmailVerified();                  // Reload & check
Future<bool> resendEmailVerificationIfUnverified();
```

### UI Recommendations
Route: `Routes.VERIFY_EMAIL` (string `/verify-email`)
Controller: `VerifyEmailController` (polls every 12s, 45s resend cooldown)
1. After signup, navigate to a "Verify Email" screen showing masked email and a "Resend" button.
2. Poll `isEmailVerified()` every 10–15 seconds or add a manual "I've Verified" button.
3. Once verified, proceed to onboarding/dashboard.

### Resend Limits (Best Practice)
Implement a local cooldown (e.g. 30–60s) for resend to avoid abuse:
```dart
DateTime? _lastEmailVerificationSent;
const _emailVerificationCooldown = Duration(seconds: 45);
bool canResend() => _lastEmailVerificationSent == null ||
  DateTime.now().difference(_lastEmailVerificationSent!) > _emailVerificationCooldown;
```

### Optional: Custom Numeric Email OTP (If You Want Inline Verification)
Not required since Firebase handles email ownership, but if you want a 6-digit code UX:
1. Generate secure code: `final code = (Random.secure().nextInt(900000) + 100000).toString();`
2. Store hash + expiry in Firestore: `email_verification/{uid}` with fields `{ codeHash, expiresAt }`.
3. Send email via Cloud Function (Trigger HTTPS callable or Firestore onCreate) using a provider like SendGrid/SES.
4. User enters code; hash compare + expiry check; mark verified or delete doc.
5. Still keep Firebase's native verification to stay aligned with Auth emailVerified flag OR simulate by calling Admin SDK to mark verified (requires trusted backend).

### Security Notes
- Do NOT mark a user verified client-side without confirming `emailVerified` after `reload()`.
- Mask email in logs: `user@example.com` -> `u***@example.com`.
- Rate limit resend operations to deter enumeration or spam.

### Future Enhancements
- Add flavor-based restriction: only allow auto-poll in dev; manual refresh in prod.
- Telemetry: log first verification latency (signup -> emailVerified timestamp).
 - Combine phone & email status page if multi-channel verification added.


