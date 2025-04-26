import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iot_device/create_account_page.dart';
import 'package:iot_device/firebase_options.dart';
import 'package:iot_device/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoStock',
      theme: ThemeData(useMaterial3: true),
      home: CreateAccountPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
