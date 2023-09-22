import 'package:app_latin_food/src/pages/admin/pedidos_controller.dart';
import 'package:app_latin_food/src/pages/admin/sale_detail_cargar.dart';
import 'package:flutter/material.dart';

import '../../models/sale_model.dart';

class PedidosAdmin extends StatelessWidget {
  const PedidosAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pedidos Pendientes a Cargar',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        automaticallyImplyLeading: false,
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
      body: FutureBuilder<List<Sale>>(
        future: fetchSales(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error al cargar los datos: ${snapshot.error}'));
          } else {
            final sales = snapshot.data;
            final pendingSales =
                sales?.where((sale) => sale.status == 'PENDING').toList();

            if (pendingSales == null || pendingSales.isEmpty) {
              return const Center(
                  child: Text('No se encontraron ventas pendientes a cargar.'));
            }

            return ListView.builder(
              itemCount: pendingSales.length,
              itemBuilder: (context, index) {
                final sale = pendingSales[index];
                return Card(
                  elevation: 2.0,
                  margin: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID del Pedido: ${sale.id}',
                                style: const TextStyle(fontSize: 16.0)),
                            Text('Total: \$${sale.total}',
                                style: const TextStyle(fontSize: 16.0)),
                            Text('Total de Items: ${sale.items}',
                                style: const TextStyle(fontSize: 16.0)),
                            
                            Text('Estado de Envío: ${sale.statusEnvio}',
                                style: const TextStyle(fontSize: 16.0)),
                            // Agrega más detalles de la venta según tus necesidades.
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 8.0,
                        right: 8.0,
                        child: InkWell(
                          onTap: () {
                            // Cuando se hace clic en el botón "Ver Detalles", navega a la página de detalles.
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SaleDetailPage(
                                  sale: sale,
                                  saleDetails: sale.salesDetails,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: const Text(
                              'Ver Detalles',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
