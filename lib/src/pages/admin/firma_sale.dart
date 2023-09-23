import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    void goToAdminPedidos() {
      Get.toNamed('/homeadmin');
    }

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
                Text(
                  'Order ID: ${widget.sale.id}',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Total: \$${widget.sale.total}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Total de Items: ${widget.sale.items}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Estado: ${widget.sale.status}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Estado de Envío: ${widget.sale.statusEnvio}',
                  style: TextStyle(fontSize: 16.0),
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
                    itemCount: widget.saleDetails.length,
                    itemBuilder: (context, index) {
                      final detail = widget.saleDetails[index];
                      final product = detail.product;

                      return Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          title: Text(
                            product.name,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Precio: \$${detail.price}',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Text(
                                'Cantidad: ${detail.quantity}',
                                style: TextStyle(fontSize: 16.0),
                              ),
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
                    mainAxisAlignment: MainAxisAlignment
                        .start, // Alinea el contenido en la parte superior
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            bottom:
                                20.0), // Espacio opcional en la parte inferior del Container
                        width: 300,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black,
                              width: 2.0), // Cambia el color de los bordes
                          borderRadius: BorderRadius.circular(
                              10.0), // Opcional: agrega esquinas redondeadas
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Signature(
                                controller: _controller,
                                width:
                                    290, // Ajusta el tamaño de Signature para que quepa dentro del borde
                                height: 190,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                color:
                                    Colors.white, // Fondo blanco para el texto
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: const Text(
                                  'Firme aquí',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const Center(
                                    child:
                                        CircularProgressIndicator(), // Muestra un indicador de carga
                                  );
                                },
                              );

                              // Realizar la petición API cuando se confirma la entrega
                              final apiUrl = Uri.parse(
                                  'https://kdlatinfood.com/intranet/public/api/sales/FIN/${widget.sale.id}');
                              // ignore: avoid_print
                              print(widget.sale.id);
                              try {
                                // ignore: unused_local_variable
                                final response = await http.put(apiUrl);

                                Navigator.of(context)
                                    .pop(); // Cierra el cuadro de diálogo de carga

                                // Muestra un cuadro de diálogo de "Completado" si la respuesta es 200
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: const Text('Completado'),
                                      content: const Text(
                                          'Pedido finalizado exitosamente'),
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

                                // ignore: avoid_print
                                print('Pedido finalizado');
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
