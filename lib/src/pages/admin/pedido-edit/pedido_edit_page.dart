import 'package:app_latin_food/src/models/sale_model.dart';
import 'package:app_latin_food/src/pages/admin/pedido-edit/controller.dart';
import 'package:app_latin_food/src/pages/admin/pedido-edit/prod_add_sale.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaleEditPage extends StatefulWidget {
  final SaleEditController con = Get.put(SaleEditController());
  final Sale sale;
  final List<SaleDetail> saleDetails;

  SaleEditPage({Key? key, required this.sale, required this.saleDetails})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SaleEditPageState createState() => _SaleEditPageState();
}

class _SaleEditPageState extends State<SaleEditPage> {
  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();

    widget.con.loadProducts();
  }
 @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Llamar a _loadSales cuando cambien las dependencias (como el enrutamiento)
     widget.con.fetchSales();
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
          'Editar Pedido #${widget.sale.id}', // Agrega el ID del pedido aquí
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
      backgroundColor: Colors.white,
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
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddProdcutSalePage(
                              sale: widget.sale,
                              saleDetails: widget.sale.salesDetails,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            const Color(0xE5FF5100), // Color del texto blanco
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              19.0), // Esquinas redondeadas
                        ),
                      ),
                      child: const Text('ADD'),
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
                                        labelText: 'Cantidad',
                                      ),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    onPressed: () async {
                                      String newQuantity =
                                          quantityController.text;
                                      if (newQuantity.isEmpty) {
                                        // Muestra un mensaje de error si el campo de cantidad está vacío
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Error'),
                                              content: const Text(
                                                  'Por favor, ingresa una cantidad válida.'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Aceptar'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        int parsedQuantity =
                                            int.tryParse(newQuantity) ?? 0;
                                        Navigator.of(context)
                                            .pop(); // Cierra el cuadro de diálogo principal
                                        widget.con
                                            .updateProductQuantity(
                                          saleId: widget.sale.id,
                                          productId: product.id!,
                                          newQuantity: parsedQuantity,
                                        )
                                            .then((_) {
                                          setState(() {
                                            detail.quantity = parsedQuantity;
                                          });
                                        });
                                        quantityController.clear();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color(
                                          0xE5FF5100), // Color del texto blanco
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            19.0), // Esquinas redondeadas
                                      ),
                                    ),
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
                              product.name!,
                              style: const TextStyle(fontSize: 18.0),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Price: \$${detail.price.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                                Text(
                                  'Quantity of Items: ${detail.quantity}',
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                                const SizedBox(height: 16.0),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                  Icons.delete), // Icono de bote de basura
                              onPressed: () {
                                // Muestra un cuadro de diálogo de confirmación
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                          '¿Seguro de eliminar este producto?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            // Cierra el cuadro de diálogo sin hacer nada si se presiona "No"
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('No'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            widget.con
                                                .deleteProductFromSale(
                                              saleDetailId: detail.id!,
                                            )
                                                .then((_) {
                                              setState(() {
                                                widget.saleDetails.remove(detail); 
                                              });
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: const Color(
                                                0xE5FF5100), // Color del texto blanco
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  19.0), // Esquinas redondeadas
                                            ),
                                          ),
                                          child: const Text('Sí'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
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
    );
  }
}
