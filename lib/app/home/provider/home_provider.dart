import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class HomeProvider with ChangeNotifier {
  getDevices() async {
    final res =
        await FirebaseFirestore.instance
            .collection('devices')
            // .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get();
  }
}
