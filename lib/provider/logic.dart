import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Helper to turn Firebase errors into readable text
String _authError(FirebaseAuthException e) {
  switch (e.code) {
    case 'email-already-in-use':
      return 'This email is already registered';
    case 'invalid-email':
      return 'Please enter a valid email';
    case 'weak-password':
      return 'Password is too weak (minimum 6 characters)';
    case 'user-not-found':
      return 'No account found with this email';
    case 'wrong-password':
    case 'invalid-credential':
      return 'Incorrect email or password';
    case 'user-disabled':
      return 'This account has been disabled';
    case 'network-request-failed':
      return 'No internet connection. Please try again';
    case 'too-many-requests':
      return 'Too many attempts. Try again later';
    default:
      return e.message ?? 'Something went wrong';
  }
}

// ===========================================================================
// SIGN UP PROVIDER
// ===========================================================================
class SignUpProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  String? validateName(String name) {
    if (name.trim().isEmpty) return 'Please enter your name';
    return null;
  }

  String? validateEmail(String email) {
    if (email.trim().isEmpty) return 'Please enter your email';
    if (!email.contains('@')) return 'Please enter a valid email';
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) return 'Please enter your password';
    if (password.length < 6) return 'Password must contain at least 6 characters';
    return null;
  }

  String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) return 'Please confirm your password';
    if (password != confirmPassword) return 'Passwords do not match';
    return null;
  }

  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await result.user!.updateDisplayName(name.trim());
      await result.user!.sendEmailVerification();

      return null; // Success
    } on FirebaseAuthException catch (e) {
      return _authError(e);
    } catch (e) {
      return 'Something went wrong. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

// ===========================================================================
// SIGN IN PROVIDER
// ===========================================================================
class SignInProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  String? validateEmail(String email) {
    if (email.trim().isEmpty) return 'Please enter your email';
    if (!email.contains('@')) return 'Please enter a valid email';
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) return 'Please enter your password';
    if (password.length < 6) return 'Password must contain at least 6 characters';
    return null;
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      return null; // Success
    } on FirebaseAuthException catch (e) {
      return _authError(e);
    } catch (e) {
      return 'Something went wrong. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}