import 'package:app_latin_food/src/pages/admin/pedidos-home/add-product-to-sale/add_product_controller.dart';
import 'package:app_latin_food/src/pages/admin/pedidos-home/pedido-detalle/detalle_controller.dart';
import 'package:flutter/material.dart';
import 'package:app_latin_food/src/models/sale_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SaleDetailPageEditNew extends StatelessWidget {
  final Sale sale;
  final List<SaleDetail> saleDetails;
  final SaleDetailController controller =
      SaleDetailController(); // Instancia del controlador
  final AddProductToSaleController _controller =
      Get.put(AddProductToSaleController());

  SaleDetailPageEditNew(
      {super.key, required this.sale, required this.saleDetails});

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
          'Edicion #${sale.id}', // Agrega el ID del pedido aquí
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cliente: ${sale.customer.name} ${sale.customer.lastName}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showProductListBottomSheet(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xE5FF5100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Agregar Productos'),
                ),
              ],
            ),
            Text(
              'Fecha: ${DateFormat('yyyy-MM-dd').format(sale.createdAt)}',
            ),
            Text('Total: ${sale.total}'),
            Text('Items: ${sale.items}'),
            Text('Estado: ${sale.status}'),
            const SizedBox(height: 16),
            const Text(
              'Detalles del Pedido:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            
            ListView.builder(
              shrinkWrap: true,
              itemCount: sale.salesDetails.length,
              itemBuilder: (context, index) {
                SaleDetail detail = sale.salesDetails[index];
                return ListTile(
                  leading: detail.product.image != null
                      ? Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/latin-food-8635c.appspot.com/o/splash%2FlogoAnimadoNaranjaLoop.gif?alt=media&token=0f2cb2ee-718b-492c-8448-359705b01923',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey,
                        ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(detail.product.name ?? 'N/A'),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, detail);
                        },
                      ),
                    ],
                  ),
                  subtitle: Text('SKU: ${detail.product.barcode} \n Items: ${detail.quantity} \n'),
                  
                  onTap: () {
                    _showProductDetailsModal(context, detail);
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Llama a la función loadOrder cuando se presiona el botón flotante
          _showConfirmationDialog(context, sale.id);
        },
        child: Obx(() {
          return controller.isLoading.value
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : const Icon(Icons.save);
        }),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, SaleDetail detail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Está seguro de que desea eliminar este producto?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _removeProduct(detail);
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _removeProduct(SaleDetail detail) {
  // Lógica para eliminar el producto
  controller.deleteProductFromSale(saleDetailId: detail.id!);
}


  void _showProductDetailsModal(BuildContext context, SaleDetail detail) {
    TextEditingController quantityController =
        TextEditingController(text: detail.quantity.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalles del producto'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nombre: ${detail.product.name ?? 'N/A'}'),
              Text('SKU: ${detail.product.barcode}'),
              const Text('Cantidad:'),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _updateProductQuantity(detail, quantityController.text);
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _updateProductQuantity(SaleDetail detail, String newQuantity) {
    // Agrega aquí la lógica para actualizar la cantidad del producto
    // Puedes actualizar el estado y volver a construir la interfaz de usuario
  }

  // Función para mostrar el diálogo de confirmación
  Future<void> _showConfirmationDialog(BuildContext context, int saleId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text('¿Estás seguro de confirmar los cambios?'),
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

  Future<void> _showProductListBottomSheet(BuildContext context) async {
    await _controller
        .loadProducts(); // Cargar los productos antes de mostrar el BottomSheet

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Selecciona productos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _controller.products.length,
                itemBuilder: (context, index) {
                  final product = _controller.products[index];
                  return ListTile(
                    title: Row(
                      children: [
                        Checkbox(
                          value: product.isSelected,
                          onChanged: (value) {
                            _controller.toggleProductSelection(index);
                          },
                        ),
                        Text(product.name!),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _handleConfirmSelection();
                Get.back(); // Cerrar el BottomSheet
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xE5FF5100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Confirmar Selección'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleConfirmSelection() {
    // Aquí puedes manejar la confirmación de la selección
    // Recorre la lista de productos en _controller.products
    // y realiza acciones en función de si cada producto está seleccionado o no.
  }
}
