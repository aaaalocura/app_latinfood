import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../models/sale_model.dart';

class SaleEdit extends StatefulWidget {
  final Sale sale;
  final List<SaleDetail> saleDetails;
  final GlobalKey<ScaffoldState> _scaffoldKey1 = GlobalKey<ScaffoldState>();

  SaleEdit({super.key, required this.sale, required this.saleDetails});

  @override
  // ignore: library_private_types_in_public_api
  _SaleEditState createState() => _SaleEditState();
}

class _SaleEditState extends State<SaleEdit> {
  TextEditingController barcodeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  String? selectedBarcode; // Valor seleccionado en el DropdownButton
  List<Product> products = []; // Variable para almacenar los productos
  bool isEditing = false;
  void goToAdminPedidos() {
    Get.toNamed('/homeadmin');
  }

  @override
  void initState() {
    super.initState();
    // Llama a la función para cargar los productos al iniciar el widget
    getProductsEDIT();
  }

  Future<void> getProductsEDIT() async {
    try {
      final url =
          Uri.parse('https://kdlatinfood.com/intranet/public/api/products');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data is List) {
          setState(() {
            // Actualiza la lista de productos
            products = data.map((item) => Product.fromJson(item)).toList();
          });
          // Inicialmente, puedes seleccionar el primer producto si lo deseas
          if (products.isNotEmpty) {
            selectedBarcode = products[0].barcode;
          }
        } else {
          // Manejo de errores
        }
      } else {
        // Manejo de errores
      }
    } catch (e) {
      // Manejo de errores
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey1,
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

                    return GestureDetector(
                      onTap: () {
                        // Mostrar un SimpleDialog para editar la cantidad
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Editar Cantidad'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  TextField(
                                    controller: quantityController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: 'Cantidad'),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () async {
                                    String newQuantity = quantityController
                                        .text; // Obtener la nueva cantidad del TextField
                                    Navigator.of(context)
                                        .pop(); // Cerrar el diálogo

                                    // Realizar la solicitud HTTP POST para enviar los datos al servidor Laravel
                                    final response = await http.post(
                                      Uri.parse(
                                          'https://kdlatinfood.com/intranet/public/api/update-sale'), // Reemplaza con la URL de tu API
                                      body: {
                                        'sale_id': widget.sale.id
                                            .toString(), // Reemplaza con el ID de la venta
                                        'product_id': product.id
                                            .toString(), // Reemplaza con el ID del producto que estás editando
                                        'quantity': newQuantity,
                                      },
                                    );

                                    if (response.statusCode == 200) {
                                      // Si la solicitud fue exitosa, puedes mostrar un mensaje de éxito
                                      showDialog(
                                        context: widget
                                            ._scaffoldKey1.currentContext!,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Éxito'),
                                            content: const Text(
                                                'Cantidad actualizada con éxito.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  goToAdminPedidos();
                                                   setState(() {});
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      // Actualizar la cantidad en el modelo de datos local si es necesario
                                      // ...
                                    } else {
                                      // Si la solicitud no fue exitosa, muestra un mensaje de error
                                      showDialog(
                                        context: widget
                                            ._scaffoldKey1.currentContext!,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Error'),
                                            content: const Text(
                                                'Error al actualizar la cantidad.'),
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
                                  },
                                  child: const Text('Guardar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Cerrar el diálogo sin guardar cambios
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancelar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Card(
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
                      ),
                    );
                  },
                )),
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
                        DropdownButton<String>(
                          value: selectedBarcode, // Valor seleccionado
                          onChanged: (String? newValue) {
                            // Actualiza el valor seleccionado
                            setState(() {
                              selectedBarcode = newValue!;
                            });
                          },
                          items: products
                              .map<DropdownMenuItem<String>>((Product product) {
                            return DropdownMenuItem<String>(
                              value: product.barcode,
                              child: Text(
                                  '${product.barcode} - ${product.name}'), // Muestra barcode - nombre
                            );
                          }).toList(),
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
                              'sale_id': '${widget.sale.id}',
                              'barcode': selectedBarcode,
                              'quantity': quantity.toString(),
                            },
                          );
                          if (response.statusCode == 200) {
                            showDialog(
                              context: widget._scaffoldKey1.currentContext!,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Éxito'),
                                  content: const Text(
                                      'Producto guardado con éxito.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        goToAdminPedidos();
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
                            
                          } else {
                            // Si la solicitud no fue exitosa, muestra un mensaje de error
                            showDialog(
                              context: widget._scaffoldKey1.currentContext!,
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
        ],
      ),
    );
  }
}
