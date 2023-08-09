import 'package:app_latin_food/src/models/pedidos.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClientOrdersController {
  Future<List<Sale>> fetchClientOrders(int customerId) async {
    const maxAttempts = 3; // Número máximo de intentos
    var attempts = 0;

    while (attempts < maxAttempts) {
      try {
        final url =
            'https://kdlatinfood.com/intranet/public/api/clientes/find/$customerId';
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          final customer = Customer.fromJson(jsonData);

          return customer.sales;
        } else {
          throw Exception('Failed to fetch client orders');
        }
      } catch (e) {
        attempts++;
      }
    }

    throw Exception('Failed after $maxAttempts attempts');
  }
}
