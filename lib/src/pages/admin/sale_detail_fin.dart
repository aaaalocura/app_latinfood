import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/sale_model.dart';

class SaleDetailPageFin extends StatelessWidget {
  final Sale sale;
  final List<SaleDetail> saleDetails;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SaleDetailPageFin({super.key, required this.sale, required this.saleDetails});
  void goToAdminPedidos() {
    Get.toNamed('/homeadmin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Detalle del pedido',
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
            Text('ID del Pedido: ${sale.id}',
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold)),
            Text('Total: ${sale.total}',
                style: const TextStyle(fontSize: 16.0)),
            Text('Total de Items: ${sale.items}',
                style: const TextStyle(fontSize: 16.0)),
            Text('Estado de la Compra: ${sale.status}',
                style: const TextStyle(fontSize: 16.0)),
            Text('Estado de Envío: ${sale.statusEnvio}',
                style: const TextStyle(fontSize: 16.0)),
            const SizedBox(
                height: 16.0), // Espacio entre detalles y lista de productos
            const Text('Productos en el Pedido',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: saleDetails.length,
                itemBuilder: (context, index) {
                  final detail = saleDetails[index];
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

    );
  }
}
