import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;
import '../../models/sale_model.dart';

class SaleDetailPage extends StatefulWidget {
  final Sale sale;

  const SaleDetailPage({super.key, required this.sale});

  @override

  // ignore: library_private_types_in_public_api
  _SaleDetailPageState createState() => _SaleDetailPageState();
}

class _SaleDetailPageState extends State<SaleDetailPage> {
  var getResult = 'QR Code Result';

  Future<void> sendQRCodeToAPI(String qrCode, int ventaId) async {
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
        // Manejar la respuesta exitosa aquí
        // ignore: avoid_print
        print('Respuesta de la API: ${response.body}');
        // Puedes realizar acciones adicionales si la respuesta es exitosa
      } else {
        // Manejar errores de solicitud aquí
        // ignore: avoid_print
        print('Error en la solicitud a la API: ${response.statusCode}');
        // Puedes mostrar un mensaje de error al usuario si lo deseas
      }
    } catch (e) {
      // Manejar errores de conexión aquí
      // ignore: avoid_print
      print('Error de conexión: $e');
      // Puedes mostrar un mensaje de error al usuario si lo deseas
    }
  }

  void scanQr() async {
    String? cameraResult = await scanner.scan();
    setState(() {
      getResult = cameraResult!;
      // Llamar a la función para enviar el resultado del escaneo y el ID de la venta a la API
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID del Pedido: ${widget.sale.id}',
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold)),
            Text('Total: \$${widget.sale.total}',
                style: const TextStyle(fontSize: 16.0)),
            Text('Total de Items: ${widget.sale.items}',
                style: const TextStyle(fontSize: 16.0)),
            Text('Estado: ${widget.sale.status}',
                style: const TextStyle(fontSize: 16.0)),
            Text('Estado de Envío: ${widget.sale.statusEnvio}',
                style: const TextStyle(fontSize: 16.0)),
            const SizedBox(
                height: 16.0), // Espacio entre detalles y lista de productos
            const Text('Productos en el Pedido',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: widget
                    .sale.salesDetails.length, // La lista de detalles de ventas
                itemBuilder: (context, index) {
                  final detail = widget.sale.salesDetails[index];
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
        onPressed: () => scanQr(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.blue, // Cambia el color según tu preferencia
          ),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: const Text(
            'Open Scan',
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
