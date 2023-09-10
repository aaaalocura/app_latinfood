import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:signature/signature.dart'; // Importa el paquete de firma

import '../../models/sale_model.dart';

class SaleDetailPageFirma extends StatefulWidget {
  final Sale sale;
  final List<SaleDetail> saleDetails;

  const SaleDetailPageFirma(
      {super.key, required this.sale, required this.saleDetails});

  @override
  // ignore: library_private_types_in_public_api
  _SaleDetailPageFirmaState createState() => _SaleDetailPageFirmaState();
}

class _SaleDetailPageFirmaState extends State<SaleDetailPageFirma> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5, // Ancho del trazo del lápiz
    penColor:
        const Color.fromARGB(255, 16, 16, 16), // Color del trazo del lápiz
  );
  bool showSignaturePad = false; // Para mostrar u ocultar el Signature Pad

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
          'Detalle del pedido ',
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
                itemCount: widget.saleDetails.length,
                itemBuilder: (context, index) {
                  final detail = widget.saleDetails[index];
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
            // Mostrar el Signature Pad y los botones solo si showSignaturePad es verdadero
            if (showSignaturePad)
              Column(
                children: [
                  Signature(
                    controller: _controller,
                    width: 300,
                    height: 200,
                    backgroundColor: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // Realizar la petición API cuando se confirma la entrega
                          final apiUrl = Uri.parse(
                              'https://kdlatinfood.com/intranet/public/api/sales/FIN/${widget.sale.id}');
                          // ignore: avoid_print
                          print(widget.sale.id);
                          try {
                            final response = await http.put(apiUrl);

                            if (response.statusCode == 200) {
                              // La solicitud a la API fue exitosa
                              // Muestra un mensaje de éxito
                              // ignore: avoid_print
                              print('pedido finalizado');

                              // Cierra la página actual y regresa a la página anterior
                            } else {
                              // Manejar errores de solicitud aquí
                              // ignore: avoid_print
                              print(
                                  'Error en la solicitud a la API: ${response.statusCode}');
                              // Muestra un mensaje de error al usuario si lo deseas
                            }
                          } catch (e) {
                            // Manejar errores de conexión aquí
                            // ignore: avoid_print
                            print('Error de conexión: $e');
                            // Muestra un mensaje de error al usuario si lo deseas
                          }
                        },
                        child: const Text('Confirmar'),
                      ),
                      const SizedBox(width: 20), // Espacio entre botones
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
      floatingActionButton: CupertinoButton(
        onPressed: () {
          // Cambiar el estado para mostrar el Signature Pad cuando se presiona "Entregar"
          setState(() {
            showSignaturePad = true;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.blue, // Cambia el color según tu preferencia
          ),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: const Text(
            'Entregar',
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