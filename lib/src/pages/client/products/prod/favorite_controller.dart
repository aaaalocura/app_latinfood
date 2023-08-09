import 'package:app_latin_food/src/models/favoritos.dart';
import 'package:app_latin_food/src/models/user.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;    
import 'package:app_latin_food/src/models/product.dart';
import 'package:get_storage/get_storage.dart';

class FavoritesController extends GetxController {
   static const apiUrl = 'https://kdlatinfood.com/intranet/public/api/favoritos/';
  
  final favoritesItems = <Product>[].obs;
  User user = User.fromJson(GetStorage().read('user') ?? {});
  int get favoritesItemCount => favoritesItems.length;

  final isFavorite = false.obs; // Inicialmente no es favorito

  Future<void> toggleFavorite(int productId, int clientId) async {
    if (isFavorite.value) {
      await RemoveFromFavorites(productId, clientId);
      isFavorite.value = false;
    } else {
      await AddToFavorites(productId, clientId);
      isFavorite.value = true;
    }
  }

 Future<void> AddToFavorites(int productId, int clientId) async {
  try {
    final response = await http.post(
      Uri.parse('https://kdlatinfood.com/intranet/public/api/favoritos/add/$productId/$clientId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      print('Producto agregado a favoritos');
    } else {
      throw Exception('Error al agregar el producto a favoritos');
    }
  } catch (e) {
    throw Exception('Error durante la solicitud HTTP: $e');
  }
}



  Future<void> RemoveFromFavorites(int productId, int clientId) async {
    final response = await http.delete(
      Uri.parse('https://kdlatinfood.com/intranet/public/api/favoritos/delete/$productId/$clientId'),
    );

    if (response.statusCode == 200) {
      print('Producto eliminado de favoritos');
    } else {
      throw Exception('Error al eliminar el producto de favoritos');
    }
  }


  // Función para obtener los productos favoritos de un cliente
Future<List<ProductFavorite>> getFavoriteProducts(int clientId) async {
  try {
    final response = await http.get(Uri.parse('https://kdlatinfood.com/intranet/public/api/favoritos/all/$clientId'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;
      List<ProductFavorite> favorites = jsonData
          .map((productJson) => ProductFavorite.fromJson(productJson))
          .toList();
      return favorites;
    } else if (response.statusCode == 404) {
      // Devolver una lista vacía si no hay productos en favoritos
      return [];
    } else {
      throw Exception('Error al obtener productos favoritos: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error al realizar la solicitud HTTP: $e');
  }
}

}
