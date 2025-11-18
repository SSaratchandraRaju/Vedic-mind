# Firebase Google Sign-In Setup Guide

## 🔑 Add SHA-1 Fingerprint to Firebase

### Your SHA-1 Debug Fingerprint:
```
E8:51:F0:21:46:62:C3:92:BC:DB:F6:A2:2B:55:3B:E4:BB:7B:8B:5C
```

### Your SHA-256 Fingerprint:
```
60:DA:4E:E6:01:B7:79:12:51:A9:AB:67:EE:DF:01:A4:70:23:27:12:0E:3C:10:EF:A6:9C:AB:B9:61:50:79:AA
```

---

## 📋 Steps to Add SHA-1 to Firebase Console:

1. **Open Firebase Console**
   - Go to: https://console.firebase.google.com
   - Select project: **vedicmind-4c15e**

2. **Navigate to Project Settings**
   - Click the ⚙️ (gear icon) next to "Project Overview"
   - Click "Project Settings"

3. **Select Your Android App**
   - Scroll down to "Your apps" section
   - Find your Android app: `com.vikrasoftech.vedic_maths`
   - Click on it to expand

4. **Add SHA Certificate Fingerprints**
   - Scroll to "SHA certificate fingerprints" section
   - Click "Add fingerprint"
   - Paste the SHA-1: `E8:51:F0:21:46:62:C3:92:BC:DB:F6:A2:2B:55:3B:E4:BB:7B:8B:5C`
   - Click "Save"
   
5. **Add SHA-256 (Optional but recommended)**
   - Click "Add fingerprint" again
   - Paste the SHA-256: `60:DA:4E:E6:01:B7:79:12:51:A9:AB:67:EE:DF:01:A4:70:23:27:12:0E:3C:10:EF:A6:9C:AB:B9:61:50:79:AA`
   - Click "Save"

6. **Download Updated google-services.json** (if prompted)
   - Download the new `google-services.json` file
   - Replace the existing file at: `android/app/google-services.json`

7. **Enable Google Sign-In in Firebase**
   - Go to "Authentication" in the left sidebar
   - Click "Sign-in method" tab
   - Find "Google" in the list
   - Click on it and toggle "Enable"
   - Add a project support email
   - Click "Save"

---

## 🚀 After Adding SHA-1:

1. **Stop the current Flutter app** (press `q` in terminal)
2. **Rebuild and run**:
   ```bash
   flutter clean
   flutter pub get
   flutter run -d emulator-5554
   ```

3. **Test Google Sign-In**:
   - Open the app
   - Go to Login or Signup screen
   - Click "Continue with Google"
   - Select your Google account
   - Should successfully sign in!

---

## ✅ App Navigation Flow:

```
Splash Screen (2 sec)
    ↓
First Launch?
    ├─ YES → Onboarding (3 pages) → Login Screen
    └─ NO → Already logged in?
            ├─ YES → Home Screen
            └─ NO → Login Screen
```

---

## 🔐 Available Authentication Methods:

1. **Email/Password**
   - Sign up with email, password, and confirm password
   - Login with email and password

2. **Google Sign-In**
   - One-tap sign in with Google account
   - Available on both Login and Signup screens

3. **Phone OTP**
   - Enter phone number (+91 format)
   - Receive 6-digit OTP
   - Verify OTP to login

---

## 📝 Notes:

- Onboarding screens will only appear once (stored in SharedPreferences)
- All auth states are managed by Firebase Auth
- After successful login, user goes to Home screen
- Logout functionality available in auth controller

---

## 🐛 Troubleshooting:

If Google Sign-In still doesn't work after adding SHA-1:

1. **Check Firebase Console**:
   - Verify SHA-1 is added correctly
   - Ensure Google Sign-In is enabled in Authentication

2. **Rebuild the app**:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

3. **Check for errors**:
   - Look for any Firebase-related errors in console
   - Verify `google-services.json` is in correct location

4. **For Release Build**:
   - You'll need to add your release keystore SHA-1 as well
   - Get it using:
     ```bash
     keytool -list -v -keystore /path/to/release.keystore -alias your-key-alias
     ```

---

## 📱 Project Details:

- **Firebase Project**: vedicmind-4c15e
- **Android Package**: com.vikrasoftech.vedic_maths
- **iOS Bundle ID**: com.example.vedicMaths
- **Firebase App IDs**:
  - Android: `1:360187297494:android:ed3c392bf58faaf1dad377`
  - iOS: `1:360187297494:ios:04b20729c9f1ef18dad377`
