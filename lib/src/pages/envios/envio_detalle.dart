import 'package:app_latin_food/src/models/pedidos.dart';
import 'package:app_latin_food/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class EnvioDetallePage extends StatelessWidget {
  final Sale order;

  EnvioDetallePage({Key? key, required this.order}) : super(key: key);
  final ClientProfileInfoController con =
      Get.put(ClientProfileInfoController());

  bool isPendingCompleted = false;
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
        title: const Text('Detail'),
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circles and Line representing status
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    _StatusCircle(
                      isCompleted:
                          order.status == "PENDING" || order.status == "PAID",
                    ),
                    const SizedBox(
                        height: 8.0), // Espacio entre el círculo y el texto
                    const _StatusText(
                      text: 'Ordered',
                    ), // Texto debajo del primer círculo
                  ],
                ),
                _CustomLine(), // Línea personalizada
                Column(
                  children: [
                    _StatusCircle(isCompleted: order.status == "PAID"),
                    const SizedBox(height: 8.0),
                    const _StatusText(
                      text: 'Confirmed',
                    ),
                  ],
                ),
                _CustomLine(),
                Column(
                  children: [
                    _StatusCircle(
                      isCompleted: order.statusEnvio == "ACTUAL" ||
                          order.statusEnvio == "FIN",
                    ),
                    const SizedBox(height: 8.0),
                    const _StatusText(
                      text: 'On Transit',
                    ),
                  ],
                ),
                _CustomLine(),
                Column(
                  children: [
                    _StatusCircle(
                      isCompleted: order.statusEnvio == "FIN",
                    ),
                    const SizedBox(height: 8.0),
                    const _StatusText(
                      text: 'Complete',
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Text 'Delivery Details'
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delivery Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:
                        Color(0xE5FF5100), // O cualquier otro color que desees
                  ),
                ),
                const SizedBox(height: 12),
                // Customer Card
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Customer Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Divider(
                          height: 24,
                          color: Colors
                              .grey, // Un divisor para mejorar la separación visual
                        ),
                        const Text(
                          'Name:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${con.user.name} ${con.user.lastName}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Phone:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${con.user.phone}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Address:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${con.user.address}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Order Date:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${order.createdAt}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
              ],
            ),

            const SizedBox(height: 18),
            // Text 'Delivery Details'
            const Text(
              'Products Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xE5FF5100), // O cualquier otro color que desees
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: ListView.builder(
                itemCount: order.salesDetails.length,
                itemBuilder: (context, index) {
                  final detail = order.salesDetails[index];
                  return _buildOrderDetailItem(detail);
                  
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailItem(SaleDetail detail) {
    return Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_cart,
                  size: 36,
                  color: Color(0xE5FF5100),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail.product?.name ?? 'Product Name Not Available',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Quantity: ${detail.quantity ?? 0}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total: \$${(double.parse(detail.price ?? '0.0') * (detail.quantity ?? 0)).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}

class _CustomLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20.0, // Ancho de la línea (ajusta según sea necesario)
      child: CustomPaint(
        painter: LinePainter(), // CustomPainter que dibuja la línea
      ),
    );
  }
}

// CustomPainter para dibujar la línea
class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black // Color de la línea (ajusta según sea necesario)
      ..strokeWidth = 2.0; // Ancho de la línea (ajusta según sea necesario)

    final Offset start =
        Offset(size.width / 2, 0); // Comienza en la parte superior
    final Offset end =
        Offset(size.width / 2, size.height); // Termina en la parte inferior

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class _StatusText extends StatelessWidget {
  final String text;

  const _StatusText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top:
              10.0), // Ajusta el espacio entre el círculo y el texto según sea necesario
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10, // Ajusta el tamaño de fuente según sea necesario
          color: Colors.green, // Ajusta el color de texto según sea necesario
        ),
      ),
    );
  }
}

class _StatusCircle extends StatelessWidget {
  final bool isCompleted;

  const _StatusCircle({Key? key, required this.isCompleted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green : Colors.grey,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: isCompleted
                ? Colors.green.withOpacity(0.5)
                : Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(
                0, 2), // Cambia el desplazamiento vertical según lo desees
          ),
        ],
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 18)
            : const Icon(Icons.check, color: Colors.transparent, size: 18),
      ),
    );
  }
}
