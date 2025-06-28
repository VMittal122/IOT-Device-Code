import 'package:flutter/material.dart';
import 'package:iot_device/app/auth/statistics/provider/statistics_provider.dart';
import 'package:provider/provider.dart';
import '../../home/homepage.dart';
import '../../device/add_device_page.dart';
import '../../setting/setting_page.dart';
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
      body: Column(
        children: [
          const Center(
            child: Text(
              'Statistics Page Content Here',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await context.read<StatisticsProvider>().generateStatistics('''
                  {
                  "items": [
                      {
                        "name": "Apple",
                        "weight_grams": 150,
                      },
                      {
                        "name": "Banana",
                        "weight_grams": 120,
                      },
                      {
                        "name": "Chicken breast",
                        "weight_grams": 200,
                      },
                  }
''');
            },
            child: Text('Click Me'),
          ),
        ],
      ),
    );
  }
}
