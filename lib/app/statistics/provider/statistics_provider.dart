import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iot_device/app/statistics/model/nutrition_model.dart';

class StatisticsProvider with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  List<NutritionItem> _nutritionItems = [];
  List<NutritionItem> get nutritionItems => _nutritionItems;

  static const geminiKey =
      'AIzaSyBkU2LvQDyQgurwl4095b_Wshfv5CgW4Yg'; // Replace with your actual API key

  Future<String> generateStatisticsFromFirebase(
    List<Map<String, dynamic>> itemsFromFirestore,
  ) async {
    _loading = true;
    notifyListeners();

    try {
      final itemsJson = {
        "items":
            itemsFromFirestore.map((item) {
              return {"name": item['name'], "weight_grams": item['weight']};
            }).toList(),
      };

      final prompt = '''
Here is a list of grocery items with their respective weights in grams.
For each item, return the estimated nutritional values scaled to the given weight.
Only respond in JSON format. Do not include any text outside the JSON.

These are the items:
${jsonEncode(itemsJson)}
''';

      final response = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$geminiKey',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {"text": prompt},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final rawContent =
            jsonDecode(
              response.body,
            )['candidates'][0]['content']['parts'][0]['text'];

        final cleaned =
            rawContent.replaceAll('```json', '').replaceAll('```', '').trim();
        debugPrint("🧹 Cleaned Gemini Content:\n$cleaned");

        // ✅ Safe decode
        late Map<String, dynamic> decoded;
        try {
          decoded = jsonDecode(cleaned);
        } catch (e) {
          debugPrint("❌ JSON decode failed: $e");
          _nutritionItems = [];
          notifyListeners();
          return 'Invalid JSON response';
        }

        // ✅ Defensive check for expected key
        if (decoded['nutritional_information'] == null ||
            decoded['nutritional_information'] is! List) {
          debugPrint("❌ nutritional_information missing or invalid");
          _nutritionItems = [];
          notifyListeners();
          return 'Missing nutritional data';
        }

        final List<dynamic> items = decoded['nutritional_information'];
        _nutritionItems = items.map((e) => NutritionItem.fromJson(e)).toList();
        debugPrint("✅ Parsed ${_nutritionItems.length} nutrition items");

        notifyListeners();
        return cleaned;
      } else {
        debugPrint('❌ Gemini error: ${response.statusCode}');
        debugPrint(response.body);
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
      return 'Exception: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
