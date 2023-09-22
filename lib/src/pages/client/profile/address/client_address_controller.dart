import 'package:app_latin_food/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClientAddressController extends GetxController {
  User user = User.fromJson(GetStorage().read('user'));

  final zipCodeController = TextEditingController();
  final stateController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();

  void saveChanges() {
    final zipCode = zipCodeController.text;
    final state = stateController.text;
    final street = streetController.text;
    final city = cityController.text;

    final concatenatedAddress = '$zipCode, $state, $street, $city';
    // ignore: avoid_print
    print('Dirección concatenada: $concatenatedAddress');

    // Aquí puedes llamar a la función para enviar la solicitud API con 'concatenatedAddress'
    // como el nuevo valor de dirección
    editAddress(concatenatedAddress);
  }

  Future<void> editAddress(String address) async {
    final url =
        'https://kdlatinfood.com/intranet/public/api/clientes/edit-address/${user.id}'; // Reemplaza por la URL de tu API
    final headers = {
      'Content-Type': 'application/json',
    };
    final updatedData = {
      'address': address,
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(updatedData),
      );

if (response.statusCode == 200) {
  // Muestra el SnackBar de éxito
   // ignore: avoid_print
   print('Dirección actuaslizada');
  Get.snackbar('Dirección actualizada', 'listo');

  Get.back();
}
 else {
        // Manejar el caso en que la actualización falla
        // ignore: use_build_context_synchronously
        Get.snackbar('Dirección no actualizada', 'listo');
       // const SnackBar(content: Text('Error al actualizar la dirección'));
      }
    } catch (error) {
      // Manejar errores de conexión
      // ignore: use_build_context_synchronously

      const SnackBar(content: Text('Error de conexión'));

      // ignore: avoid_print
      print('Error: $error');
    }
  }
}
