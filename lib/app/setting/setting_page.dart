import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iot_device/app/setting/account_settings_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _openLocation() async {
    final Uri url = Uri.parse('https://maps.google.com');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _showPrivacySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Your data is securely stored and encrypted. '
              'You can adjust permissions and data settings from your device settings.',
              style: TextStyle(fontSize: 16),
            ),
          ),
    );
  }

  void _showFounderInfo(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('About the Founder'),
            content: const Text(
              'AutoStock was created by a passionate engineer dedicated to empowering smart food management and sustainability.',
            ),
            actions: [
              TextButton(
                child: const Text('Close'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  void _showHelpPopup(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              "Help & Support",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF4D9BE6),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                ListTile(
                  leading: Icon(Icons.email, color: Colors.blue),
                  title: Text("support@autostock.app"),
                  subtitle: Text("Email us your queries"),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.phone, color: Colors.green),
                  title: Text("+91 9876543210"),
                  subtitle: Text("Mon–Fri, 10AM–6PM"),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "Our team will get back to you within 24–48 hours.",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Close",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
    );
  }

  void _navigateToAccountPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AccountSettingsPage()),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Confirm Logout"),
            content: const Text("Are you sure you want to log out?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await FirebaseAuth.instance.signOut();
                  await Future.delayed(const Duration(milliseconds: 100));
                  if (!mounted) return;
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/login', (route) => false);
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Delete Account"),
            content: const Text(
              "Are you sure you want to delete your account?\n\n"
              "This action is irreversible and your data will be permanently removed.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    final uid = user.uid;
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .delete();
                    await user.delete();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Account deleted successfully"),
                      ),
                    );
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/login', (route) => false);
                  }
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

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
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
                  subtitle: const Text("Manage your personal information"),
                  onTap: () => _navigateToAccountPage(context),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text("Notifications"),
                  subtitle: const Text("Set your notification preferences"),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Coming soon!")),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text("Privacy"),
                  subtitle: const Text("Privacy and security options"),
                  onTap: () => _showPrivacySheet(context),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text("Help & Support"),
                  subtitle: const Text("FAQs and contact options"),
                  onTap: () => _showHelpPopup(context),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text("About the Founder"),
                  subtitle: const Text("Meet the creator of AutoStock"),
                  onTap: () => _showFounderInfo(context),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text("Location Settings"),
                  subtitle: const Text("Manage your location preferences"),
                  onTap: _openLocation,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _confirmLogout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4D9BE6),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _confirmDeleteAccount(context),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text("Delete Account"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
