import 'package:app_latin_food/src/models/find_user.dart';
import 'package:app_latin_food/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class ClientProfileInfoController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {});
  int inactivityTime = 5; // Cambiado a 5 minutos
  int warningTime = 4; // Cambiado a 4 minutos
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startInactivityTimer();
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

  void startInactivityTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      checkInactivity();
    });
  }

  void checkInactivity() async {
    final preferences = await SharedPreferences.getInstance();
    final lastActivityTime = preferences.getInt('last_activity_time') ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final elapsedMinutes = (currentTime - lastActivityTime) ~/ (1000 * 60);

    if (elapsedMinutes == warningTime) {
      Get.snackbar('Advertencia', 'La sesión se cerrará en 1 minuto',
          backgroundColor: Colors.yellow);
    }

    if (elapsedMinutes >= inactivityTime) {
      if (!Get.isSnackbarOpen) {
        Get.snackbar('Tiempo de sesión agotado', '');
        singOut();
      }
    }
  }

  void singOut() {
    GetStorage().remove('user');
    Get.snackbar('Saliste', '');
    Get.offNamedUntil('/login', (route) => false);
  }

  void goToAddress() {
    Get.toNamed('/home/profile/address');
    updateActivityTime();
  }

  void updateActivityTime() async {
    final preferences = await SharedPreferences.getInstance();
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    preferences.setInt('last_activity_time', currentTime);
  }
}
