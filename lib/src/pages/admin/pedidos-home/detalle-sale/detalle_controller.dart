import 'package:app_latin_food/src/pages/admin/pedidos-home/pedidos_home_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_latin_food/src/models/sale_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SaleController extends GetxController {
  Rx<Sale?> sale = Rx<Sale?>(null);
  final RxBool isLoading = false.obs;
   final Map<int, Product> selectedProducts = {};
  void fetchSaleDetails(int id) async {
    isLoading.value = true;
    try {
      final response = await http.get(
          Uri.parse('https://kdlatinfood.com/intranet/public/api/sales/$id'));
      if (response.statusCode == 200) {
        sale.value = Sale.fromJson(json.decode(response.body)['data']);
      } else {
        throw Exception('Failed to load sale details');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isLoading.value = false;
    }
  }

// Función para recargar la página
  void reloadPage(int saleId) {
    isLoading.value = true;
    update();
    fetchSaleDetails(saleId);
  }

  Future<void> loadOrder(int saleId) async {
    isLoading.value = true;

    final apiUrl = Uri.parse(
      'https://kdlatinfood.com/intranet/public/api/sales/cargar/$saleId',
    );

    try {
      final response = await http.put(apiUrl);

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Order loaded successfully');
        goToAdminPedidos();
      } else {
        throw Exception(
            'Error loading order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Connection error: $e',
          backgroundColor: Colors.red);
      
    } finally {
      isLoading.value = false;
    }
  }

  void goToAdminPedidos() {
    HomePedidosController homePedidosController =
        Get.find<HomePedidosController>();

    // Llama a la función fetchSales
    homePedidosController.fetchSales();
    Get.toNamed('/homeadmin');
  }

   Future<void> deleteProductFromSale({
    required int saleId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse(
          'https://kdlatinfood.com/intranet/public/api/sales/borrar/$saleId',
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
      if (kDebugMode) {
        print(e);
      }
      Get.snackbar(
        'Accion No Completada',
        'Revise su Conexion a Internet',
        barBlur: 100,
        animationDuration: const Duration(seconds: 1),
      );
    }
  }
   final products = <Product>[].obs;

  void fetchProducts() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse('https://kdlatinfood.com/intranet/public/api/showAllKEY'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<Product> fetchedProducts = responseData.map((item) => Product.fromJson(item)).toList();
        products.assignAll(fetchedProducts);
      } else {
        if (kDebugMode) {
          print('Failed to load products');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception occurred while loading products: $e');
      }
    } finally {
      isLoading(false);
    }
  }
  void addProductsToSale1(Map<int, Product> selectedProducts, idSale) {
    // Itera sobre los productos seleccionados y llama a la función addProductToSale
    selectedProducts.forEach((productId, product) async {
      await addProductToSale(
        saleId: idSale, // tu valor de saleId,
        barcode: product.barcode!,
        quantity: product.selectedQuantity,
      );
    });
    // Actualiza la lista de detalles de venta

    update();

    // Cierra el BottomSheet después de confirmar
    Get.back(result: true);
  }
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
        update();
        // Actualiza la lista de detalles de venta
      } else {
        if (kDebugMode) {
          print(response.body);
        }
        Get.snackbar(
          'Accion No Completada',
          'Ocurrio un Error',
          barBlur: 100,
          animationDuration: const Duration(seconds: 1),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.snackbar(
        'Accion No Completada',
        'Revise su Conexion a Internet',
        barBlur: 100,
        animationDuration: const Duration(seconds: 1),
      );
    }
  }
}
