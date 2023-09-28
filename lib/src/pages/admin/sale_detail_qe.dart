import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;
import '../../models/sale_model.dart';

class SaleDetailPage extends StatefulWidget {
  final Sale sale;

  const SaleDetailPage(
      {super.key, required this.sale, required List<SaleDetail> saleDetails});

  @override

  // ignore: library_private_types_in_public_api
  _SaleDetailPageState createState() => _SaleDetailPageState();
}

class _SaleDetailPageState extends State<SaleDetailPage> {
  var getResult = 'QR Code Result';
  void goToAdminPedidos() {
    Get.toNamed('/homeadmin');
  }

  Future<void> sendQRCodeToAPI(String qrCode, int ventaId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando...'),
            ],
          ),
        );
      },
    );
    final apiUrl =
        Uri.parse('https://kdlatinfood.com/intranet/public/api/verify-qrcode');

    try {
      final response = await http.post(
        apiUrl,
        body: {
          'ventaId': ventaId.toString(),
          'qrCode': qrCode,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey('message')) {
          final message = jsonResponse['message'];
          showDialog(
            context: context,
            builder: (BuildContext context) {
              if (message == 'Codigo QR incorrecto para esta venta.') {
                return CupertinoAlertDialog(
                  title: const Text('Código QR incorrecto'),
                  content:
                      const Text('El código QR no es válido para esta venta.'),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Cierra el cuadro de diálogo
                      },
                    ),
                  ],
                );
              } else if (message == 'Pase al siguiente producto.') {
                return CupertinoAlertDialog(
                  title: const Text('Siga escaneando'),
                  content: const Text('Scanee el siguiente producto.'),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              } else if (message ==
                  'Todos los codigos QR han sido escaneados.') {
                return CupertinoAlertDialog(
                  title: const Text('Felicitaciones'),
                  content:
                      const Text('Todos los códigos QR han sido escaneados.'),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text('OK'),
                      onPressed: () {
                        goToAdminPedidos();
                      },
                    ),
                  ],
                );
              } else {
                return CupertinoAlertDialog(
                  title: const Text('Mensaje de la API'),
                  content: Text(message),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              }
            },
          );
        }

        // ignore: avoid_print
        print('Respuesta de la API: ${response.body}');
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('Felicitaciones'),
              content: const Text('Todos los códigos QR han sido escaneados.'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el cuadro de diálogo
                    goToAdminPedidos();
                  },
                ),
              ],
            );
          },
        );

        // ignore: avoid_print
        print('Error en la solicitud a la API: ${response.statusCode}');
      }
    } catch (e) {
      showDialog(
        context: context,
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
  }

  void scanQr() async {
    String? cameraResult = await scanner.scan();
    setState(() {
      getResult = cameraResult!;

      // ignore: avoid_print
      print('valor del qr: $getResult');
      sendQRCodeToAPI(getResult, widget.sale.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Sale #${widget.sale.id}',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/latin-food-8635c.appspot.com/o/splash%2FlogoAnimadoNaranjaLoop.gif?alt=media&token=0f2cb2ee-718b-492c-8448-359705b01923',
              width: 50,
              height: 50,
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
                      'ID del Pedido: ${widget.sale.id}',
                      style: const TextStyle(
                        fontSize: 18.0,
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
                Text(
                  'Total: \$${widget.sale.total}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Total de Items: ${widget.sale.items}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Estado de la Compra: ${widget.sale.status}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Estado de Envío: ${widget.sale.statusEnvio}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(
                    height:
                        16.0), // Espacio entre detalles y lista de productos
                const Text('Productos en el Pedido',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.sale.salesDetails.length,
                    itemBuilder: (context, index) {
                      final detail = widget.sale.salesDetails[index];
                      final product = detail.product;

                      return Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          title: Text(product.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('SKU: ${detail.product.barcode}'),
                              Text('Precio: \$${detail.price}'),
                              Text('Cantidad: ${detail.quantity}'),
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
                                  // ignore: prefer_const_constructors
                                  Text(
                                    'Compra Verificada',
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
      floatingActionButton: CupertinoButton(
        onPressed: () => scanQr(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: const Color(0xE5FF5100),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: const Text(
            'Open Scan',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
