import 'package:app_latin_food/src/models/sale.dart';
import 'package:app_latin_food/src/models/user.dart';
import 'package:get/get.dart';
import 'package:app_latin_food/src/models/product.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartController extends GetxController {
  final cartItems = <CartItem>[].obs;
  final Map<int, int> productQuantities = {};
  // ignore: prefer_final_fields
  int _cartItemCount = 0;
// ignore: unused_field
  int _cartItemCount2 = 0;
  int get cartItemCount => cartItems.length;

  int get cartItemCount2 => _cartItemCount;
  bool saleSuccessful = false;
  void addToCart(Product product, int userId, int quantity) {
    final existingItemIndex =
        cartItems.indexWhere((item) => item.product.id == product.id);
    if (existingItemIndex != -1) {
      cartItems[existingItemIndex].quantity += quantity;
    } else {
      cartItems.add(CartItem(product: product, quantity: quantity));
      Get.snackbar('Producto Agregado al Carrito', 'listo');
    }
    _updateProductQuantity(product.id, quantity);
  }

  void removeFromCart(CartItem cartItem) {
    cartItems.remove(cartItem);
    _updateProductQuantity(cartItem.product.id, -cartItem.quantity);
  }

  void _updateProductQuantity(int productId, int quantity) {
    if (productQuantities.containsKey(productId)) {
      productQuantities[productId] = quantity + 1;
    } else {
      productQuantities[productId] = quantity;
    }
    _updateCartItemCount();
  }

  void _updateCartItemCount() {
    _cartItemCount2 =
        productQuantities.values.fold(0, (total, quantity) => total + quantity);
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
      _updateCartItemCount();
      cartItem.quantity--;
      _updateCartItemCount();
    }
  }

  void incrementQuantity(CartItem cartItem) {
    _updateCartItemCount();
    cartItem.quantity++;
    _updateCartItemCount();
  }

  Future<void> makeSale() async {
    if (cartItems.isEmpty) {
      Get.snackbar('Error', 'El carrito está vacío');
      return;
    }
    List<Item> itemsList = cartItems
        .map((item) => Item(id: item.product.id, quantity: item.quantity))
        .toList();
    User user = User.fromJson(GetStorage().read('user') ?? {});
    final int? userId = user.id;
    // Crear el objeto PosApiModel con los datos del carrito y el usuario
    PosApiModel posApiModel = PosApiModel(
      cliente: userId!,
      total: totalAmount,
      efectivo: 0.0,
      change: 0.0,
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
