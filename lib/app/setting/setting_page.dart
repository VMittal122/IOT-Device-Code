import 'package:flutter/material.dart';
import '../home/homepage.dart';
import '../device/add_device_page.dart';
import '../../statistics.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _currentIndex = 3;

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AddDevicePage()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StatisticsPage()));
        break;
      case 3:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AutoStock', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Settings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text("Account"),
                  subtitle: Text("Manage your account settings"),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text("Notifications"),
                  subtitle: Text("Notification preferences"),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.privacy_tip),
                  title: Text("Privacy"),
                  subtitle: Text("Privacy and security options"),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.help_outline),
                  title: Text("Help & Support"),
                  subtitle: Text("FAQs and contact support"),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Add Device'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Statistics'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
