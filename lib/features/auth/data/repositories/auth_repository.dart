import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sole_space_user1/features/auth/data/model/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> addUserToFirestore(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      throw Exception('Failed to add user: $e');
    }
  }

  Future<UserModel> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        throw Exception('User not found');
      }
      final data = doc.data();
      if (data == null) {
        throw Exception('User data is null');
      }
      return UserModel.fromMap(data);
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  Future<void> updateUserData(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());
    } catch (e) {
      throw Exception('Failed to update user data: $e');
    }
  }

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
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      // First sign out from Google to ensure clean state
      // await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google sign in aborted');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign out from Firebase before signing in with new credentials
      await _auth.signOut();

      return await _auth.signInWithCredential(credential);
    } catch (e) {
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
      // Sign out from both Firebase and Google
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);

      // Clear any cached data
      await _googleSignIn.disconnect();
    } catch (e) {
      throw _handleAuthException(e);
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
        case 'network-request-failed':
          return Exception(
            'Network error. Please check your internet connection.',
          );
        case 'too-many-requests':
          return Exception('Too many attempts. Please try again later.');
        case 'user-disabled':
          return Exception('This account has been disabled.');
        case 'invalid-verification-code':
          return Exception('Invalid verification code.');
        case 'invalid-verification-id':
          return Exception('Invalid verification ID.');
        case 'session-expired':
          return Exception('Session expired. Please sign in again.');
        default:
          return Exception('Authentication failed: ${e.message}');
      }
    } else if (e is FirebaseException) {
      return Exception('Firebase error: ${e.message}');
    } else if (e is Exception) {
      return e;
    }
    return Exception('An unexpected error occurred: ${e.toString()}');
  }
}
