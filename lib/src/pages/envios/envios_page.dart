
import 'package:app_latin_food/src/models/pedidos.dart';
import 'package:app_latin_food/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:app_latin_food/src/pages/envios/envio_detalle.dart';
import 'package:app_latin_food/src/pages/envios/envios_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientOrdersPage extends StatelessWidget {
  final ClientOrdersController con = Get.put(ClientOrdersController());
  final int customerId;
  final ClientProfileInfoController con1 =
      Get.put(ClientProfileInfoController());
  ClientOrdersPage({super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ongoing Transaction'),
        backgroundColor: Colors.white,
        elevation: 0.5,
        flexibleSpace:  FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: const[
              // Coloca aquí la imagen o cualquier otro contenido que desees tener detrás del AppBar

              // BackdropFilter para aplicar el efecto de difuminado
             
            ],
          ),
        ),
        automaticallyImplyLeading: false,
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
      body: ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: FutureBuilder<List<Sale>>(
          future: con.fetchClientOrders(customerId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return   CupertinoAlertDialog(
                content: Column(
                  children: const[
                    CupertinoActivityIndicator(),
                    SizedBox(height: 8),
                    Text('Cargando datos...'),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return   Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:const[
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(milliseconds: 500),
                      child: Icon(
                        Icons
                            .wifi_tethering_off_sharp, // Cambiar por el icono deseado
                        size: 100,
                        color: Color(0xE5FF5100),
                      ),
                    ),
                    SizedBox(height: 16),
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(milliseconds: 500),
                      child: Text(
                        'No tienes conexion a internet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xE5FF5100),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return   Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const[
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(milliseconds: 500),
                      child: Icon(
                        Icons.card_travel, // Cambiar por el icono deseado
                        size: 100,
                        color: Color(0xE5FF5100),
                      ),
                    ),
                    SizedBox(height: 16),
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(milliseconds: 500),
                      child: Text(
                        'No hay pedidos disponibles',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xE5FF5100),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              final orders = snapshot.data!;
              return ListView.builder(
                
                physics: const BouncingScrollPhysics(),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Card(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey[300]!),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Order # ${order.id}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${con1.user.address}',
                                        style: const TextStyle(
                                          fontSize:
                                              14, // Tamaño de fuente en sp
                                          height: 1.5, // Altura de línea en sp
                                          fontFamily:
                                              'Inter', // Nombre de la fuente (si se ha agregado a los recursos)
                                          fontWeight: FontWeight
                                              .w400, // Peso de la fuente (400 es igual a FontWeight.normal)
                                          color: Color(
                                              0xFF999999), // Color del texto en formato ARGB (8 dígitos hexadecimales)
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: InkWell(
                              onTap: () {
                                // Navegar a la página de detalle del envío
                                Get.to(() => EnvioDetallePage(order: order));
                              },
                              child: Column(
                                children: [
                                  // ...otros widgets
                                  Row(
                                    children: [
                                      const Text(
                                        'Status: ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          // Negritas
                                          color: Color.fromARGB(228, 2, 2,
                                              2), // Color personalizado
                                        ),
                                      ),
                                      Text(
                                        '${order.status}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                              FontWeight.bold, // Negritas
                                          color: Color(
                                              0xE5FF5100), // Color personalizado (mismo que el anterior)
                                        ),
                                      ),
                                      const Spacer(), // Este widget empujará el Icon hacia la derecha
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: Color(0xE5FF5100),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
