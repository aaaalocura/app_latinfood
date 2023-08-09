import 'dart:convert';

import 'package:app_latin_food/src/models/product.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ClientProductsListController extends GetxController {
  var indexTab = 0.obs;
  RxList<Product> products = RxList<Product>();

  get user => null;

  @override
  void onInit() {
    super.onInit();
    getProducts();
  }

  void changeTab(int index) {
    indexTab.value = index;
  }

  void getProducts() async {
    try {
      final url =
          Uri.parse('https://kdlatinfood.com/intranet/public/api/products');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // La solicitud fue exitosa
        final List<dynamic> data = json.decode(response.body);
        // ignore: unnecessary_type_check
        if (data is List) {
          products.value = data.map((item) => Product.fromJson(item)).toList();
        } else {
          // ignore: avoid_print
          print('Error en la estructura de la respuesta: $data');
        }
      } else {
        // La solicitud falló
        if (kDebugMode) {
          print('Error en la solicitud: ${response.statusCode}');
        }
      }
    } catch (e) {
      // Ocurrió un error
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }
}
