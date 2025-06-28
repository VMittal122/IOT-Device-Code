import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iot_device/app/device/bluetooth_connection.dart';
import 'package:iot_device/app/home/bottomsheet.dart';
import '../device/add_device_page.dart';
import '../auth/statistics/statistics.dart';
import '../setting/setting_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'AutoStock',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Color(0xFF2D9CDB),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: const [
                    Text(
                      "Never stock out!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Track inventory effortlessly and support a smarter local ecosystem.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildInventoryGrid(),
            const SizedBox(height: 30),
            Center(
              child: _buildInfoSection(
                title: "Mission",
                content:
                    "To provide busy individuals with a smart, efficient way to manage their groceries and nutrition, while fostering a sustainable, hyperlocal food ecosystem that supports local vendors and farmers.",
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: _buildInfoSection(
                title: "Vision",
                content:
                    "To create a future where grocery management is effortless, nutrition is prioritized, and local vendors and farmers thrive by reducing reliance on large supply chains and promoting a sustainable, technology-driven, community-based food ecosystem.",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryGrid() {
    // final items = [
    //   {'name': 'Tomato', 'qty': '3.54'},
    //   {'name': 'Potato', 'qty': '1.23'},
    //   {'name': 'Apple', 'qty': '0.5'},
    //   {'name': 'Carrot', 'qty': '2.82'},
    // ];

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('devices').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          var items =
              snapshot.data!.docs.map((doc) {
                return {
                  'id': doc.id,
                  'name': doc.data()['name'] ?? doc.data()['DID'] ?? "Unknown",
                  'tare': doc.data()['tare'],
                  'weight': doc.data()['weight'] ?? 0,
                };
              }).toList();
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [
                    Text(
                      item['name']!,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      item['weight'] >= 1000
                          ? '${double.parse((item['weight'] / 1000).toString()).toStringAsFixed(2)} Kg'
                          : '${double.parse(item['weight'].toString()).floor()} g',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('devices')
                                .doc(items[index]['id'])
                                .update({'tare': 1});
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            backgroundColor: Colors.blue[100],
                          ),
                          child: const Text(
                            'Tare',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showCustomeBottomSheet(context, items[index]['id']);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            backgroundColor: Colors.blue[100],
                          ),
                          child: const Text(
                            'Edit',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildInfoSection({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D9CDB),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
