import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthServices() {
    if (!kIsWeb) { // only for Android / IOS
      FirebaseAuth.instance.setSettings(
        appVerificationDisabledForTesting: true,
        forceRecaptchaFlow: false,
      );
    }
  }

  // For get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream (biar sekali login dan ga pelu login berkali kali)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign In with Email and Password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
    } catch (e) {
      rethrow; // ini biar balik lagi
    }
  }
}