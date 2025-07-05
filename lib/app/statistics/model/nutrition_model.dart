class NutritionItem {
  final String name;
  final int weightGrams;
  final Nutrition? nutrition;

  NutritionItem({
    required this.name,
    required this.weightGrams,
    this.nutrition,
  });

  factory NutritionItem.fromJson(Map<String, dynamic> json) {
    return NutritionItem(
      name: json['name'],
      weightGrams: json['weight_grams'],
      nutrition:
          json['estimated_nutritional_values'] != null
              ? Nutrition.fromJson(
                json['estimated_nutritional_values'],
              ) // ✅ Fixed key
              : null,
    );
  }
}

class Nutrition {
  final int calories;
  final double protein;
  final double carbohydrates;
  final double fiber;
  final double sugar;
  final double fat;

  Nutrition({
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fiber,
    required this.sugar,
    required this.fat,
  });

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      calories: json['calories'],
      protein: (json['protein'] ?? 0).toDouble(),
      carbohydrates: (json['carbohydrates'] ?? 0).toDouble(),
      fiber: (json['fiber'] ?? 0).toDouble(),
      sugar: (json['sugar'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
    );
  }
}
