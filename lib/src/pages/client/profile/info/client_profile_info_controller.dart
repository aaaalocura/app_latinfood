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
  int inactivityTime =
      10; // Tiempo en minutos de inactividad antes de cerrar sesión
  int warningTime =
      4; // Tiempo en minutos para mostrar el Snackbar de advertencia
  Timer? _timer; // Temporizador para verificar la inactividad

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
    _timer?.cancel(); // Cancelar temporizador anterior si existe
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      checkInactivity();
    });
  }

  void checkInactivity() async {
    final preferences = await SharedPreferences.getInstance();
    final lastActivityTime = preferences.getInt('last_activity_time') ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final elapsedMinutes = (currentTime - lastActivityTime) ~/ (1000 * 60);

    if (elapsedMinutes == warningTime) {
      // Mostrar Snackbar de advertencia cuando falte 1 minuto
      Get.snackbar('Advertencia', 'La sesión se cerrará en 1 minuto',
          backgroundColor: Colors.yellow);
    }

    if (elapsedMinutes >= inactivityTime) {
      // Verificar si no hay interacción del usuario en los últimos 5 minutos
      if (!Get.isSnackbarOpen) {
        // Si no hay una notificación Snackbar abierta (usuario interactuando), entonces cerrar sesión
        Get.snackbar('Tiempo de sesión agotado', '');
        singOut(); // Cerrar sesión
      }
    }
  }

  void singOut() {
    GetStorage().remove('user');
    Get.snackbar('Saliste', '');
    Get.offNamedUntil('/login', (route) => false);
    updateActivityTime();
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
