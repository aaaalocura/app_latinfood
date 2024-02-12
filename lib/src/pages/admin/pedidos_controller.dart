import 'dart:convert';

import 'package:app_latin_food/src/models/sale_model.dart';
import 'package:http/http.dart' as http;




Future<List<Sale>> fetchSales() async {
  int maxAttempts = 3;
  int currentAttempt = 0;

  while (currentAttempt < maxAttempts) {
    try {
      final response = await http.get(
          Uri.parse('https://kdlatinfood.com/intranet/public/api/despachos'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body)['data'];
        return jsonList.map((json) => Sale.fromJson(json)).toList();
      } else {
        await Future.delayed(const Duration(seconds: 5));
      }
    } catch (e) {
      await Future.delayed(const Duration(seconds: 5));
    }

    currentAttempt++;
  }

  return [];
}
