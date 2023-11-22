// ignore_for_file: avoid_print, unused_import

import 'package:app_latin_food/src/models/sale_model.dart';
import 'package:app_latin_food/src/pages/admin/botonbar.dart';
import 'package:app_latin_food/src/pages/admin/pedido-edit/controller.dart';
import 'package:app_latin_food/src/pages/admin/sale_detail_cargar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_latin_food/src/pages/admin/pedidos_controller.dart';

class AddProdcutSalePage extends StatefulWidget {
  final SaleEditController con = Get.put(SaleEditController());
  final Sale sale;
  final List<SaleDetail> saleDetails;

  AddProdcutSalePage({Key? key, required this.sale, required this.saleDetails})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SaleEditPageState createState() => _SaleEditPageState();
}

class _SaleEditPageState extends State<AddProdcutSalePage> {
  TextEditingController quantityController = TextEditingController();

  int quantity = 1;
  Product? selectedProduct; // Declarar selectedProduct como variable de estado
  Product? selectedProduct1;
  @override
  void initState() {
    super.initState();
    // Cargar los detalles de la venta al cargar la página
    widget.con.fetchSales();
    widget.con.loadProducts();
    // Establecer el valor inicial de selectedProduct
  }

  // Añade una variable para evitar consultas repetitivas a la API
  bool _isLoading = false;
  List<Sale> sales = [];
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
      print('Error fetching sales: $error');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() {
      print("llamando funcion");
      _loadSales();
    });
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
          'Add Product #${widget.sale.id}', // Agrega el ID del pedido aquí
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
                  ],
                ),
                const SizedBox(height: 16.0),
                DropdownButton<String>(
                  value: selectedProduct1
                      ?.name, // Aquí se usa el nombre del producto como valor
                  items: widget.con.products.map((Product product) {
                    return DropdownMenuItem<String>(
                      value: product
                          .name!, // Aquí se establece el nombre como valor
                      child: SizedBox(
                        width: 270,
                        height: 90,
                        child: Text(
                          "${product.barcode!} - ${product.name!}",
                          overflow: TextOverflow
                              .ellipsis, // Trunca el texto con tres puntos suspensivos
                          maxLines: 2, // Limita el texto a una línea
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    // Actualiza el producto seleccionado
                    setState(() {
                      selectedProduct1 = widget.con.products.firstWhere(
                        (product) => product.name == newValue,
                      );
                    });

                    print(selectedProduct1?.name);
                    print(selectedProduct1?.barcode);
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad',
                  ),
                  onChanged: (String value) {
                    // Actualiza la cantidad
                    quantity = int.tryParse(value) ?? 0;
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Llama a la función para agregar el producto a la venta
                        await widget.con.addProductToSale(
                          saleId: widget.sale.id,
                          barcode: selectedProduct1!.barcode!,
                          quantity: quantity,
                        );
                        quantityController.clear();
                        widget.con.loadProducts();

                        Get.toNamed('/homeadmin');
                        
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
                      child: const Text('Save'),
                    ),
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
