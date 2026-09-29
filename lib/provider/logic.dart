
import 'package:flutter/material.dart';

class SignUpProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  String? validateName(String name) {
    if (name.trim().isEmpty) {
      return 'Please enter your name';
    }

    return null;
  }

  String? validateEmail(String email) {
    if (email.trim().isEmpty) {
      return 'Please enter your email';
    }

    if (!email.contains('@')) {
      return 'Please enter a valid email';
    }

    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Please enter your password';
    }

    if (password.length < 6) {
      return 'Password must contain at least 6 characters';
    }

    return null;
  }

  String? validateConfirmPassword(
    String password,
    String confirmPassword,
  ) {
    if (confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}

