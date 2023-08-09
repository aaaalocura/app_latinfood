import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientSettingsPage extends StatelessWidget {
  const ClientSettingsPage({super.key});

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
          'App Settings',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
          actions: [
    Padding(
      padding: const EdgeInsets.only(right: 10.0), // Ajusta el valor según tu preferencia
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: InkWell(
                onTap: () {
                  //Get.to(ClientDatosPage());
                },
                child: Padding(
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
                          'Mas Ajustes Proximamente',
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
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Cambiar el tema de la aplicación al tema oscuro
                Get.changeTheme(ThemeData.dark());
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      20), // Ajusta el valor según el radio que desees
                ),
              ),
              child: const Text(
                'Cambiar a tema oscuro',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
