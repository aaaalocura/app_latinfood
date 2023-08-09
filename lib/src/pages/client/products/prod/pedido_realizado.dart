import 'package:app_latin_food/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:app_latin_food/src/pages/envios/envios_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

class PedidoRealizadoPage extends StatelessWidget {
  PedidoRealizadoPage({super.key});
  final ClientProfileInfoController con1 =
      Get.put(ClientProfileInfoController());
  @override
  Widget build(BuildContext context) {
    final int userId = int.parse('${con1.user.id}');
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              _imageCover(),
              const SizedBox(height: 20),
              _shipmentText(),
              const SizedBox(height: 20),
              _thankYouText(),
              const SizedBox(height: 20),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: ClientOrdersPage(customerId: userId),
                        ),
                      );
                      Get.offNamed(
                          '/home/delyvery'); // Redirecciona a la ruta '/home/delyvery'
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                    ),
                    child: const Text(
                      'See Your Shipment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16), // Espacio entre los botones
                  ElevatedButton(
                    onPressed: () {
                      // Aquí agregas la lógica para redireccionar al home
                      Get.offNamed('/home'); // Redirecciona a la ruta '/home'
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                    ),
                    child: const Text(
                      'Go to Home',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageCover() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 40),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/img/padado.png',
          width: 100,
          height: 100,
        ),
      ),
    );
  }

  Widget _shipmentText() {
    return const Text(
      'Shipment successfully created.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _thankYouText() {
    return const Text(
      'Now sit back and relax, your order is on its way.\nThank you!',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey,
      ),
    );
  }
}
