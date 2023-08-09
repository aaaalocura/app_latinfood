import 'dart:convert';
import 'package:http/http.dart' as http;

class Category {
  int id;
  String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"],
      name: json["name"],
    );
  }

  static List<Category> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Category.fromJson(json)).toList();
  }
}

class CategoryController {
  static Future<List<Category>> fetchCategories() async {
    final url = Uri.https('kdlatinfood.com', '/intranet/public/api/categories');
    
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final categoriesData = jsonData as List<dynamic>;
      return Category.fromJsonList(categoriesData);
    } else {
      throw Exception('Failed to fetch categories');
    }
  }
}
