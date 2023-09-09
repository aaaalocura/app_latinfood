import 'package:app_latin_food/src/models/find_user.dart';
import 'package:app_latin_food/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ClientProfileInfoController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {});
  void goToAddress() {
    Get.toNamed('/home/profile/address');
  }

  Future<FindCustomer> fetchCustomerData(int customerId) async {
    final url =
        'https://kdlatinfood.com/intranet/public/api/clientes/findUser/$customerId'; // Reemplaza por la URL de tu API
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return FindCustomer.fromJson(jsonData);
    } else {
      throw Exception('Failed to load customer data');
    }
  }

  void singOut() {
    GetStorage().remove('user');
    Get.snackbar('Saliste ', '');
    Get.offNamedUntil('/login', (route) => false);
  }
}
