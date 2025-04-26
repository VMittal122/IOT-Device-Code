import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'AutoStock',
//       theme: ThemeData(
//         fontFamily: 'HachiMaruPop',
//         useMaterial3: true,
//       ),
//       home: const HomePage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFD6F0FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/logo.png',
                      height: size.height * 0.05,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'AutoStock',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5C9EDC),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: size.width / (size.height * 0.6),
                    children: const [
                      HomeButton(
                        iconPath: 'assets/icons/shortcuts.png',
                        label: 'Shortcuts',
                      ),
                      HomeButton(
                        iconPath: 'assets/icons/add_device.png',
                        label: 'Add Device',
                      ),
                      HomeButton(
                        iconPath: 'assets/icons/statistics.png',
                        label: 'Statistics',
                      ),
                      HomeButton(
                        iconPath: 'assets/icons/manage.png',
                        label: 'Manage Device',
                      ),
                      HomeButton(
                        iconPath: 'assets/icons/contact.png',
                        label: 'Contact Us',
                      ),
                      HomeButton(
                        iconPath: 'assets/icons/account.png',
                        label: 'My Account',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  final String iconPath;
  final String label;

  const HomeButton({super.key, required this.iconPath, required this.label});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.width * 0.04),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            height: size.width * 0.18,
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
