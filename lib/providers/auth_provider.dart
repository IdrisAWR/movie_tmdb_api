import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  // Konstruktor: Langsung dengarkan perubahan status login dari Firebase
  AuthProvider() {
    _authService.user.listen((User? newUser) {
      _user = newUser;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signIn(email, password);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow; // Lempar error ke UI agar bisa muncul Snackbar/Alert
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signUp(email, password);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}