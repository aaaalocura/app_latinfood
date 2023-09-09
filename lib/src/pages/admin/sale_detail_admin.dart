import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


import '../../models/sale_model.dart';

class SaleDetailPage extends StatelessWidget {
  final Sale sale;
  final List<SaleDetail> saleDetails;

  const SaleDetailPage(
      {super.key, required this.sale, required this.saleDetails});
  void goToAdminPedidos() {
    Get.toNamed('/homeadmin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Detalle del pedido',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID del Pedido: ${sale.id}',
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold)),
            Text('Total: \$${sale.total}',
                style: const TextStyle(fontSize: 16.0)),
            Text('Total de Items: ${sale.items}',
                style: const TextStyle(fontSize: 16.0)),
            Text('Estado: ${sale.status}',
                style: const TextStyle(fontSize: 16.0)),
            Text('Estado de Envío: ${sale.statusEnvio}',
                style: const TextStyle(fontSize: 16.0)),
            const SizedBox(
                height: 16.0), // Espacio entre detalles y lista de productos
            const Text('Productos en el Pedido',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: saleDetails.length,
                itemBuilder: (context, index) {
                  final detail = saleDetails[index];
                  final product = detail.product;

                  return Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Precio: \$${detail.price}'),
                          Text('Cantidad: ${detail.quantity}'),
                          // Agrega más detalles del producto si es necesario.
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CupertinoButton(
        onPressed: () {
          // Mostrar el diálogo de confirmación estilo Cupertino
          showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: const Text('Cargar Pedido'),
                content: const Text('¿Estás seguro de cargar este pedido?'),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Cierra el diálogo
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text('Sí'),
                    onPressed: () async {
                      Navigator.of(context).pop(); // Cierra el diálogo

                      final apiUrl = Uri.parse(
                          'https://kdlatinfood.com/intranet/public/api/sales/cargar/${sale.id}');
                      // ignore: avoid_print
                      print(sale.id);
                      try {
                        final response = await http.put(apiUrl);

                        if (response.statusCode == 200) {
                          // La solicitud a la API fue exitosa
                          // Navegar a ClientProductsListPageAdmin
                          goToAdminPedidos();
                        } else {
                          // Manejar errores de solicitud aquí
                          // Muestra un SnackBar de error
                          // ignore: avoid_print
                          print(
                              'Error en la solicitud a la API: ${response.statusCode}');
                        }
                      } catch (e) {
                        // Manejar errores de conexión aquí
                        // Muestra un SnackBar de error
                        // ignore: avoid_print
                        print('Error de conexión: $e');
                      }

                      // Regresar a la ventana anterior
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.blue, // Cambia el color según tu preferencia
          ),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: const Text(
            'Cargar Pedido',
            style: TextStyle(
              color: Colors
                  .white, // Cambia el color del texto según tu preferencia
            ),
          ),
        ),
      ),
    );
  }
}

