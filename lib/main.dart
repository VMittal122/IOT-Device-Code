import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iot_device/app/auth/provider/auth_provider.dart';
import 'package:iot_device/app/statistics/provider/statistics_provider.dart';
import 'package:iot_device/app/bottom_navigation/bottom_navigation.dart';
import 'package:iot_device/app/device/add_device_page.dart';
import 'package:iot_device/app/auth/provider/create_account_page.dart';
import 'package:iot_device/firebase_options.dart';
import 'package:iot_device/flashpage.dart';
import 'package:iot_device/app/home/homepage.dart';
import 'package:iot_device/app/statistics/statistics.dart';
import 'package:iot_device/app/auth/provider/login.dart';
import 'package:provider/provider.dart'; // Only used import

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StatisticsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoStock',
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), //Make sure this is const
    );
  }
}
