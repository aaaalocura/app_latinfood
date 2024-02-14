import 'package:app_latin_food/src/pages/client/products/prod/cart_controller.dart';
import 'package:app_latin_food/src/pages/client/products/prod/pedido_realizado.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_latin_food/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:page_transition/page_transition.dart';

// ignore: use_key_in_widget_constructors
class CheckOutPage extends StatelessWidget {
  final CartController cartController = Get.find();
  final ClientProfileInfoController con =
      Get.put(ClientProfileInfoController());
  final double shippingCost = 0.0;

  @override
  Widget build(BuildContext context) {
    double subtotal = cartController.totalAmount_detail;
    double total = subtotal + shippingCost;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Out'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
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
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 8),
                Text(
                  'Delivery Address',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8,right: 8, bottom: 50),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     const Row(
                      // Alineación horizontal del icono y el texto
                      children: [
                        Icon(
                          Icons.home,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Home',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ' ${con.user.phone}', // Mostrar el número de teléfono
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0x80000000),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ' ${con.user.address}', // Mostrar el número de teléfono
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0x80000000),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
         
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Billing Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Shipping Cost:', // Mostrar el número de teléfono
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Color(0x80000000),
                      ),
                    ),
                    Text(
                      '\$${shippingCost.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Subtoal:', // Mostrar el número de teléfono
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Color(0x80000000),
                      ),
                    ),
                    Text(
                      '\$${subtotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                 Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ), const SizedBox(height: 10  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:', // Mostrar el número de teléfono
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Color(0x80000000),
                      ),
                    ),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
               
               
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          // Llamar al método makeSale del controlador del carrito
          await cartController.makeSale();

          // Navegar a la siguiente ventana (PedidoRealizadoPage) solo si la venta fue exitosa
          if (cartController.saleSuccessful) {
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: PedidoRealizadoPage(),
              ),
            );
          } else {
            // Mostrar un mensaje de error en caso de que la venta no haya sido exitosa
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('El carrito esta  vacio.'),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xE5FF5100),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 12),
        ),
        child: const Text(
          'Pay Now',
          style: TextStyle(
            fontSize: 16,
            height: 1,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 255, 253, 253),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
