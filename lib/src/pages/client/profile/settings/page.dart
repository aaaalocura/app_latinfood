import 'package:app_latin_food/src/pages/client/profile/settings/app_settings.dart';
import 'package:app_latin_food/src/pages/client/profile/settings/datos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientSettings extends StatelessWidget {
  const ClientSettings({super.key, required this.customerId});
  final int customerId;
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
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
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
      body: Center(
        child: Padding(
          padding:  const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Sección "DATOS"
              InkWell(
                onTap: () {
                  Get.to(ClientDatosPage(customerId: customerId));
                },
                child:  Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.person,
                        size: 16,
                        color: Color(0xE5FF5100),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'Edit my Data',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Color(0xE5FF5100),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Divisor
              const Divider(
                height: 2,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              // Sección "APLICACIÓN"
              InkWell(
                onTap: () {
                  Get.to( const ClientSettingsPage());
                },
                child:  Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.settings,
                        size: 16,
                        color: Color(0xE5FF5100),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'APLICACIÓN',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Color(0xE5FF5100),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
