import 'package:app_latin_food/src/models/sale.dart';
import 'package:app_latin_food/src/models/user.dart';
import 'package:get/get.dart';
import 'package:app_latin_food/src/models/product.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartController extends GetxController {
  final cartItems = <CartItem>[].obs;
  User user = User.fromJson(GetStorage().read('user') ?? {});
  int get cartItemCount => cartItems.length;
  bool saleSuccessful = false;
  void addToCart(Product product,int  userId, int quantity) {
    final existingItemIndex =
        cartItems.indexWhere((item) => item.product.id == product.id);
    if (existingItemIndex != -1) {
      cartItems[existingItemIndex].quantity += quantity;
    } else {
      cartItems.add(CartItem(product: product, quantity: quantity));
    }
  }
  void removeFromCart(CartItem cartItem) {
    cartItems.remove(cartItem);
  }
  double get totalAmount {
    double total = 0.0;
    for (var cartItem in cartItems) {
      total += cartItem.product.price * cartItem.quantity;
    }
    return total;
  }

  void decrementQuantity(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
    }
  }

  void incrementQuantity(CartItem cartItem) {
    cartItem.quantity++;
  }



  // Método para realizar la venta usando la API
  Future<void> makeSale() async {
    if (cartItems.isEmpty) {
      // Verificar si el carrito está vacío
      Get.snackbar('Error', 'El carrito está vacío');
      return;
    }

    // Crear una lista de objetos Item para el modelo PosApiModel
    List<Item> itemsList = cartItems
        .map((item) => Item(id: item.product.id, quantity: item.quantity))
        .toList();

    // Crear el objeto PosApiModel con los datos del carrito y el usuario
    PosApiModel posApiModel = PosApiModel(
      cliente: user.id ??
          0, // O utiliza el ID del cliente si está disponible en el modelo User
      total: totalAmount,
      efectivo: 0.0, // Puedes cambiar esto según el pago real del cliente
      change: 0.0, // Puedes cambiar esto según el pago real del cliente
      items: itemsList,
    );

    const apiUrl =
        'https://kdlatinfood.com/intranet/public/api/PosAPI/payWithCredit'; // Reemplaza esto con la URL de tu API

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(posApiModel.toJson()),
    );

    if (response.statusCode == 200) {
      // La solicitud fue exitosa
      Get.snackbar('Venta realizada', 'La venta se realizó con éxito');
      // Limpia el carrito después de hacer la venta exitosamente
      saleSuccessful = true;
      cartItems.clear();
    } else {
      // Hubo un error en la solicitud
      Get.snackbar('Error', 'Hubo un error al realizar la venta');
    }
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}
