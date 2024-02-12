import 'package:app_latin_food/src/pages/admin/pedidos-home/pedido-detalle/detalle_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app_latin_food/src/models/sale_model.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class SaleDetailPageNew extends StatelessWidget {
  final Sale sale;
  final List<SaleDetail> saleDetails;
  final SaleDetailController controller =
      SaleDetailController(); // Instancia del controlador

  // ignore: use_key_in_widget_constructors
  SaleDetailPageNew({Key? key, required this.sale, required this.saleDetails}) {
    // Actualiza la lista en el controlador al inicializar la página
    controller.salesDetails.assignAll(saleDetails);
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
          'Detalles del Pedido #${sale.id}', // Agrega el ID del pedido aquí
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ...
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cliente: ${sale.customer.name} ${sale.customer.lastName}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Obx(() => ElevatedButton(
                      onPressed: () async {
                        // Cargar la lista de productos

                        await controller.showProductBottomSheet(sale.id);
                        controller.updateSaleDetails(sale.salesDetails);
                        if (kDebugMode) {
                          print(
                              'Productos seleccionados: ${controller.selectedProducts.values}');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xE5FF5100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        controller.isEditing.value
                            ? 'Cancelar'
                            : 'Add Products',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                        ),
                      ),
                    ))
              ],
            ),
            // ...
            const SizedBox(height: 16),
            const Text(
              'Detalles del Pedido:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Obx(() => ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.salesDetails.length,
                  itemBuilder: (context, index) {
                    SaleDetail detail = controller.salesDetails[index];
                    return GestureDetector(
                      onTap: () {
                        controller.showEditProductBottomSheet(detail);
                      },
                      child: ListTile(
                        leading: CachedNetworkImage(
                          imageUrl:
                              "https://kdlatinfood.com/intranet/public/storage/products/${detail.product.image ?? ""}",
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) {
                            return Container();
                          },
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                        title: Text(detail.product.name ?? 'N/A'),
                        subtitle: Text('SKU: ${detail.product.barcode}'),
                        trailing: Visibility(
                          visible: controller.showDeleteButtons.value == false,
                          child: IconButton(
                            onPressed: () async {
                              await controller.deleteProductFromSale(
                                saleDetailId: detail.id!,
                              );
                              sale.salesDetails.removeWhere(
                                  (element) => element.id == detail.id);
                              controller.update();
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      ),
                    );
                  },
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Llama a la función loadOrder cuando se presiona el botón flotante
          _showConfirmationDialog(context, sale.id);
        },
        backgroundColor: const Color(0xE5FF5100),
        child: Obx(() {
          return controller.isLoading.value
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : const Icon(
                  Icons.cloud_upload_rounded,
                  color: Colors.white, // Establece el color del icono en blanco
                );
        }),
      ),
    );
  }

  // Función para mostrar el diálogo de confirmación
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
                controller.loadOrder(saleId);
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

// Función para mostrar el BottomSheet de edición de cantidad
  void _showEditQuantityBottomSheet(BuildContext context, SaleDetail detail) {
    int currentQuantity = detail.quantity; // Obtener la cantidad actual

    showModalBottomSheet(
      isScrollControlled: true, // Hace que el BottomSheet sea más alto
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Editar cantidad para ${detail.product.name}'),
                    const SizedBox(height: 10),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                          text: currentQuantity.toString()),
                      onChanged: (value) {
                        setState(() {
                          currentQuantity = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cerrar BottomSheet
                          },
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // Llama a la función para actualizar la cantidad
                            await controller.updateProductQuantity(
                              saleId: detail.saleID,
                              productId: detail.productID,
                              newQuantity: currentQuantity,
                            );
                            Navigator.of(context).pop(); // Cerrar BottomSheet
                          },
                          child: const Text('Confirmar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
