import 'package:app_latin_food/src/models/find_user.dart';
import 'package:app_latin_food/src/pages/client/products/prod/favorite_products.dart';
import 'package:app_latin_food/src/pages/client/profile/address/client_address_page.dart';
import 'package:app_latin_food/src/pages/client/profile/help_support/page.dart';
import 'package:app_latin_food/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:app_latin_food/src/pages/client/profile/my_reward/page.dart';
import 'package:app_latin_food/src/pages/client/profile/payment/page.dart';
import 'package:app_latin_food/src/pages/client/profile/privacy_policy/page.dart';
import 'package:app_latin_food/src/pages/client/profile/settings/page.dart';
import 'package:app_latin_food/src/pages/client/profile/terms_and_conditions/page.dart';
import 'package:app_latin_food/src/pages/home/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable

// ignore: must_be_immutable
class ClientProfileInfoPage extends StatelessWidget {
  final ClientProfileInfoController con =
      Get.put(ClientProfileInfoController());
  HomeController con1 = Get.put(HomeController());

  final int customerId; // Recibe el customerId al abrir la página

  // ructor que recibe el customerId
  ClientProfileInfoPage({Key? key, required this.customerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding:  const EdgeInsets.only(
                right: 10.0), // Ajusta el valor según tu preferencia
            child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/latin-food-8635c.appspot.com/o/splash%2FlogoAnimadoNaranjaLoop.gif?alt=media&token=0f2cb2ee-718b-492c-8448-359705b01923',
              width: 50, // Ajusta el ancho de la imagen según tus necesidades
              height: 50, // Ajusta el alto de la imagen según tus necesidades
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding:  const EdgeInsets.all(15.0),
          child: FutureBuilder<FindCustomer>(
            future: con.lastFetchedCustomerData != null
                ? Future.value(con.lastFetchedCustomerData)
                : fetchCustomerData(
                    customerId), // Llama a la función que obtiene los datos del cliente
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Muestra un indicador de carga mientras se obtienen los datos
                return  const CupertinoAlertDialog(
                  content: Column(
                    children: [
                      CupertinoActivityIndicator(),
                      SizedBox(height: 8),
                      Text('Loading data...'),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                // Muestra un mensaje de error si ocurre un error al obtener los datos
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
                // Si se obtuvieron los datos exitosamente, muestra la información del cliente
                final customer = snapshot.data!;
                 const SizedBox(height: 3);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment:
                          Alignment.center, // Centra el Avatar horizontalmente
                      child: CircleAvatar(
                          radius:
                              40, // Tamaño del avatar (puedes ajustarlo según tus necesidades)
                          backgroundImage:
                              CachedNetworkImageProvider('${customer.image}')),
                    ),
                     const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${customer.name} ${customer.lastName}',
                        style:  const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                     const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${customer.phone}',
                        style:  const TextStyle(
                          fontSize: 10,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                     const SizedBox(height: 3),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () => con1.singOut(),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:  const Color(0xE5FF5100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          textStyle:  const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          minimumSize:  const Size(40, 30),
                        ),
                        child:  const Text('Sign off'),
                      ),
                    ),
                     const SizedBox(height: 20),
                    _buildSectionHeader('Account'),
                     const SizedBox(height: 5),
                    _buildSubSectionItem('Saved Address', Icons.home_outlined,
                        onTap: () {
                      Get.to(ClientAddress());
                    }),
                    _divider(),
                     const SizedBox(height: 5),
                    _buildSubSectionItem(
                        'My Reward', Icons.wallet_giftcard_outlined, onTap: () {
                      Get.to( const ClientMyRewardPage());
                    }),
                    _divider(),
                     const SizedBox(height: 5),
                    _buildSubSectionItem(
                        'My Favorites', Icons.favorite_border_outlined,
                        onTap: () {
                      Get.to(Favoriteprod(
                        customerId: customerId,
                      ));
                    }),
                    _divider(),
                     const SizedBox(height: 5),
                    _buildSubSectionItem('Method of Payment',
                        Icons.account_balance_wallet_outlined, onTap: () {
                      Get.to(PaymentMethodsPage(
                        customerId: customerId,
                      ));
                    }),
                    _divider(),
                     const SizedBox(height: 16),
                    _buildSectionHeader('General'),
                     const SizedBox(height: 5),
                    _buildSubSectionItem(
                        'Settings', Icons.settings_accessibility_outlined,
                        onTap: () {
                      Get.to(ClientSettings(customerId: customerId));
                    }),
                    _divider(),
                     const SizedBox(height: 5),
                    _buildSubSectionItem(
                        'Help and Support', Icons.message_outlined, onTap: () {
                      Get.to( const ClientHelp());
                    }),
                    _divider(),
                     const SizedBox(height: 5),
                    _buildSubSectionItem(
                        'Terms and Conditions', Icons.pages_outlined,
                        onTap: () {
                      Get.to( const ClientTerms());
                    }),
                    _divider(),
                     const SizedBox(height: 5),
                    _buildSubSectionItem(
                        'Privacy Policy', Icons.privacy_tip_outlined,
                        onTap: () {
                      Get.to( const ClientPrivacy());
                    }),
                    _divider(),
                    Expanded(child: Container()),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return  const Divider(
      // Agrega la línea divisora después del ListTile
      color: Colors.grey, // Puedes personalizar el color si lo deseas
      height: 1, // Ajusta el grosor de la línea como desees
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style:  const TextStyle(
        fontSize: 14,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  Widget _buildSubSectionItem(String title, IconData iconData,
      {required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:  const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(
              iconData,
              size: 16,
              color:  const Color(0xE5FF5100),
            ),
             const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style:  const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
             const SizedBox(
              width: 20,
            ),
             const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xE5FF5100),
            ),
          ],
        ),
      ),
    );
  }
}

// Función para obtener los datos del cliente desde la API
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
