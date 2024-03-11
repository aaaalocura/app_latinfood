import 'dart:ui';

import 'package:app_latin_food/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:app_latin_food/src/pages/client/products/prod/cart_controller.dart';
import 'package:app_latin_food/src/pages/client/products/prod/check_out.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController cartController = Get.find();
final ClientProductsListController con5 =
      Get.put(ClientProductsListController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          
          onPressed: () {
                con5.changeTab(0);
              },
        ),
        title: const Text(
          'My Cart',
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/latin-food-8635c.appspot.com/o/splash%2FlogoAnimadoNaranjaLoop.gif?alt=media&token=0f2cb2ee-718b-492c-8448-359705b01923',
              width: 50,
              height: 50,
            ),
          ),
        ],
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  color:
                      const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFFF7B33).withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              'You have ${cartController.cartItemCount} items in your shopping cart',
              style: const TextStyle(
                fontSize: 14,
                height: 21 / 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                color: Color(0xFFFF7B33),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior(),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: cartController.cartItemCount,
                itemBuilder: (context, index) {
                  final cartItem = cartController.cartItems[index];
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.startToEnd,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (_) {
                      cartController.removeFromCart(cartItem);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        leading: SizedBox(
                          width: 80,
                          height: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: Image.network(
                              cartItem.product.image ?? '',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Container(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartItem.product.name,
                                style: const TextStyle(fontSize: 18),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    cartItem
                                        .product.categoryId, // Texto izquierdo
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xFF999999),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    '•', // Punto
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    cartItem.product.saborId ??
                                        'Not Flavor', // Texto derecho
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xFF999999),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    '•', // Punto
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(
                                      width: 4), // Espacio entre los textos
                                  Text(
                                    cartItem.quantity.toString(),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xFF999999),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF333333),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                      Icons.remove_circle_outline_outlined),
                                  onPressed: () {
                                    setState(() {
                                      cartController
                                          .decrementQuantity(cartItem);
                                    });
                                  },
                                ),
                                Text(
                                  (cartItem.quantity ~/ cartItem.tam!)
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      cartController
                                          .incrementQuantity(cartItem);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        return ElevatedButton(
          onPressed: cartController.cartItemCount > 0
              ? () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: CheckOutPage(),
                    ),
                  );
                }
              : null, // Deshabilita el botón si no hay productos en el carrito
          style: ElevatedButton.styleFrom(
            backgroundColor: cartController.cartItemCount > 0
                ? const Color(0xE5FF5100)
                : Colors
                    .grey, // Cambia el color del botón si está deshabilitado
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 12),
          ),
          child: const Text(
            'Place Order',
            style: TextStyle(
              fontSize: 16,
              height: 1,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 255, 253, 253),
            ),
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
