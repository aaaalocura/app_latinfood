import 'package:app_latin_food/src/models/find_user.dart';
import 'package:app_latin_food/src/models/user.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class ClientProfileInfoController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {});

 FindCustomer? lastFetchedCustomerData;


Future<FindCustomer> fetchCustomerData(int customerId) async {
  final url =
      'https://kdlatinfood.com/intranet/public/api/clientes/findUser/$customerId'; // Reemplaza por la URL de tu API

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final newCustomerData = FindCustomer.fromJson(jsonData);

      // Check if the data has changed
      if (lastFetchedCustomerData != newCustomerData) {
        lastFetchedCustomerData = newCustomerData;
      }

      return newCustomerData;
    } else {
      throw Exception('Failed to load customer data');
    }
  } catch (e) {
    // Handle network errors or exceptions
    throw Exception('Failed to load customer data: $e');
  }
}




  void singOut() {
    GetStorage().remove('user');
    Get.snackbar('Saliste', '');
    Get.offNamedUntil('/login', (route) => false);
  }

  void goToAddress() {
    Get.toNamed('/home/profile/address');
  }

}
