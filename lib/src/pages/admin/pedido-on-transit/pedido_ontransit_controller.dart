import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;


class QRScannerController extends GetxController {
  var getResult = 'QR Code Result';
  RxInt scanned = 0.obs;
  void _updateScreen() {
    update();
  }

  Future<void> sendQRCodeToAPI(String qrCode, String keyProduct, int productID,
      int saleID, int? id) async {
    Get.dialog(
      CupertinoAlertDialog(
        title: const Text('Cargando...'),
        content: Container(
          padding: const EdgeInsets.all(16.0),
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 16.0),
              Text(
                'Por favor, espera...',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    final apiUrl =
        Uri.parse('https://kdlatinfood.com/intranet/public/api/verify-qrcode');

    try {
      final response = await http.post(
        apiUrl,
        body: {
          'ventaId': saleID.toString(),
          'qrCode': qrCode,
          'product_id': productID.toString(),
          'venta_detalle': id.toString(),
          'key_prod': keyProduct,
        },
      );

      Get.back(); // Cerrar el diálogo de carga

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey('message')) {
          final message = jsonResponse['message'];

          if (message == 'Pase al siguiente producto.') {
            _updateScreen();
            _showAlertDialog(message);
          } else if (message == 'Todos los códigos QR han sido escaneados.') {
            _showAllScannedDialog(message);

            // Hacer el segundo POST a la nueva ruta
            final secondResponse = await http.post(
              Uri.parse(
                  'https://kdlatinfood.com/intranet/public/api/updateActualSales'),
              // Aquí coloca los datos que deseas enviar en el segundo POST
              // {'key': 'value'},
            );

            // Imprimir la respuesta del segundo POST
            if (kDebugMode) {
              print('Respuesta del segundo POST: ${secondResponse.body}');
            }
          } else {
            _showSnackbar(message);
          }
        }

        if (kDebugMode) {
          print('Respuesta de la API: ${response.body}');
        }
      } else {
        _showErrorDialog(
            'Error en la solicitud a la API: ${response.statusCode}');
      }
    } catch (e) {
      Get.back(); // Cerrar el diálogo de carga
      _showErrorDialog('Error de conexión: $e');
      if (kDebugMode) {
        print('$e');
      }
      if (kDebugMode) {
        print('Error de conexión: $e');
      }
    }
  }

  void _showSnackbar(String message) {
    Get.snackbar(
      'Respuesta de la API',
      message,
      duration: const Duration(seconds: 5),
      snackPosition: SnackPosition.TOP,
    );
  }

  void _showAlertDialog(String message) {
    Get.dialog(
      CupertinoAlertDialog(
        title: const Text('Codigo Correcto'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void goToAdminPedidos() {
    Get.toNamed('/homeadmin');
  }

  void _showAllScannedDialog(String message) {
    Get.dialog(
      CupertinoAlertDialog(
        title: const Text('Todos los productos fueron escaneados'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              goToAdminPedidos();
            },
          ),
        ],
      ),
    );
  }

  void scanQR(BuildContext context, String keyProduct, int productID,
      int saleID, int? id) async {
    if (kDebugMode) {
      print('Valor de keyProduct: $keyProduct');
      print('Valor de productID: $productID');
      print('Valor de saleID: $saleID');
      print('Valor de Saleid_detalle: $id');
      print('Valor del código QR: $getResult');
    }

    try {
      String result = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Color de fondo del cabezal del escáner
        'Cancel', // Texto del botón de cancelar
        true, // Muestra la luz del flash
        ScanMode.QR, // Modo QR
      );

      if (result != '-1') {
        getResult = result;

        // Imprimir por consola los valores que llegan a la función
        if (kDebugMode) {
          print('Valor de keyProduct: $keyProduct');
          print('Valor de productID: $productID');
          print('Valor de saleID: $saleID');
          print('Valor de Saleid_detalle: $id');
          print('Valor del código QR: $getResult');
        }

        // Llamar a la función sendQRCodeToAPI con los valores recibidos
        sendQRCodeToAPI(getResult, keyProduct, productID, saleID, id);
      }
    } catch (e) {
      _showErrorDialog('Error al escanear el código QR: $e');
      if (kDebugMode) {
        print('Error al escanear el código QR: $e');
      }
    }
  }

  void _showErrorDialog(String error) {
    Get.dialog(
      CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(error),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
