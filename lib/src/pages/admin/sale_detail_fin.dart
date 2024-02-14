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
          'Detalle del pedido FIN',
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_cart,
                          size: 28.0,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'Order ID: ${sale.id}',
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: \$${sale.total}',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          'Total Items: ${sale.items}',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      'Order Status: ${sale.status}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      'Shipment Status: ${sale.statusEnvio}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    const Row(
                      children: [
                        Icon(
                          Icons.shopping_basket,
                          size: 24.0,
                          color: Colors.green,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Products in Order',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              "https://kdlatinfood.com/intranet/public/storage/products/${detail.product.image ?? ""}",
                              width:
                                  80.0, // Ajusta el ancho de la imagen según sea necesario
                              height:
                                  80.0, // Ajusta la altura de la imagen según sea necesario
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            product.name!,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Precio: \$${detail.price}',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              Text(
                                'Cantidad: ${detail.quantity}',
                                style: const TextStyle(fontSize: 16.0),
                              ),
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
        ),
      ),
    );
  }
}
