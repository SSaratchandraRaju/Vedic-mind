# VedicMind - Complete Setup & Testing Guide

## ✅ Completed Setup

### 1. Firebase Configuration
- ✅ Project: `vedicmind-4c15e`
- ✅ Android app registered: `com.vikrasoftech.vedic_maths`
- ✅ iOS app registered: `com.example.vedicMaths`
- ✅ `firebase_options.dart` generated
- ✅ Google Services plugin configured
- ✅ Internet permissions added to AndroidManifest.xml

### 2. Authentication Methods Implemented
- ✅ Email/Password Signup & Login
- ✅ Google Sign-In (OAuth)
- ✅ Phone OTP Verification

### 3. All Screens Created
- ✅ Splash Screen (with auto-routing logic)
- ✅ Onboarding (3 pages, shows only once)
- ✅ Login Screen
- ✅ Signup Screen
- ✅ OTP Verification Screen
- ✅ Home Screen
- ✅ Math Tables Screen
- ✅ Section Detail Screen
- ✅ Leaderboard Screen
- ✅ Practice Modal

### 4. Navigation Flow Fixed
```
App Launch
    ↓
Splash Screen (checks preferences & Firebase auth)
    ↓
    ├─ First time user → Onboarding (3 pages) → Login
    ├─ Returning user, not logged in → Login
    └─ Logged in user → Home
```

---

## 🔐 Firebase Authentication Setup Required

### Step 1: Add SHA-1 Fingerprint

Your debug SHA-1:
```
E8:51:F0:21:46:62:C3:92:BC:DB:F6:A2:2B:55:3B:E4:BB:7B:8B:5C
```

**To add to Firebase:**
1. Go to https://console.firebase.google.com
2. Select project: **vedicmind-4c15e**
3. Click ⚙️ → Project Settings
4. Scroll to "Your apps" → Select Android app
5. Click "Add fingerprint" under "SHA certificate fingerprints"
6. Paste: `E8:51:F0:21:46:62:C3:92:BC:DB:F6:A2:2B:55:3B:E4:BB:7B:8B:5C`
7. Click "Save"

### Step 2: Enable Authentication Methods

**Go to Firebase Console → Authentication → Sign-in method:**

1. **Email/Password**
   - Toggle "Enable"
   - Save

2. **Google Sign-In**
   - Toggle "Enable"
   - Add support email: `ssaratchandraraju@gmail.com`
   - Save

3. **Phone (Optional)**
   - Toggle "Enable"
   - Add test phone numbers if needed
   - Save

---

## 🧪 Testing Guide

### Test 1: Onboarding Flow
1. **First Launch:**
   - App should show Splash → Onboarding (3 pages)
   - Swipe through pages or click "Next"
   - Last page → Navigates to Login screen

2. **Second Launch:**
   - App should show Splash → Login (skips onboarding)
   - Onboarding only shows once ✅

### Test 2: Email/Password Signup
1. Click "Sign Up" on login screen
2. Enter email, password, confirm password
3. Click "Sign Up"
4. Should create account and navigate to Home

**Expected Result:** User created in Firebase Authentication

### Test 3: Email/Password Login
1. On login screen, enter credentials
2. Click "Login"
3. Should navigate to Home

**Expected Result:** Successfully logged in

### Test 4: Google Sign-In
⚠️ **Requires SHA-1 added to Firebase (see Step 1 above)**

1. Click "Continue with Google"
2. Select Google account
3. Should navigate to Home

**Expected Result:** User signed in with Google account

### Test 5: Phone OTP
1. Select "Phone" tab on signup/login
2. Enter phone number (e.g., +91 1234567890)
3. Click "Send OTP"
4. Enter 6-digit OTP
5. Click "Done"

**Expected Result:** User logged in with phone

---

## 🐛 Troubleshooting

### Google Sign-In Not Working
**Problem:** Google Sign-In fails or doesn't show accounts

**Solution:**
1. ✅ Verify SHA-1 is added to Firebase (see Step 1)
2. ✅ Verify Google Sign-In is enabled in Firebase Authentication
3. Run: `flutter clean && flutter pub get && flutter run`
4. Try again

### Network Errors
**Problem:** "Unable to resolve host" errors

**Solution:**
1. ✅ Internet permissions added to AndroidManifest.xml
2. Check emulator has working internet:
   ```bash
   adb shell ping -c 3 google.com
   ```
3. If needed, restart emulator:
   ```bash
   flutter emulators --launch Pixel_9a
   ```

### Phone OTP Not Working
**Problem:** OTP not received or verification fails

**Solution:**
1. Enable Phone authentication in Firebase Console
2. Add test phone numbers in Firebase (for testing)
3. For production, configure reCAPTCHA settings

### Onboarding Shows Every Time
**Problem:** Onboarding appears on every app launch

**Solution:**
- ✅ Fixed! Using SharedPreferences to save completion state
- Should only show once now

---

## 📱 App Flow Summary

### First-Time User Journey
```
1. Splash Screen (2 sec)
2. Onboarding Page 1 → Page 2 → Page 3
3. Login/Signup Screen
4. Choose authentication method:
   - Email/Password
   - Google Sign-In
   - Phone OTP
5. Home Screen (after successful auth)
```

### Returning User Journey (Not Logged In)
```
1. Splash Screen (2 sec)
2. Login Screen (onboarding skipped)
3. Login
4. Home Screen
```

### Logged-In User Journey
```
1. Splash Screen (2 sec)
2. Home Screen (direct)
```

---

## 🎨 Design System

### Colors
- **Primary:** #5B7FFF (Blue)
- **Secondary:** #FFA726 (Orange)
- **Accent:** #FFB020 (Yellow)
- **Background:** #F7F8FA (Light Gray)
- **Text Primary:** #1A1A1A
- **Text Secondary:** #6B7280

### Typography
- Headings: Bold, large sizes
- Body: Regular weight
- Labels: Medium weight, smaller sizes

---

## 📦 Dependencies

### Core
- `get: ^4.6.6` - State management & routing
- `firebase_core: ^3.6.0` - Firebase initialization
- `firebase_auth: ^5.3.1` - Authentication
- `google_sign_in: ^6.2.1` - Google OAuth
- `pinput: ^5.0.0` - OTP PIN input
- `shared_preferences: ^2.2.2` - Local storage

### UI
- `google_fonts: ^6.1.0` - Typography
- `flutter_svg: ^2.0.7` - SVG support
- `lottie: ^3.0.0` - Animations

---

## 🚀 Next Steps

1. **Complete Firebase Setup** (30 min)
   - [ ] Add SHA-1 fingerprint
   - [ ] Enable Email/Password auth
   - [ ] Enable Google Sign-In
   - [ ] Enable Phone auth (optional)

2. **Test All Flows** (30 min)
   - [ ] Test onboarding (first launch only)
   - [ ] Test email/password signup
   - [ ] Test email/password login
   - [ ] Test Google Sign-In
   - [ ] Test phone OTP

3. **Build Remaining Features**
   - [ ] Complete Home screen functionality
   - [ ] Implement Math Tables lessons
   - [ ] Create quiz/practice system
   - [ ] Add progress tracking
   - [ ] Build leaderboard backend

4. **Additional Screens**
   - [ ] Profile/Settings screen
   - [ ] Notifications screen
   - [ ] History/Progress screen
   - [ ] Detailed lesson screens

---

## 📞 Support

If you encounter issues:
1. Check this guide's Troubleshooting section
2. Review Firebase Console for errors
3. Check Flutter logs: `flutter logs`
4. Verify all dependencies: `flutter pub get`

---

## ✨ Current Status

**All Authentication Infrastructure Complete! 🎉**

- ✅ Firebase configured
- ✅ 3 auth methods ready
- ✅ Onboarding flow working
- ✅ Navigation logic implemented
- ✅ All auth screens designed
- ✅ Network permissions added

**Ready to test after adding SHA-1 to Firebase!**
