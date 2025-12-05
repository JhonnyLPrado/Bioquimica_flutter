import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class PocketBaseAuthNotifier extends ChangeNotifier {
  final _pb = PocketBase('http://127.0.0.1:8090');

  PocketBase get pb => _pb;

  bool get isAuthenticated => _pb.authStore.isValid;
  RecordModel? get currentUser => _pb.authStore.model;

  PocketBaseAuthNotifier() {
    _pb.authStore.onChange.listen((event) {
      notifyListeners(); // Notify widgets listening to this provider
    });
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

  void logout() {
    _pb.authStore.clear();
  }
}
