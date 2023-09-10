import 'dart:ui';

import 'package:app_latin_food/src/pages/client/products/prod/cart_controller.dart';
import 'package:app_latin_food/src/pages/client/products/prod/check_out.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

class CartPage extends StatelessWidget {
  final CartController cartController = Get.find();

  CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
     appBar: AppBar(
  title: const Text(
    'My Cart',
  ),
  centerTitle: true,
  backgroundColor: Colors.white,
  elevation: 0,
  automaticallyImplyLeading: false,
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 10.0), // Ajusta el valor según tu preferencia
      child: Image.network(
        'https://firebasestorage.googleapis.com/v0/b/latin-food-8635c.appspot.com/o/splash%2FlogoAnimadoNaranjaLoop.gif?alt=media&token=0f2cb2ee-718b-492c-8448-359705b01923',
        width: 50, // Ajusta el ancho de la imagen según tus necesidades
        height: 50, // Ajusta el alto de la imagen según tus necesidades
      ),
    ),
  ],
  flexibleSpace: FlexibleSpaceBar(
    background: Stack(
      fit: StackFit.expand,
      children: [
        // Coloca aquí la imagen o cualquier otro contenido que desees tener detrás del AppBar

        // BackdropFilter para aplicar el efecto de difuminado
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            color: const Color.fromARGB(255, 255, 255, 255)
                .withOpacity(0.1), // Color de difuminado
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
            // Ajusta el ancho al ancho disponible
            padding: const EdgeInsets.symmetric(
                vertical: 10, horizontal: 20), // Ajusta el espaciado interior
            decoration: BoxDecoration(
              color: const Color(0xFFFF7B33)
                  .withOpacity(0.1), // Color de fondo con opacidad
              borderRadius:
                  BorderRadius.circular(30), // Define las esquinas redondeadas
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
                          vertical: 8.0,
                          horizontal:
                              12.0), // Ajusta el espaciado vertical y horizontal
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            10), // Ajusta el radio de las esquinas según tu preferencia
                        border: Border.all(
                          color: Colors.white, // Color del borde
                          width: 1, // Grosor del borde
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
                              const SizedBox(
                                  height:
                                      5), // Espacio entre el nombre del producto y los textos adicionales
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
                                  const SizedBox(
                                      width: 4), // Espacio entre los textos
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
                                    cartItem.product.saborId ??
                                        'Not Flavor', // Texto derecho
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
                              '\$${cartItem.product.price.toStringAsFixed(2)}',
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
                                    cartController.decrementQuantity(cartItem);
                                  },
                                ),
                                Text(
                                  cartItem.quantity.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    cartController.incrementQuantity(cartItem);
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
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: CheckOutPage(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 12),
        ),
        child: const Text(
          'Place Order',
          style: TextStyle(
            fontSize: 16, // El tamaño de fuente en sp
            height: 1, // La altura de línea en sp
            // El nombre de la fuente 'Inter'
            fontWeight:
                FontWeight.w500, // El peso de fuente, en este caso 500 (medio)
            color: Color.fromARGB(255, 255, 253,
                253), // El color del texto en formato ARGB (8 dígitos hexadecimales)
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

