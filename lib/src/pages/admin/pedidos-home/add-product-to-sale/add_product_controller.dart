import 'package:app_latin_food/src/models/sale_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class AddProductToSaleController extends GetxController {
  List<Product> products = [];
    RxList<Product> productss = <Product>[].obs;
  RxInt selectedProductCount = 0.obs;

  RxList<SaleDetail> salesDetails = <SaleDetail>[].obs;

  // Método para alternar la selección de un producto
  
  Future<void> loadProducts() async {
    try {
      final response = await http.get(
          Uri.parse('https://kdlatinfood.com/intranet/public/api/showAllKEY'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse is List) {
          final data = List<Map<String, dynamic>>.from(jsonResponse);
          final productList =
              data.map((item) => Product.fromJson(item)).toList();
          products = productList;
        }
      }
    } catch (e) {
      Get.snackbar(
        'Ocurrio un Error',
        'Recargue la aplicacion',
        barBlur: 100,
        animationDuration: const Duration(seconds: 1),
      );
    }
  }
   // Método para alternar la selección de productos
  void toggleProductSelection(int index) {
    if (index >= 0 && index < products.length) {
      products[index].isSelected = !products[index].isSelected!;
      if (kDebugMode) {
        print(!products[index].isSelected!);
      }
      update(); // Actualiza la interfaz de usuario para reflejar los cambios
    }
  }

  Future<void> deleteProductFromSale({
  required int saleDetailId,
}) async {
  try {
    final response = await http.delete(
      Uri.parse(
        'https://kdlatinfood.com/intranet/public/api/sales/borrar/$saleDetailId',
      ),
    );

    if (response.statusCode == 200) {
      // Elimina el producto de la lista
      salesDetails.removeWhere((detail) => detail.id == saleDetailId);

      // Notifica a los oyentes que la lista ha cambiado
      salesDetails.refresh();

      Get.snackbar(
        'Accion Completada',
        'Producto Eliminado Correctamente',
        barBlur: 100,
        animationDuration: const Duration(seconds: 1),
      );
    } else {
      Get.snackbar(
        'Accion No Completada',
        'Ocurrio un Error',
        barBlur: 100,
        animationDuration: const Duration(seconds: 1),
      );
    }
  } catch (e) {
    Get.snackbar(
      'Accion No Completada',
      'Revise su Conexion a Internet',
      barBlur: 100,
      animationDuration: const Duration(seconds: 1),
    );
  }
}

}
