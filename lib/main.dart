import 'package:flutter/material.dart';
import 'package:iot_device/create_account_page.dart';
import 'package:iot_device/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoStock',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home:  CreateAccountPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

