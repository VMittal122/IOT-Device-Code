import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StatisticsProvider with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  static const geminiKey = "AIzaSyBkU2LvQDyQgurwl4095b_Wshfv5CgW4Yg";

  Future<String> generateStatistics(String items) async {
    _loading = true;
    notifyListeners();

    try {
      String prompt = '''
        Here is a list of grocery items with their respective weights in grams. For each item, return the estimated nutritional values scaled to the given weight.
        Only respond in the defined JSON format. Do not include any text outside the JSON.

        These are the items - 
      $items
        ''';
      final res = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$geminiKey',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "system_instruction": {
            "parts": {
              "text": '''
                You are a nutrition analysis assistant. Users will provide a list of grocery or product items along with their weights. Your task is to:
                Identify each item and match it to a known food/product in your database.
                Return accurate nutritional values based on the provided weight.
                Only respond in JSON format - do not include any explanation or additional text.
                If a food item is not recognized, include "error": "Item not recognized" in place of the nutritional values for that item.

                Example of Json response
                {
                  "items": [
                    {
                      "name": "Apple",
                      "weight_grams": 150,
                      "nutrition": {
                        "calories": 78,
                        "protein_grams": 0.4,
                        "fat_grams": 0.2,
                        "carbohydrates_grams": 21,
                        "fiber_grams": 3.6,
                        "sugar_grams": 16
                      }
                    },
                    {
                      "name": "RandomUnknownItem",
                      "weight_grams": 100,
                      "error": "Item not recognized"
                    }
                  ]
                }

                 - Notes for Gemini API
                Scale nutrition values proportionally to the provided weight_grams.
                Do not output any units except "grams" in the keys.
                Always include all fields for each valid item: calories, protein, fat, carbohydrates, fiber, sugar, etc based on the given item

                If an item is invalid or ambiguous, return the error field as shown.
                  ''',
            },
          },
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

      if (res.statusCode == 200) {
        String val =
            jsonDecode(
              res.body,
            )['candidates'][0]['content']['parts'][0]['text'];
        // final formatted = responseModelFromJson(
        //   val.substring(7, val.length - 3).trim(),
        // );

        // String cleanedJson =
        //     val.replaceAll('json', '').replaceAll('`', '').trim();
        // final formatted = responseModelFromJson(cleanedJson);
        // log(cleanedJson);
        log(val);

        // _recipeResponse = formatted;

        notifyListeners();
        return val;
      }
      // print('internal error');
      return 'An internal error occurred';
    } catch (e) {
      log(e.toString());
      return e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
