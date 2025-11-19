import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// TODO: Uncomment when Firestore billing is enabled
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth_data_source.dart';
import '../../models/user_model.dart';
import '../../models/auth_result_model.dart';

/// Firebase implementation of AuthDataSource
/// This can be easily replaced with other implementations (MongoDB, REST API, etc.)
/// 
/// NOTE: Firestore is currently disabled (commented out) to avoid billing requirements.
/// To enable Firestore:
/// 1. Enable billing in Firebase Console
/// 2. Create Firestore database
/// 3. Uncomment all lines marked with "// FIRESTORE:"
/// 4. Hot restart the app
class FirebaseAuthDataSource implements AuthDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  // FIRESTORE: Uncomment when billing is enabled
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  @override
  Future<AuthResultModel> signInWithGoogle() async {
    try {
      // Trigger the Google Sign In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return AuthResultModel.failure('Google sign in cancelled');
      }
      
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      // Create or update user in Firestore
      final user = await _createOrUpdateUser(userCredential.user!);
      
      return AuthResultModel.success(user);
    } catch (e) {
      return AuthResultModel.failure('Failed to sign in with Google: ${e.toString()}');
    }
  }
  
  @override
  Future<AuthResultModel> signInWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = await _createOrUpdateUser(userCredential.user!);
      return AuthResultModel.success(user);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        default:
          errorMessage = 'Failed to sign in: ${e.message}';
      }
      return AuthResultModel.failure(errorMessage);
    } catch (e) {
      return AuthResultModel.failure('An error occurred: ${e.toString()}');
    }
  }
  
  @override
  Future<AuthResultModel> signUpWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = await _createOrUpdateUser(userCredential.user!);
      return AuthResultModel.success(user);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password is too weak';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists with this email';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        default:
          errorMessage = 'Failed to create account: ${e.message}';
      }
      return AuthResultModel.failure(errorMessage);
    } catch (e) {
      return AuthResultModel.failure('An error occurred: ${e.toString()}');
    }
  }
  
  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }
  
  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final User? firebaseUser = _auth.currentUser;
      
      if (firebaseUser == null) {
        return null;
      }
      
      // FIRESTORE: Uncomment to get user data from Firestore
      // final docSnapshot = await _firestore
      //     .collection('users')
      //     .doc(firebaseUser.uid)
      //     .get();
      // 
      // if (docSnapshot.exists) {
      //   return UserModel.fromJson({
      //     ...docSnapshot.data()!,
      //     'id': firebaseUser.uid,
      //   });
      // }
      // 
      // // If not in Firestore, create from Firebase user
      // return _createOrUpdateUser(firebaseUser);
      
      // TEMPORARY: Create user from Firebase Auth data only (without Firestore)
      return UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email!,
        displayName: firebaseUser.displayName,
        photoUrl: firebaseUser.photoURL,
        createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
        lastLoginAt: firebaseUser.metadata.lastSignInTime,
      );
    } catch (e) {
      throw Exception('Failed to get current user: ${e.toString()}');
    }
  }
  
  @override
  Future<bool> isAuthenticated() async {
    return _auth.currentUser != null;
  }
  
  @override
  Future<bool> updateUserProfile(UserModel user) async {
    try {
      // Update Firebase Auth profile
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.updateDisplayName(user.displayName);
        if (user.photoUrl != null) {
          await currentUser.updatePhotoURL(user.photoUrl);
        }
      }
      
      // FIRESTORE: Uncomment to update user data in Firestore
      // final updateData = {
      //   'displayName': user.displayName,
      //   'photoUrl': user.photoUrl,
      //   'ageCategory': user.ageCategory,
      // };
      // 
      // await _firestore
      //     .collection('users')
      //     .doc(currentUser!.uid)
      //     .update(updateData);
      
      // Note: Additional data (like ageCategory) can be stored in SharedPreferences
      // since Firestore is not available
      return true;
    } catch (e) {
      return false;
    }
  }
  
  @override
  Future<bool> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // FIRESTORE: Uncomment to delete user data from Firestore
        // await _firestore
        //     .collection('users')
        //     .doc(user.uid)
        //     .delete();
        
        // Delete Firebase Auth account
        await user.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  @override
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Helper method to create or update user
  Future<UserModel> _createOrUpdateUser(User firebaseUser) async {
    final now = DateTime.now();
    
    // FIRESTORE: Uncomment to create/update user in Firestore
    // final userRef = _firestore.collection('users').doc(firebaseUser.uid);
    // final docSnapshot = await userRef.get();
    // 
    // if (docSnapshot.exists) {
    //   // Update existing user
    //   await userRef.update({
    //     'lastLoginAt': now.toIso8601String(),
    //   });
    //   
    //   return UserModel.fromJson({
    //     ...docSnapshot.data()!,
    //     'id': firebaseUser.uid,
    //   });
    // } else {
    //   // Create new user
    //   final userData = {
    //     'email': firebaseUser.email!,
    //     'displayName': firebaseUser.displayName,
    //     'photoUrl': firebaseUser.photoURL,
    //     'createdAt': now.toIso8601String(),
    //     'lastLoginAt': now.toIso8601String(),
    //   };
    //   
    //   await userRef.set(userData);
    //   
    //   return UserModel.fromJson({
    //     ...userData,
    //     'id': firebaseUser.uid,
    //   });
    // }
    
    // TEMPORARY: Create user from Firebase Auth data only (without Firestore)
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email!,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      createdAt: firebaseUser.metadata.creationTime ?? now,
      lastLoginAt: now,
    );
  }
}
