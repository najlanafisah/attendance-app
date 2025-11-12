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
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async { // pake async karena ada proses tunggu2an
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
    } catch (e) {
      rethrow; // ini biar balik lagi
    }
  }

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
    } catch (e) {
      if (e is FirebaseAuthException) { // kalo misalnya error dari firebase
        if (e.code == 'operation-not-allowed') {
          throw 'Email/password sign up is not enabled. Please enable on firebase console';
        }
      }
      rethrow;
    }
  }

  // Sign Out
  Future<void>signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}