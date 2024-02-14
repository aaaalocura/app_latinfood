import 'package:app_latin_food/src/pages/admin/pedidos-home/detalle-sale/detalle_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_latin_food/src/models/sale_model.dart';

// ignore: must_be_immutable, camel_case_types
class Detalle_Venta extends StatelessWidget {
  final int saleId;
  final SaleController controller1 = SaleController();
  Detalle_Venta({Key? key, required this.saleId}) : super(key: key);
  Map<int, Product> selectedProducts =
      {}; // Mapa para almacenar productos seleccionados

  @override
  Widget build(BuildContext context) {
    final SaleController saleController = Get.put(SaleController());

    // Llamar a la función fetchSaleDetails con el saleId proporcionado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      saleController.fetchSaleDetails(saleId);
    });

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
          'Detalles del Pedido #$saleId', // Agrega el ID del pedido aquí
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
      body: Obx(() {
        if (saleController.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoActivityIndicator(), // Estilo similar a iOS
                SizedBox(height: 10),
                Text('Cargando productos'), // Texto personalizado
              ],
            ),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Datos del cliente
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Datos del Cliente:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10), // Separación entre elementos
                    Text(
                      'Nombre: ${saleController.sale.value?.customer.name}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5), // Separación entre elementos
                    Text(
                      'Email: ${saleController.sale.value?.customer.email}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5), // Separación entre elementos
                    Text(
                      'Teléfono: ${saleController.sale.value?.customer.phone}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20), // Separación entre elementos
                    const Text(
                      'Datos de la Venta:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10), // Separación entre elementos
                    Text(
                      'ID de Venta: ${saleController.sale.value?.id}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5), // Separación entre elementos
                    Text(
                      'Total: ${saleController.sale.value?.total}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5), // Separación entre elementos
                    Text(
                      'Número de Items: ${saleController.sale.value?.items}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),

              // Más detalles del cliente si es necesario...

              // Botón para agregar producto
              const SizedBox(height: 20),
              Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      ElevatedButton(
        onPressed: () {
          // Show the bottom sheet to add product
          saleController.fetchProducts();
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return GetBuilder<SaleController>(
                builder: (controller) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Seleccionar Productos:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.products.length,
                            itemBuilder: (context, index) {
                              final Product product =
                                  controller.products[index];
                              return ListTile(
                                leading: CachedNetworkImage(
                                  imageUrl:
                                      "https://kdlatinfood.com/intranet/public/storage/products/${product.image ?? ""}",
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Container(),
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.contain,
                                ),
                                title: Text(product.name ?? ''),
                                subtitle: Text(product.barcode ?? ''),
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return QuantityInputModal(
                                        productName: product.name ?? '',
                                        productID: product.barcode!,
                                        saleID: saleId,
                                        onConfirm: (Map<int, Product>
                                            products) {
                                          // Agregar productos al mapa
                                          selectedProducts.addAll(products);
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(228, 222, 21, 21),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('Cancelar',
                                  style: TextStyle(
                                    color: Colors
                                        .white, // Cambia el color del texto a blanco
                                    fontSize: 14.0,
                                  )),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                // Lógica para guardar la cantidad de productos
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xE5FF5100),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('Confirmar',
                                  style: TextStyle(
                                    color: Colors
                                        .white, // Cambia el color del texto a blanco
                                    fontSize: 14.0,
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xE5FF5100),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text('Agregar Productos',
            style: TextStyle(
              color: Colors.white, // Cambia el color del texto a blanco
              fontSize: 14.0,
            )),
      ),
      ElevatedButton(
        onPressed: () {
          _showConfirmationDialog(context, saleId);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xE5FF5100),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Obx(() {
          return controller1.isLoading.value
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : const Text(
                  'Cargar Pedido', // Texto del botón
                  style: TextStyle(
                    color: Colors.white, // Color del texto
                    fontSize: 16, // Tamaño del texto
                  ),
                );
        }),
      ),
    ],
  ),
),


              // Lista de detalles de la venta
              const SizedBox(height: 20),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    // SliverAppBar con el título fijo
                    const SliverAppBar(
                      backgroundColor: Colors.white,
                      automaticallyImplyLeading:
                          false, // Oculta el botón de retorno
                      pinned:
                          true, // Mantiene el título fijo mientras se desplaza
                      flexibleSpace: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Detalles de la Venta:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // SliverList para la lista de detalles de la venta
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final detail =
                              saleController.sale.value!.salesDetails[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            tileColor: const Color.fromARGB(255, 255, 255, 255), // Color de fondo
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            leading: CachedNetworkImage(
                              imageUrl:
                                  "https://kdlatinfood.com/intranet/public/storage/products/${detail.product.image ?? ""}",
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Container(),
                              width: 60,
                              height: 60,
                              fit: BoxFit.contain,
                            ),
                            title: Text(
                              detail.product.name!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Cantidad: ${detail.quantity}, Precio: ${detail.price}',
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.red, // Color del icono
                              onPressed: () {
                                // Eliminar el producto primero
                                controller1
                                    .deleteProductFromSale(saleId: detail.id!)
                                    .then((_) {
                                  // Una vez completada la eliminación, volver a cargar los detalles de la venta
                                  saleController.isLoading.value =
                                      true; // Mostrar CircularProgressIndicator
                                  saleController.fetchSaleDetails(saleId);
                                });
                              },
                            ),
                          );
                        },
                        childCount:
                            saleController.sale.value!.salesDetails.length,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context, int saleId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text('¿Estás seguro de cargar este pedido?'),
          actions: [
            TextButton(
              onPressed: () {
                // Cierra el diálogo sin ejecutar la acción
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                // Cierra el diálogo y ejecuta la acción
                Navigator.of(context).pop();
                controller1.loadOrder(saleId);
              },
              child: const Text(
                'Sí',
                style: TextStyle(color: Colors.black), // Color del texto negro
              ),
            ),
          ],
        );
      },
    );
  }
}

class QuantityInputModal extends StatelessWidget {
  final String productName;
  final String productID;
  final int saleID;
  final Function(Map<int, Product>) onConfirm;
  final SaleController saleController = Get.put(SaleController());
  QuantityInputModal({
    Key? key,
    required this.productName,
    required this.onConfirm,
    required this.productID,
    required this.saleID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController quantityController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Cantidad',
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 7, 7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Cancelar',
                    style: TextStyle(
                      color: Colors.white, // Cambia el color del texto a blanco
                      fontSize: 14.0,
                    )),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  final int quantity = int.parse(quantityController.text);
                  if (quantity > 0) {
                    // Lógica para agregar el producto al mapa
                    saleController
                        .addProductToSale(
                            saleId: saleID,
                            barcode: productID,
                            quantity: quantity)
                        .then((_) {
                      Navigator.of(context).pop();
                      saleController.isLoading.value =
                          true; // Mostrar CircularProgressIndicator
                      saleController.fetchSaleDetails(saleID);
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xE5FF5100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Agregar',
                    style: TextStyle(
                      color: Colors.white, // Cambia el color del texto a blanco
                      fontSize: 14.0,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
