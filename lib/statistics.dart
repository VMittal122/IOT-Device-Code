import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChartPage extends StatelessWidget {
  ChartPage({super.key});

  List<Map<String, dynamic>> get data => [
        {'time': DateTime.now().subtract(Duration(minutes: 5)), 'temperature': 22, 'humidity': 60, 'light': 200},
        {'time': DateTime.now().subtract(Duration(minutes: 4)), 'temperature': 23, 'humidity': 62, 'light': 210},
        {'time': DateTime.now().subtract(Duration(minutes: 3)), 'temperature': 24, 'humidity': 64, 'light': 230},
        {'time': DateTime.now().subtract(Duration(minutes: 2)), 'temperature': 25, 'humidity': 63, 'light': 220},
        {'time': DateTime.now().subtract(Duration(minutes: 1)), 'temperature': 26, 'humidity': 65, 'light': 240},
      ];

  List<FlSpot> _getSpots(String key) {
    return List.generate(
      data.length,
      (index) => FlSpot(index.toDouble(), data[index][key].toDouble()),
    );
  }

  Widget _buildChart(String title, List<FlSpot> spots, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < data.length) {
                            final time = data[value.toInt()]['time'] as DateTime;
                            return Text(DateFormat.Hm().format(time),
                                style: const TextStyle(fontSize: 10));
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: color,
                      barWidth: 3,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Module Statistics')),
      body: ListView(
        children: [
          _buildChart("Temperature", _getSpots('temperature'), Colors.red),
          _buildChart("Humidity", _getSpots('humidity'), Colors.blue),
          _buildChart("Light", _getSpots('light'), Colors.amber),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          // TODO: Handle navigation
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
