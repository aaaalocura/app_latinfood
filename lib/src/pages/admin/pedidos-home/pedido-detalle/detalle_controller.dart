import 'package:app_latin_food/src/models/sale_model.dart';
import 'package:app_latin_food/src/pages/admin/pedidos-home/pedidos_home_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuantityInputController extends GetxController {
  final TextEditingController textEditingController = TextEditingController();
}

class SaleDetailController extends GetxController {
  final QuantityInputController quantityInputController =
      Get.put(QuantityInputController());
  final TextEditingController quantityController = TextEditingController();
  final RxBool isLoading = false.obs;
  RxList<SaleDetail> salesDetails = <SaleDetail>[].obs;
  RxBool showDeleteButtons = false.obs;
  RxBool isEditing = false.obs;
  List<Product> products = <Product>[].obs;
  RxMap<int, Product> selectedProducts = <int, Product>{}.obs;
  void updateSaleDetails(List<SaleDetail> updatedDetails) {
    salesDetails.assignAll(updatedDetails);
  }

  Future<List<Product>> loadProducts() async {
    try {
      final response = await http.get(
          Uri.parse('https://kdlatinfood.com/intranet/public/api/showAllKEY'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse is List) {
          final data = List<Map<String, dynamic>>.from(jsonResponse);
          // Mapear los datos y crear objetos Product
          final productList =
              data.map((item) => Product.fromJson(item)).toList();
          // Devolver la lista de productos
          return productList;
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
    // En caso de error, devolver una lista vacía o manejarlo según tus necesidades
    return [];
  }

  Future<int?> _showQuantityInputDialog(BuildContext context) async {
    return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int quantity = 1; // Valor predeterminado

        return AlertDialog(
          title: const Text('Ingrese la cantidad'),
          content: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cantidad'),
                onChanged: (value) {
                  quantity = int.tryParse(value) ?? 1;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(quantity);
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xE5FF5100), // Color naranja
              ),
              child: const Text(
                'Aceptar',
                style: TextStyle(color: Colors.white), // Color del texto blanco
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xE5FF5100), // Color naranja
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white), // Color del texto blanco
              ),
            ),
          ],
        );
      },
    );
  }

  // Método para cargar y mostrar el BottomSheet de productos
  Future<void> showProductBottomSheet(idSale) async {
    // Cargar la lista de productos
    List<Product> products = await loadProducts();

    // Crear un controlador de texto para la cantidad (puedes usarlo según sea necesario)

    // Mostrar el BottomSheet con la lista de productos y botones de confirmar y cancelar
    await Get.bottomSheet(
      backgroundColor: Colors.white.withOpacity(1),
      Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Selecciona un producto:'),
            const SizedBox(height: 10),
            // Lista de productos
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  Product product = products[index];
                  return ListTile(
                    title: Text(product.name!),
                    subtitle: Text('Cantidad: ${product.selectedQuantity}'),
                    onTap: () async {
                      // Mostrar el AlertDialog para ingresar la cantidad
                      int? quantity = await _showQuantityInputDialog(context);

                      if (quantity != null) {
                        // Actualizar la cantidad seleccionada y el mapa de productos
                        product.selectedQuantity = quantity;
                        selectedProducts[product.id!] = product;

                        if (kDebugMode) {
                          print(selectedProducts);
                        }
                      }
                    },
                    tileColor: selectedProducts.containsKey(product.id)
                        ? Colors.blue.withOpacity(1)
                        : null,
                  );
                },
              ),
            ),

            const SizedBox(height: 10),
            // Botones de confirmar y cancelar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Lógica al presionar el botón de confirmar
                    _addProductsToSale(selectedProducts, idSale);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xE5FF5100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Confirmar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Lógica al presionar el botón de cancelar
                    Get.back(result: false); // Cierra el BottomSheet
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xE5FF5100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ],
        ),
      ),
      // Puedes ajustar la forma en que el BottomSheet se cierra (si es necesario)
      isDismissible: false,
      enableDrag: false,
    );
  }

  void _addProductsToSale(Map<int, Product> selectedProducts, idSale) {
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
 void getsales() {
    HomePedidosController homePedidosController =
        Get.find<HomePedidosController>();

    // Llama a la función fetchSales
    homePedidosController.fetchSales();
   
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
        getsales();
      } else {
        if (kDebugMode) {
          print(response.statusCode);
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

  void toggleDeleteButtons() {
    showDeleteButtons.value = !showDeleteButtons.value;
  }

  Future<void> loadOrder(int saleId) async {
    isLoading.value = true;

    final apiUrl = Uri.parse(
      'https://kdlatinfood.com/intranet/public/api/sales/cargar/$saleId',
    );

    try {
      final response = await http.put(apiUrl);

      if (response.statusCode == 200) {
        // Si la respuesta es 200, puedes realizar acciones adicionales si es necesario
        // ...
        // Actualiza la lista después de cargar el pedido
        salesDetails.assignAll(salesDetails);
        update();
        Get.snackbar('Success', 'Order loaded successfully');
        goToAdminPedidos();
      } else {
        throw Exception(
            'Error loading order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Connection error: $e',
          backgroundColor: Colors.red);
      // Puedes manejar el error de conexión como desees
      // ...
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
    required int saleDetailId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse(
          'https://kdlatinfood.com/intranet/public/api/sales/borrar/$saleDetailId',
        ),
      );

      if (response.statusCode == 200) {
        salesDetails.removeWhere((detail) => detail.id == saleDetailId);

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

  // Método para mostrar el BottomSheet y editar la cantidad del producto
  void showEditProductBottomSheet(SaleDetail detail) {
    quantityController.text = detail.quantity.toString();

    Get.bottomSheet(
      // Puedes personalizar el diseño del BottomSheet según tus necesidades
      backgroundColor: Colors.white.withOpacity(1),
      Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Editar cantidad de ${detail.product.name}'),
            const SizedBox(height: 10),
            TextField(
              controller: TextEditingController(
                text: detail.quantity.toString(),
              ),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Nueva cantidad'),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Lógica para confirmar y llamar a la función del controlador
                    // Lógica para confirmar y llamar a la función del controlador
                    int newQuantity = int.tryParse(quantityController.text)!;
                    updateProductQuantity(
                      saleId: detail.saleID,
                      productId: detail.productID,
                      newQuantity: newQuantity,
                    );
                    Get.back(); // Cierra el BottomSheet
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xE5FF5100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Confirmar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.back(); // Cierra el BottomSheet sin hacer cambios
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xE5FF5100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
}
