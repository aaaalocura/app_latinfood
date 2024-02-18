// ignore_for_file: library_private_types_in_public_api

import 'package:app_latin_food/src/models/sale_model.dart';
import 'package:app_latin_food/src/pages/admin/pedido-on-transit/pedido_ontransit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaleDetailItem extends StatelessWidget {
  final SaleDetail detail;

  const SaleDetailItem({required this.detail, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    QRScannerController qrScannerController = Get.put(QRScannerController());

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Obx(() {
        return ListTile(
          leading: IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () {
              qrScannerController.scanQR(
                context,
                detail.product.KeyProduct!,
                detail.productID,
                detail.saleID,
                detail.id,
                detail.scanned,
              );
            },
          ),
          title: Text(detail.product.name!),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SKU: ${detail.product.barcode}'),
              Text('Precio: \$${detail.price}'),
              Text('Cantidad: ${detail.scanned}'),
              Text('Id: ${detail.product.id}'),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Usar el valor observable scanned para determinar el color del icono
                  qrScannerController.scanned.value == 0
                      ? const CircularProgressIndicator()
                      : Icon(
                          Icons.check_circle_outline_outlined,
                          size: 24.0,
                          color: qrScannerController.scanned.value == 1
                              ? Colors.green
                              : Colors.grey,
                        ),
                  Text(
                    qrScannerController.scanned.value == 0
                        ? 'No escaneado'
                        // ignore: unrelated_type_equality_checks
                        : qrScannerController.scanned == 1
                            ? 'Producto Escaneado'
                            : 'Producto sin escanear',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}


class SaleDetailPageN extends StatefulWidget {
  final Sale sale;

  const SaleDetailPageN(
      {Key? key, required this.sale, required List<SaleDetail> saleDetails})
      : super(key: key);

  @override
  _SaleDetailPageState createState() => _SaleDetailPageState();
}

class _SaleDetailPageState extends State<SaleDetailPageN> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalle de la venta #${widget.sale.id}',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID del Pedido: ${widget.sale.id}',
                      style: const TextStyle(
                        fontSize: 18.0,
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
                Text(
                  'Total: \$${widget.sale.total}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Total de Items: ${widget.sale.items}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Estado de la Compra: ${widget.sale.status}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Estado de Envío: ${widget.sale.statusEnvio}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 16.0),
                const Text('Productos en el Pedido',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.sale.salesDetails.length,
                    itemBuilder: (context, index) {
                      final detail = widget.sale.salesDetails[index];
                      return SaleDetailItem(detail: detail);
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
