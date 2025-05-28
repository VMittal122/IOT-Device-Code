import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
   try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      return true;
    } catch (e) {
      print("Login failed: $e");
      return false;
      // Handle login error
    }finally {
      notifyListeners();
    }
  }

   Future<bool> signup(String email, String password, String name, String phone) async {
    try {
      final res =  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      if (res.user != null) {
        await FirebaseFirestore.instance.collection('users').doc(res.user!.uid).set({
          'email': email,
          'name': name,
          'phone': phone,
          'createdAt': Timestamp.now(),
        });
      }

      return true;
    } catch (e) {
      print("Signup failed: $e");
      return false;
    }finally {
      notifyListeners();
    }
  }

  void logout() {

    notifyListeners();
  }

}