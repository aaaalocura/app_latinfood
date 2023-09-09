import 'package:app_latin_food/src/pages/admin/firma_sale.dart';
import 'package:app_latin_food/src/pages/admin/pedidos_controller.dart';
import 'package:app_latin_food/src/pages/admin/sale_detail_page.dart';
import 'package:flutter/material.dart';
import '../../models/sale_model.dart';

class SalesListPage extends StatefulWidget {
  const SalesListPage({super.key});

  @override
  _SalesListPageState createState() => _SalesListPageState();
}

class _SalesListPageState extends State<SalesListPage> {
  List<Sale> sales = [];

  // Añade una variable para evitar consultas repetitivas a la API
  bool _isLoading = false;

  // Agrega una función para cargar las ventas desde la API
  Future<void> _loadSales() async {
    if (_isLoading) {
      return; // Evitar consultas repetitivas
    }
    setState(() {
      _isLoading = true;
    });

    try {
      final salesData = await fetchSales();
      setState(() {
        sales = salesData;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
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
            title: 'PENDING TO SEND',
            sales: sales.where((sale) => sale.statusEnvio == 'PENDIENTE').toList(),
          ),
          SalesSection1(
            title1: 'EN RECORRIDO',
            sales1: sales.where((sale) => sale.statusEnvio == 'ACTUAL').toList(),
          ),
          SalesSection(
            title: 'COMPLETADOS',
            sales: sales.where((sale) => sale.statusEnvio == 'FIN').toList(),
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
      title: Text(title1),
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
              return ListTile(
                title: Text('Venta #${sale.id}'),
                subtitle: Text('Total: \$${sale.total}'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SaleDetailPageFirma(
                        sale: sale,
                        saleDetails: const [],
                      ), // Pasa la venta seleccionada
                    ),
                  );
                },
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
      title: Text(title),
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
              return ListTile(
                title: Text('Venta #${sale.id}'),
                subtitle: Text('Total: \$${sale.total}'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SaleDetailPage(
                        sale: sale,
                      ), // Pasa la venta seleccionada
                    ),
                  );
                },
              );
            },
          ),
      ],
    );
  }
}
