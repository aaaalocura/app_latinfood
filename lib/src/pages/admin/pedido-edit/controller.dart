import 'dart:convert';

import 'package:app_latin_food/src/models/sale_model.dart';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class SaleEditController extends GetxController {
  // Cargar los productos para el Dropdown
  // Lista para almacenar los productos
  List<Product> products = [];
  List<Sale> sales = []; 
   final RxList<SaleDetail> saleDetails = <SaleDetail>[].obs;
  // Función para cargar los productos desde la API
  Future<void> loadProducts() async {
    try {
      final response = await http.get(
          Uri.parse('https://kdlatinfood.com/intranet/public/api/showAllKEY'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse is List) {
          final data = List<Map<String, dynamic>>.from(jsonResponse);
          // Mapear los datos y crear objetos Product
          final productList =data.map((item) => Product.fromJson(item)).toList();
          // Almacenar los productos en la lista
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
Future<void> fetchSales1() async {
  try {
    final response = await http.get(
      Uri.parse('https://kdlatinfood.com/intranet/public/api/despachos'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['data'];
      final sales = jsonList.map((json) => Sale.fromJson(json)).toList();

      // No es necesario hacer solicitudes adicionales para detalles de venta y productos,
      // ya que la API ya proporciona todos los datos necesarios.

      // Actualiza la lista de ventas en el controlador
      this.sales = sales;
    } else {
      await Future.delayed(const Duration(seconds: 5));
      Get.snackbar(
        'Accion No Completada',
        'Volviendo a Intentar',
        barBlur: 100,
        animationDuration: const Duration(seconds: 1),
      );
    }
  } catch (e) {
    await Future.delayed(const Duration(seconds: 5));
    Get.snackbar(
      'Ocurrio un Error',
      'Recargue la aplicacion',
      barBlur: 100,
      animationDuration: const Duration(seconds: 1),
    );
  }
}

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
          Get.snackbar(
            'Accion No Completada',
            'Volviendo a Intentar',
            barBlur: 100,
            animationDuration: const Duration(seconds: 1),
          );
        }
      } catch (e) {
        await Future.delayed(const Duration(seconds: 5));
        Get.snackbar(
          'Ocurrio un Error',
          'Recargue la aplicacion',
          barBlur: 100,
          animationDuration: const Duration(seconds: 1),
        );
      }

      currentAttempt++;
    }

    return [];
  }

  // Actualizar la cantidad de un producto en la venta
  Future<void> updateProductQuantity({
    required int saleId,
    required int productId,
    required int newQuantity,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://kdlatinfood.com/intranet/public/api/update-sale'),
        body: {
          'sale_id': saleId.toString(),
          'product_id': productId.toString(),
          'quantity': newQuantity.toString(),
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Accion Completada',
          'Cantidad Actualizada Correctamente',
          barBlur: 100,
          animationDuration: const Duration(seconds: 1),
        );
      } else {
        Get.snackbar(
          'Accion No Completada 1',
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

  // Eliminar un producto de la venta
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

  // Agregar un nuevo producto a la venta
  Future<void> addProductToSale({
    required int saleId,
    required String barcode,
    required int quantity,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://kdlatinfood.com/intranet/public/api/add-product-to-sale'),
        body: {
          'sale_id': saleId.toString(),
          'barcode': barcode,
          'quantity': quantity.toString(),
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Accion Completada',
          'Producto Agregado Correctamente',
          barBlur: 100,
          animationDuration: const Duration(seconds: 1),
        );
        // Actualiza la lista de detalles de venta
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
