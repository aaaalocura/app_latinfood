import 'dart:convert';
import 'package:app_latin_food/src/pages/client/products/prod/client_products_list_page.dart';
import 'package:get/get.dart';
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
  static final SelectedCategoryController selectedCategoryController =
      Get.find<SelectedCategoryController>();
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
   List<Category> categories = []; // Lista de categorías

  // ...

  static Future<void> refreshCategories() async {
    try {
      final url = Uri.https('kdlatinfood.com', '/intranet/public/api/categories');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final categoriesData = jsonData as List<dynamic>;
        // ignore: unused_local_variable
        final categories = Category.fromJsonList(categoriesData);

        // Actualiza el estado de SelectedCategoryController con la categoría seleccionada
        final selectedCategoryId = selectedCategoryController.selectedCategoryId.value;
        if (selectedCategoryId != -1) {
          selectedCategoryController.setSelectedCategory(selectedCategoryId);
        }
      } else {
        throw Exception('Failed to fetch categories');
      }
    } catch (e) {
      // Maneja cualquier error que pueda ocurrir durante la recarga de categorías
      // ignore: avoid_print
      print('Error al recargar categorías: $e');
    }
  }
}
