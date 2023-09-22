import 'package:app_latin_food/src/pages/client/profile/address/client_address_controller.dart';
import 'package:app_latin_food/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressEditPage extends StatelessWidget {
  final ClientProfileInfoController con =
      Get.put(ClientProfileInfoController());
final ClientAddressController clientAddressController =
      Get.put(ClientAddressController());
  AddressEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xE5FF5100),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Edit Address'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: 10.0), // Ajusta el valor según tu preferencia
            child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/latin-food-8635c.appspot.com/o/splash%2FlogoAnimadoNaranjaLoop.gif?alt=media&token=0f2cb2ee-718b-492c-8448-359705b01923',
              width: 50, // Ajusta el ancho de la imagen según tus necesidades
              height: 50, // Ajusta el alto de la imagen según tus necesidades
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
body: Padding(
  padding: const EdgeInsets.all(16.0),
  child: Center(
    child: Card(
      margin: const EdgeInsets.all(2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: clientAddressController.zipCodeController,
              decoration: const InputDecoration(labelText: 'Zip Code'),
            ),
            TextFormField(
              controller: clientAddressController.stateController,
              decoration: const InputDecoration(labelText: 'State'),
            ),
            TextFormField(
              controller: clientAddressController.streetController,
              decoration: const InputDecoration(labelText: 'Street'),
            ),
            TextFormField(
              controller: clientAddressController.cityController,
              decoration: const InputDecoration(labelText: 'City'),
            ),
            const SizedBox(height: 24),
            FloatingActionButton.extended(
              onPressed: () {
                // Llama al método para guardar los cambios y mostrar la notificación
                clientAddressController.saveChanges();
                
                // Puedes usar Get.to() para navegar hacia atrás si es necesario.
              },
              backgroundColor: const Color(0xE5FF5100),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              label: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
),

    );
  }
}
