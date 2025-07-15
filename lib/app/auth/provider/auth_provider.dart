import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      _error = e.message;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signup(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (res.user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(res.user!.uid)
            .set({
              'email': email,
              'name': name,
              'phone': phone,
              'createdAt': Timestamp.now(),
            });
        return true;
      }

      return false;
    } on FirebaseAuthException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
