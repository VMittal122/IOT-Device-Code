import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'
    show launchUrl, canLaunchUrl, Uri;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _openAccountDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Account"),
            content: const Text("This is where you'd manage account settings."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
    );
  }

  void _openNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Notification settings coming soon!")),
    );
  }

  void _openPrivacy() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Your data is private and secure.\n\nHere you can manage your privacy and security settings.",
              style: TextStyle(fontSize: 16),
            ),
          ),
    );
  }

  void _openHelp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HelpPage()),
    );
  }

  void _openFounderInfo() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("About the Founder"),
            content: const Text(
              "AutoStock was founded by a passionate tech enthusiast aiming to revolutionize inventory and nutrition tracking.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
    );
  }

  void _openLocationSettings() async {
    final Uri uri = Uri.parse('https://maps.google.com');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open location settings.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AutoStock', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4D9BE6),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromRGBO(243, 248, 255, 1),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Settings",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text("Account"),
                  subtitle: const Text("Manage your account settings"),
                  onTap: _openAccountDialog,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text("Notifications"),
                  subtitle: const Text("Notification preferences"),
                  onTap: _openNotifications,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text("Privacy"),
                  subtitle: const Text("Privacy and security options"),
                  onTap: _openPrivacy,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text("Help & Support"),
                  subtitle: const Text("FAQs and contact support"),
                  onTap: _openHelp,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("About the Founder"),
                  subtitle: const Text("Know the mind behind AutoStock"),
                  onTap: _openFounderInfo,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text("Location Settings"),
                  subtitle: const Text("Manage location preferences"),
                  onTap: _openLocationSettings,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 🔧 Dummy Help Page
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        backgroundColor: const Color(0xFF4D9BE6),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "📧 For support, contact us:\n\nsupport@autostock.app",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
