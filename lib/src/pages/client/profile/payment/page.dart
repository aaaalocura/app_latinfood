import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:app_latin_food/src/models/find_user.dart';
import 'package:app_latin_food/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: use_key_in_widget_ructors
class PaymentMethodsPage extends StatelessWidget {
  final ClientProfileInfoController con =
      Get.put(ClientProfileInfoController());
  final int customerId;

  // ructor que recibe el customerId
  PaymentMethodsPage({Key? key, required this.customerId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:  const Icon(
            Icons.arrow_back_ios,
            color: Color(0xE5FF5100),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title:  const Text('Payment Methods'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
          actions: [
    Padding(
      padding:  const EdgeInsets.only(right: 10.0), // Ajusta el valor según tu preferencia
      child: Image.network(
        'https://firebasestorage.googleapis.com/v0/b/latin-food-8635c.appspot.com/o/splash%2FlogoAnimadoNaranjaLoop.gif?alt=media&token=0f2cb2ee-718b-492c-8448-359705b01923',
        width: 50, // Ajusta el ancho de la imagen según tus necesidades
        height: 50, // Ajusta el alto de la imagen según tus necesidades
      ),
    ),
  ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding:  const EdgeInsets.all(20.0),
          child: FutureBuilder<FindCustomer>(
            future: fetchCustomerData(customerId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return  const CupertinoAlertDialog(
                  content: Column(
                    children: [
                      CupertinoActivityIndicator(),
                      SizedBox(height: 8),
                      Text('Cargando datos...'),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                 return  const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
              } else {
                final customer = snapshot.data!;
                return Align(
                  alignment:
                      Alignment.topCenter, // Alineación en la parte superior
                  child: Column(
                    children: [
                      SizedBox(
                        width:
                            300, // Ancho del Card (ajústalo según tus necesidades)
                        height: 150,
                        child: Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding:  const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 const Text(
                                  'Wallet:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                                 const SizedBox(height: 10),
                                Text(
                                  '\$${customer.saldo} USD',
                                  style:  const TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xE5FF5100),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width:
                            300, // Ancho del Card (ajústalo según tus necesidades)
                        height: 150,
                        child: Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child:  const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Credit and Debit Card:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 5, 5, 5),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Proximamente',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xE5FF5100),
                                  ),
                                ),
                                // Contenido del segundo Card
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width:
                            300, // Ancho del Card (ajústalo según tus necesidades)
                        height: 150,
                        child: Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child:  const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PayPal',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 27, 4, 131),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Proximamente',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xE5FF5100),
                                  ),
                                ),
                                // Contenido del segundo Card
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

Future<FindCustomer> fetchCustomerData(int customerId) async {
  var maxAttempts = 3; // Número máximo de intentos
  var attempts = 0;

  while (attempts < maxAttempts) {
    try {
      final url =
          'https://kdlatinfood.com/intranet/public/api/clientes/findUser/$customerId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return FindCustomer.fromJson(jsonData);
      } else {
        throw Exception('Failed to load customer data');
      }
    } catch (e) {
      attempts++;
    }
  }

  throw Exception('Failed after $maxAttempts attempts');
}
