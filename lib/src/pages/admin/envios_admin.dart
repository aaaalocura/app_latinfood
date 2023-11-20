import 'package:app_latin_food/src/pages/admin/firma_sale.dart';
import 'package:app_latin_food/src/pages/admin/pedidos_controller.dart';
import 'package:app_latin_food/src/pages/admin/sale_detail_fin.dart';

import 'package:flutter/material.dart';
import '../../models/sale_model.dart';
import 'pedido-on-transit/pedido_ontransit_page.dart';

class SalesListPage extends StatefulWidget {
  const SalesListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SalesListPageState createState() => _SalesListPageState();
}

class _SalesListPageState extends State<SalesListPage> {
  List<Sale> sales = [];

  // Añade una variable para evitar consultas repetitivas a la API
  bool _isLoading = false;

  // Agrega una función para cargar las ventas desde la API
  Future<void> _loadSales() async {
    if (_isLoading || !mounted) {
      return; // Evitar consultas repetitivas o si el widget ya no está montado
    }
    setState(() {
      _isLoading = true;
    });

    try {
      final salesData = await fetchSales();
      if (mounted) {
        setState(() {
          sales = salesData;
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      // Manejar errores si es necesario
      // ignore: avoid_print
      print('Error fetching sales: $error');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Llamar a _loadSales cuando cambien las dependencias (como el enrutamiento)
    _loadSales();
  }

  @override
  Widget build(BuildContext context) {
    // Llamar a _loadSales en el método build para realizar la consulta
    _loadSales();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Envios',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
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
      body: ListView(
        children: [
          SalesSection(
            title: 'Pending To Send',
            sales: sales
                .where((sale) =>
                    sale.status == 'PAID' && sale.statusEnvio == 'PENDIENTE')
                .toList(),
          ),
          SalesSection1(
            title1: 'On Transit',
            sales1:
                sales.where((sale) => sale.statusEnvio == 'ACTUAL').toList(),
          ),
          SalesSection2(
            title2: 'Received',
            sales2: sales.where((sale) => sale.statusEnvio == 'FIN').toList(),
          ),
        ],
      ),
    );
  }
}

class SalesSection1 extends StatelessWidget {
  final String title1;
  final List<Sale> sales1;

  // ignore: prefer_const_constructors_in_immutables
  SalesSection1({super.key, required this.title1, required this.sales1});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          Text(title1),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 20.0), // Espacio entre el texto y la franja
              height: 10.0, // Altura de la franja verde
              decoration: BoxDecoration(
                color: Colors.yellow, // Color de la franja verde
                borderRadius: BorderRadius.circular(
                    5.0), // Radio para esquinas redondeadas
              ),
            ),
          ),
        ],
      ),
      children: [
        if (sales1.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Sin información'),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sales1.length,
            itemBuilder: (context, index) {
              final sale = sales1[index];
              return Card(
                elevation: 4.0,
                margin: const EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: InkWell(
                    onTap: () {
                      // Navega a la página de detalles cuando se hace clic.
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SaleDetailPageFirma(
                            sale: sale,
                            saleDetails: sale.salesDetails,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.orange, Colors.deepOrange],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ID del Pedido: ${sale.id}',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Total: \$${sale.total}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Estado de Envío: ${sale.statusEnvio}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Client: ${sale.customer.name} ${sale.customer.lastName}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Address Client: ${sale.customer.address} ',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 24.0,
                              ),
                              child: Text(
                                'Cambiar Estado',
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class SalesSection extends StatelessWidget {
  final String title;
  final List<Sale> sales;

  // ignore: prefer_const_constructors_in_immutables
  SalesSection({super.key, required this.title, required this.sales});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          Text(title),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 20.0), // Espacio entre el texto y la franja
              height: 10.0, // Altura de la franja verde
              decoration: BoxDecoration(
                color: const Color(0xE5FF5100), // Color de la franja verde
                borderRadius: BorderRadius.circular(
                    5.0), // Radio para esquinas redondeadas
              ),
            ),
          ),
        ],
      ),
      children: [
        if (sales.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Sin información'),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sales.length,
            itemBuilder: (context, index) {
              final sale = sales[index];
              return Card(
                elevation: 4.0,
                margin: const EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: InkWell(
                    onTap: () {
                      // Navega a la página de detalles cuando se hace clic.
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SaleDetailPageN(
                            sale: sale,
                            saleDetails: sale.salesDetails,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.orange, Colors.deepOrange],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ID del Pedido: ${sale.id}',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Total: \$${sale.total}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Estado de Envío: ${sale.statusEnvio}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Client: ${sale.customer.name} ${sale.customer.lastName}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Address Client: ${sale.customer.address} ',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ), // Espacio entre detalles y botón
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 24.0,
                              ),
                              child: Text(
                                'Cambiar Estado',
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class SalesSection2 extends StatelessWidget {
  final String title2;
  final List<Sale> sales2;

  // ignore: prefer_const_constructors_in_immutables
  SalesSection2({super.key, required this.title2, required this.sales2});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          Text(title2),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 20.0), // Espacio entre el texto y la franja
              height: 10.0, // Altura de la franja verde
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                    228, 53, 255, 22), // Color de la franja verde
                borderRadius: BorderRadius.circular(
                    5.0), // Radio para esquinas redondeadas
              ),
            ),
          ),
        ],
      ),
      children: [
        if (sales2.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Sin información'),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sales2.length,
            itemBuilder: (context, index) {
              final sale = sales2[index];
              return Card(
                elevation: 4.0,
                margin: const EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: InkWell(
                    onTap: () {
                      // Navega a la página de detalles cuando se hace clic.
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SaleDetailPageFin(
                            sale: sale,
                            saleDetails: const [],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.orange, Colors.deepOrange],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ID del Pedido: ${sale.id}',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Total: \$${sale.total}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Estado de Envío: ${sale.statusEnvio}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Client: ${sale.customer.name} ${sale.customer.lastName}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Address Client: ${sale.customer.address} ',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 24.0,
                              ),
                              child: Text(
                                'Ver Detalles',
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
