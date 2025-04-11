import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Set onboarding status to false for new users
      await _setOnboardingStatus(userCredential.user!.uid, false);
      print('New user registered with uid: ${userCredential.user!.uid}');
      return userCredential;
    } catch (e) {
      print('Error in registerWithEmailAndPassword: $e');
      throw _handleAuthException(e);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google sign in aborted');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // Check if this is a new user
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        print('New Google user with uid: ${userCredential.user!.uid}');
        await _setOnboardingStatus(userCredential.user!.uid, false);
      }
      return userCredential;
    } catch (e) {
      print('Error in signInWithGoogle: $e');
      throw _handleAuthException(e);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> _setOnboardingStatus(String uid, bool status) async {
    try {
      print('Setting onboarding status for user $uid to $status');
      final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);

      // First check if the document exists
      final docSnapshot = await userDoc.get();
      if (!docSnapshot.exists) {
        print('Creating new user document');
        await userDoc.set({
          'hasCompletedOnboarding': status,
          'createdAt': FieldValue.serverTimestamp(),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        print('Updating existing user document');
        await userDoc.update({
          'hasCompletedOnboarding': status,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
      print('Onboarding status set successfully');
    } catch (e) {
      print('Error setting onboarding status: $e');
      rethrow;
    }
  }

  Exception _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return Exception('No user found with this email.');
        case 'wrong-password':
          return Exception('Wrong password provided.');
        case 'email-already-in-use':
          return Exception('Email is already in use.');
        case 'invalid-email':
          return Exception('Invalid email address.');
        case 'weak-password':
          return Exception('Password is too weak.');
        case 'operation-not-allowed':
          return Exception('Operation not allowed.');
        default:
          return Exception('Authentication failed: ${e.message}');
      }
    }
    return Exception('An unexpected error occurred.');
  }
}
