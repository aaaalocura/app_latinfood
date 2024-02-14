import 'package:app_latin_food/src/env/env.dart';
import 'package:app_latin_food/src/models/response_api.dart';
import 'package:app_latin_food/src/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class UsersProviders extends GetConnect {
  String url = '${Env.API_URL}api';

  Future<Response> create(User user) async {
    Response response = await post(
        'http://51.161.35.133:6501/intranet/public/backend/api/customers/create/',
        user.toJson(),
        headers: {'Content-Type': 'application/json'});
    return response;
  }

  Future<ResponseApi> login(String email, String password) async {
    Get.dialog(
      CupertinoAlertDialog(
        title: const Text('Loading...'),
        content: Container(
          padding: const EdgeInsets.all(16.0),
          child:  const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16.0),
              Text(
                'Loading...',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
    Response response = await post(
        'https://kdlatinfood.com/intranet/public/api/login-client',
        {'email': email, 'password': password},
        headers: {'Content-Type': 'application/json'});

    if (response.body == null) {
      Get.snackbar('Error', 'Hubo un error');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    Get.back();
    return responseApi;
  }

  Future<ResponseApi> loginAdmin(String email, String password) async {
    Get.dialog(
      CupertinoAlertDialog(
        title: const Text('Loading...'),
        content: Container(
          padding: const EdgeInsets.all(16.0),
          child:  const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16.0),
              Text(
                'Loading...',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
    int maxRetries = 3; // Número máximo de intentos
    int retryDelaySeconds = 5; // Retardo en segundos entre intentos

    for (int retry = 0; retry < maxRetries; retry++) {
      try {
        Response response = await post(
          'https://kdlatinfood.com/intranet/public/api/login-user',
          {'email': email, 'password': password},
          headers: {'Content-Type': 'application/json'},
        );

        if (response.body == null) {
          Get.snackbar('Error', 'Hubo un error');
          return ResponseApi();
        }
        Get.back();
        ResponseApi responseApi = ResponseApi.fromJson(response.body);

        // Si tiene éxito, sal del bucle y devuelve la respuesta
        if (kDebugMode) {
          print('Login exitoso: ${responseApi.message}');
        }

        // Hacer el segundo POST a la nueva ruta
        Response secondResponse = await post(
          'https://kdlatinfood.com/intranet/public/api/updateActualSales',
          {'': ''},
          headers: {'Content-Type': 'application/json'},
        );

        // Imprimir la respuesta del segundo POST
        if (kDebugMode) {
          print('Respuesta del segundo POST: ${secondResponse.body}');
        }

        return responseApi;
      } catch (e) {
        // ignore: avoid_print
        Get.back(); // Cerrar el diálogo de carga

        // Manejar el error, por ejemplo, mostrar un mensaje de error al usuario
        Get.snackbar('Error', 'Hubo un error al intentar iniciar sesión');
        if (kDebugMode) {
          print('Error en el intento $retry: $e');
        }
        await Future.delayed(Duration(seconds: retryDelaySeconds));
      }
    }

    // Si todos los intentos fallan, puedes manejar el error o lanzar una excepción.
    throw Exception('No se pudo hacer login después de $maxRetries intentos');
  }

  Future<ResponseApi> updateNotificationToken(String id, String token) async {
    Response response = await put(
        'https://kdlatinfood.com/intranet/public/api/update-token',
        {'id': id, 'token': token},
        headers: {'Content-Type': 'application/json'});

    if (response.body == null) {
      Get.snackbar('Error', 'Hubo un error');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    Get.back();
    return responseApi;
  }
}
