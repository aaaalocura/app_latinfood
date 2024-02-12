import 'dart:convert';

import 'package:app_latin_food/src/models/sale_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomePedidosController extends GetxController {
  RxList<Sale> sales = <Sale>[].obs;
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    fetchSales();
  }

  Future<void> fetchSales() async {
    int maxAttempts = 3;
    int currentAttempt = 0;

    while (currentAttempt < maxAttempts) {
      try {
        final response = await http.get(
          Uri.parse('https://kdlatinfood.com/intranet/public/api/despachos-pending'),
        );

        if (response.statusCode == 200) {
          final List<dynamic> jsonList = json.decode(response.body)['data'];
          sales.assignAll(jsonList.map((json) => Sale.fromJson(json)).toList());
          showSnackbar('Pedidos recargados correctamente');
          return;
        } else {
          await Future.delayed(const Duration(seconds: 5));
        }
      } catch (e) {
        showSnackbar('Error al recargar pedidos');
        await Future.delayed(const Duration(seconds: 5));
      }

      currentAttempt++;
    }
    isLoading.value = false;
  }

  void showSnackbar(String s) {
    Get.snackbar(
      s,
      '',
      barBlur: 100,
      animationDuration: const Duration(seconds: 1),
    );
  }
}
