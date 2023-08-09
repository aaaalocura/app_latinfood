import 'dart:convert';
import 'package:app_latin_food/src/models/cat.dart';
import 'package:http/http.dart' as http;

class ProductController {
  Future<List<Product>> fetchProductsByCategory(int categoryId) async {
    final url = Uri.parse('https://kdlatinfood.com/intranet/public/api/products/findprod/$categoryId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      return responseData.map((productJson) => Product.fromJson(productJson)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
