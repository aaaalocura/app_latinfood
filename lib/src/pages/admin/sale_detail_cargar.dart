// ignore_for_file: unused_import

import 'package:app_latin_food/src/pages/admin/pedido-edit/controller.dart';
import 'package:app_latin_food/src/pages/admin/pedido-edit/pedido_edit_page.dart';
import 'package:app_latin_food/src/pages/admin/pedido_edit.dart';
import 'package:app_latin_food/src/pages/admin/pedidos_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../models/sale_model.dart';

class SaleDetailPage extends StatelessWidget {
  final Sale sale;
  final List<SaleDetail> saleDetails;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
 
    // ignore: empty_constructor_bodies
    SaleDetailPage({super.key, required this.sale, required this.saleDetails}) {
  }
  void goToAdminPedidos() {
    Get.toNamed('/homeadmin');
  }
  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
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
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order ID: ${sale.id}',
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.receipt, // Icono para resaltar el número de pedido
                      size: 32.0,
                      color: Color(0xE5FF5100), // Color de la aplicación
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Total: \$${sale.total}',
                  style: const TextStyle(fontSize: 18.0),
                ),
                Text(
                  'Total Items: ${sale.items}',
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Shipment Status: ${sale.statusEnvio}',
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Products in Order',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: saleDetails.length,
                    itemBuilder: (context, index) {
                      final detail = saleDetails[index];
                      final product = detail.product;

                      return Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          title: Text(
                            product.name!,
                            style: const TextStyle(fontSize: 18.0),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price: \$${detail.price}',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              Text(
                                'Quantity of Items: ${detail.quantity}',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Icon(
                                    Icons.check_circle_outline_outlined,
                                    size: 24.0,
                                    color: Colors
                                        .green, // Icono de verificación en verde
                                  ),
                                  Text(
                                    'Compra Verificada', // Texto de detalles adicionales
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
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
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // Distribuye los botones en los extremos

        children: [
          const Spacer(),
          const Spacer(),
          const Spacer(),
          CupertinoButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SaleEditPage(
                    sale: sale,
                    saleDetails: sale.salesDetails,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: const Color(
                    0xE5FF5100), // Cambia el color según tu preferencia
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: const Text(
                'Edit Delivery',
                style: TextStyle(
                  color: Colors
                      .white, // Cambia el color del texto según tu preferencia
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          CupertinoButton(
            onPressed: () {
              // Mostrar el diálogo de confirmación estilo Cupertino
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: const Text('Load Order'),
                    content: const Text('Are you sure to upload this order?'),
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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    CircularProgressIndicator(), // Indicador de carga
                                    SizedBox(
                                        height:
                                            16), // Espacio entre el indicador y el texto
                                    Text('Loading data...'), // Mensaje de carga
                                  ],
                                ),
                              );
                            },
                          );
                          final apiUrl = Uri.parse(
                            'https://kdlatinfood.com/intranet/public/api/sales/cargar/${sale.id}',
                          );
                          // ignore: avoid_print
                          print(sale.id);
                          try {
                            // ignore: unused_local_variable
                            final response = await http.put(apiUrl);

                            // Si la respuesta es 200, muestra un cuadro de diálogo de confirmación
                            showDialog(
                              context: _scaffoldKey.currentContext!,
                              builder: (BuildContext context) {
                                return CupertinoAlertDialog(
                                  title: const Text('Complete'),
                                  content:
                                      const Text('Order uploaded successfully'),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        goToAdminPedidos();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } catch (e) {
                            // Si hay un error de conexión, muestra un cuadro de diálogo de error
                            showDialog(
                              context: _scaffoldKey.currentContext!,
                              builder: (BuildContext context) {
                                return CupertinoAlertDialog(
                                  title: const Text('Error'),
                                  content: Text('Error de conexión: $e'),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            // ignore: avoid_print
                            print('Error de conexión: $e');
                          }
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
                color: const Color(
                    0xE5FF5100), // Cambia el color según tu preferencia
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: const Text(
                'Load Delivery',
                style: TextStyle(
                  color: Colors
                      .white, // Cambia el color del texto según tu preferencia
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
