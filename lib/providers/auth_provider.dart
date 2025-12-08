import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PocketBaseAuthNotifier extends ChangeNotifier {
  final _pb = PocketBase('http://127.0.0.1:8090');

  PocketBase get pb => _pb;

  bool get isAuthenticated => _pb.authStore.isValid;
  RecordModel? get currentUser => _pb.authStore.model;

  PocketBaseAuthNotifier() {
    _pb.authStore.onChange.listen((event) {
      _saveAuth(); // Save auth state on every change
      notifyListeners(); // Notify widgets listening to this provider
    });
    _loadAuth(); // Load saved auth on initialization
  }

  /// Load saved auth from SharedPreferences
  Future<void> _loadAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('pb_auth_token');
      final modelJson = prefs.getString('pb_auth_model');

      if (token != null && modelJson != null) {
        final model = RecordModel.fromJson(jsonDecode(modelJson));
        _pb.authStore.save(token, model);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading auth: $e');
    }
  }

  /// Save current auth to SharedPreferences
  Future<void> _saveAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (_pb.authStore.isValid) {
        await prefs.setString('pb_auth_token', _pb.authStore.token);
        await prefs.setString(
          'pb_auth_model',
          jsonEncode(_pb.authStore.model.toJson()),
        );
      } else {
        await prefs.remove('pb_auth_token');
        await prefs.remove('pb_auth_model');
      }
    } catch (e) {
      print('Error saving auth: $e');
    }
  }

  Future<void> login(String email, String password) async {
    await _pb.collection('users').authWithPassword(email, password);
    // notifyListeners will be called by this.
  }

  Future<void> signUp(
    String email,
    String password,
    String passwordConfirm,
  ) async {
    final body = <String, dynamic>{
      "email": email,
      "password": password,
      "passwordConfirm": passwordConfirm,
    };
    await _pb.collection('users').create(body: body);
    // After sign up, it probably is a good idea to automatically log them in
    await login(email, password);
    // notifyListeners() will be called by authStore.onChange listener
  }

  // A test
  Future<void> updateUsername(String userId, String username) async {
    final body = <String, dynamic>{"username": username};
    await _pb.collection('users').update(userId, body: body);
    // authStore should update automatically, but refresh to be sure
    // _pb.authStore.save(token, model); // If updating locally
    notifyListeners();
  }

  Future<void> deleteAccount(String userId) async {
    await _pb.collection('users').delete(userId);
    logout();
  }

  Future<void> logout() async {
    _pb.authStore.clear();
    // Clear from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('pb_auth_token');
    await prefs.remove('pb_auth_model');
  }
}
