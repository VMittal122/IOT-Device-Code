import 'package:flutter/material.dart';
import 'app/home/homepage.dart';
import 'app/device/add_device_page.dart';
import 'app/setting/setting_page.dart';
import 'statistics.dart'; // Import itself for consistency

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4D9BE6),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'AutoStock',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'Statistics Page Content Here',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
        ),
      ),
    );
  }
}
