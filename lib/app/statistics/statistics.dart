import 'package:flutter/material.dart';
import 'package:iot_device/app/statistics/provider/statistics_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StatisticsProvider>();
    final items = provider.nutritionItems;

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
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final querySnapshot =
                  await FirebaseFirestore.instance.collection('devices').get();

              final items =
                  querySnapshot.docs.map((doc) {
                    return {
                      'name':
                          doc.data()['name'] ?? doc.data()['DID'] ?? "Unknown",
                      'weight': doc.data()['weight'] ?? 0,
                    };
                  }).toList();

              await provider.generateStatisticsFromFirebase(items);
            },
            child: const Text('Get Nutrition Data'),
          ),
          const SizedBox(height: 16),
          Expanded(
            child:
                provider.loading
                    ? const Center(child: CircularProgressIndicator())
                    : items.isEmpty
                    ? const Center(child: Text('No nutrition data yet.'))
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4D9BE6),
                                  ),
                                ),
                                Text('Weight: ${item.weightGrams}g'),
                                const SizedBox(height: 10),
                                if (item.nutrition == null)
                                  const Text('No data available')
                                else ...[
                                  _row(
                                    'Calories',
                                    '${item.nutrition!.calories} kcal',
                                  ),
                                  _row(
                                    'Protein',
                                    '${item.nutrition!.protein} g',
                                  ),
                                  _row(
                                    'Carbs',
                                    '${item.nutrition!.carbohydrates} g',
                                  ),
                                  _row('Fiber', '${item.nutrition!.fiber} g'),
                                  _row('Sugar', '${item.nutrition!.sugar} g'),
                                  _row('Fat', '${item.nutrition!.fat} g'),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
