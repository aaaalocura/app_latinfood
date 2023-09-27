import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../models/sale_model.dart';

class SaleEdit extends StatefulWidget {
  final Sale sale;
  final List<SaleDetail> saleDetails;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SaleEdit({super.key, required this.sale, required this.saleDetails});

  @override
  // ignore: library_private_types_in_public_api
  _SaleEditState createState() => _SaleEditState();
}

class _SaleEditState extends State<SaleEdit> {
  TextEditingController barcodeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  void goToAdminPedidos() {
    Get.toNamed('/homeadmin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Editar Pedido',
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
                      'Order ID: ${widget.sale.id}',
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.receipt,
                      size: 32.0,
                      color: Color(0xE5FF5100),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          const Spacer(),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Añadir Producto"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: barcodeController,
                          decoration: const InputDecoration(
                              labelText: 'Código de Barras'),
                        ),
                        TextField(
                          controller: quantityController,
                          decoration: const InputDecoration(
                              labelText: 'Cantidad de Artículos'),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () async {
                          String barcode = barcodeController.text;
                          int quantity =
                              int.tryParse(quantityController.text) ?? 0;
                          
                            // Realiza la solicitud HTTP POST para enviar los datos al servidor Laravel
                            final response = await http.post(
                              Uri.parse(
                                  'https://kdlatinfood.com/intranet/public/api/add-product-to-sale'), // Reemplaza con la URL de tu API
                              body: {
                                'sale_id':
                                    '${widget.sale.id}', // Reemplaza con el ID de la venta
                                'barcode': barcode,
                                'quantity': quantity.toString(),
                              },
                            );
try {
                            // Si la solicitud fue exitosa, puedes mostrar un mensaje de éxito
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Éxito'),
                                  content: const Text(
                                      'Producto guardado con éxito.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        // Actualiza la página llamando a setState
                                        setState(() {});
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );

                            // Limpia los controladores y cierra el diálogo
                            barcodeController.clear();
                            quantityController.clear();
                                setState(() {});
                            Navigator.of(context).pop();
                          } catch (e) {
                            // Si la solicitud no fue exitosa, muestra un mensaje de error
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text(
                                      'Error al guardar el producto.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                              setState(() {});
                        },
                        child: const Text("Guardar"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancelar"),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text("Añadir Producto"),
          ),
          const SizedBox(width: 16.0),
          CupertinoButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: const Text('Upload Order'),
                    content: const Text('Are you sure to upload this order?'),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoDialogAction(
                        child: const Text('Sí'),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 16),
                                    Text('Loading data...'),
                                  ],
                                ),
                              );
                            },
                          );
                          final apiUrl = Uri.parse(
                            'https://kdlatinfood.com/intranet/public/api/sales/cargar/${widget.sale.id}',
                          );

                          try {
                            final response = await http.put(apiUrl);

                            showDialog(
                              context: widget._scaffoldKey.currentContext!,
                              builder: (BuildContext context) {
                                return CupertinoAlertDialog(
                                  title: const Text('Complete'),
                                  content:
                                      const Text('Order Saved successfully'),
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
                            showDialog(
                              context: widget._scaffoldKey.currentContext!,
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
                color: const Color(0xE5FF5100),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: const Text(
                'Guardar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
