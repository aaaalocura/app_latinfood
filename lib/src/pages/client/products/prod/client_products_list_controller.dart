// ignore_for_file: unnecessary_type_check, avoid_print

import 'dart:convert';

import 'package:app_latin_food/src/models/category.dart';
import 'package:app_latin_food/src/models/product.dart';
import 'package:app_latin_food/src/models/user.dart';
import 'package:app_latin_food/src/utils/push_notificacion_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ProductsListController extends GetxController {
  RxString selectedSize = "TAMAÑO 1".obs;
  RxBool isAddToCartEnabled = false.obs;
  RxDouble selectedSizeMultiplier = 1.0.obs;
  RxInt selectedSizeMultiplier2 = 1.obs;
  var currentTab = 0.obs;
  void updateSize(String size, double multiplier, int multiplier2) {
    selectedSize.value = size;
    isAddToCartEnabled.value = true;
    selectedSizeMultiplier.value = multiplier;
    selectedSizeMultiplier2.value = multiplier2;
  }

  PushNotificationsProvider pushNotificationsProvider =
      PushNotificationsProvider();
  User user = User.fromJson(GetStorage().read('user'));
  var indexTab = 0.obs;
  RxList<Product> products = RxList<Product>();
  List<Category> categories = [];
  RxList<Product> filteredProducts = RxList<Product>();

  RxList<Product> filteredProductsCrudos = RxList<Product>();
  RxList<Product> filteredProductsPreCocidos = RxList<Product>();
  // Variable para almacenar la categoría seleccionada
  Rx<Category?> selectedCategory = Rx<Category?>(null);
  RxBool isButtonPressed = false.obs;
  @override
  void onInit() {
    super.onInit();
    getProducts();
    fetchCategories();
    savetoken();
  }

  void savetoken() {
    pushNotificationsProvider.saveToken(user.id!.toString());
  }

  // Mapa para almacenar contadores individuales por producto
  // Mapa para almacenar contadores individuales por producto
  final RxMap contadoresPorProducto = {}.obs;
// Función para incrementar el contador del producto
  void incrementarContador(String productId) {
    if (!contadoresPorProducto.containsKey(productId)) {
      contadoresPorProducto[productId] = RxInt(0);
    }
    contadoresPorProducto[productId]!.value++;
    print(contadoresPorProducto);
    update();
  }

// Función para decrementar el contador del producto
  void decrementarContador(String productId) {
    if (contadoresPorProducto.containsKey(productId) &&
        contadoresPorProducto[productId]!.value > 0) {
      contadoresPorProducto[productId]!.value--;
      print(contadoresPorProducto);
      update();
    }
  }

  void filterProductsByCategory(Category category) {
    // ignore: unnecessary_null_comparison
    if (category != null) {
      // ignore: invalid_use_of_protected_member
      filteredProducts.value = products.value
          .where((product) => product.categoryId == category.name)
          .toList();
    } else {
      // ignore: invalid_use_of_protected_member
      filteredProducts.value = products.value;
    }
  }

  void reiniciarContadores() {
    contadoresPorProducto.clear();
    update();
  }

  void getProductsByCategory(String categoryName) async {
    try {
      final url =
          Uri.parse('https://kdlatinfood.com/intranet/public/api/products');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          if (data is List) {
            products.value =
                data.map((item) => Product.fromJson(item)).toList();

            // Filtrar los productos por categoría
            // ignore: invalid_use_of_protected_member
            filteredProducts.value = products.value.where((product) {
              return product.categoryId == categoryName;
            }).toList();
          } else {
            print('Error en la estructura de la respuesta: $data');
          }
        } else {
          print('Error en la estructura de la respuesta: $data');
        }
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void getProductsByCategoryCrudos(String categoryName) async {
    try {
      final url =
          Uri.parse('https://kdlatinfood.com/intranet/public/api/products/crudos');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          if (data is List) {
            products.value =
                data.map((item) => Product.fromJson(item)).toList();

            // Filtrar los productos por categoría
            // ignore: invalid_use_of_protected_member
            filteredProductsCrudos.value = products.value.where((product) {
              return product.categoryId == categoryName;
            }).toList();
          } else {
            print('Error en la estructura de la respuesta: $data');
          }
        } else {
          print('Error en la estructura de la respuesta: $data');
        }
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void getProductsByCategoryPreCocidos(String categoryName) async {
    try {
      final url =
          Uri.parse('https://kdlatinfood.com/intranet/public/api/products/precocidos');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          if (data is List) {
            products.value =
                data.map((item) => Product.fromJson(item)).toList();

            // Filtrar los productos por categoría
            // ignore: invalid_use_of_protected_member
            filteredProductsPreCocidos.value = products.value.where((product) {
              return product.categoryId == categoryName;
            }).toList();
          } else {
            print('Error en la estructura de la respuesta: $data');
          }
        } else {
          print('Error en la estructura de la respuesta: $data');
        }
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<List<Product>> getProductsWithSameCategory(String categoryId) async {
    try {
      const apiUrl = 'https://kdlatinfood.com/intranet/public/api/products';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> productsData = data['data'];

        final List<Product> relatedProducts = productsData
            .map((productData) => Product.fromJson(productData))
            .where((product) => product.categoryId == categoryId)
            .toList();

        return relatedProducts;
      } else {
        throw Exception('Failed to fetch products with same category');
      }
    } catch (e) {
      throw Exception('Failed to get related products: $e');
    }
  }

  void changeTab(int index) {
    indexTab.value = index;
  }

  void fetchCategories() async {
    try {
      categories = await CategoryController.fetchCategories();
      update();
    } catch (error) {
      // Manejar el error de la solicitud o procesamiento de datos
    }
  }

  void getProducts() async {
    try {
      final url =
          Uri.parse('https://kdlatinfood.com/intranet/public/api/products');
      final response = await http.get(url);
      // ignore: duplicate_ignore
      if (response.statusCode == 200) {
        // La solicitud fue exitosa
        final List<dynamic> data = json.decode(response.body);
        if (data is List) {
          products.value = data.map((item) => Product.fromJson(item)).toList();
          // ignore: invalid_use_of_protected_member
          filteredProducts.value = products
              // ignore: invalid_use_of_protected_member
              .value; // Inicialmente, los productos filtrados son los mismos que todos los productos
        } else {
          
          print('Error en la estructura de la respuesta: $data');
        }
      } else {
        // La solicitud falló

        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      // Ocurrió un error

      print('Error: $e');
    }
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      // ignore: invalid_use_of_protected_member
      filteredProducts.value = products.value;
    } else {
      final lowercaseQuery = query.toLowerCase();
      // ignore: invalid_use_of_protected_member
      filteredProducts.value = products.value.where((product) {
        final lowercaseName = product.name.toLowerCase();
        return lowercaseName.contains(lowercaseQuery);
      }).toList();
    }
  }

  Future<List<Product>> fetchProductsByCategory(int categoryId) async {
    final url = Uri.parse(
        'https://kdlatinfood.com/intranet/public/api/products/findprod/$categoryId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      return responseData
          .map((productJson) => Product.fromJson(productJson))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}