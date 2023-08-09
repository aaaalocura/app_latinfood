import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientHelp extends StatelessWidget {
  const ClientHelp({super.key});

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
          'Help and Support',
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.support,
              size: 100, // Ajustamos el tamaño del ícono a 100x100
              color: Theme.of(context)
                  .primaryColor, // Utilizamos el color primario del tema
            ),
            const SizedBox(height: 20),
            Text(
              'Do you need help or have any questions?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'We are here to help you. Contact us by email and we will reply to you as soon as possible.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'soporte@oyarceroup.com',
                );

                // ignore: deprecated_member_use
                launch(emailLaunchUri
                    .toString()); // Abre la aplicación de correo electrónico
              },
              icon: const Icon(Icons.email), // Icono de email
              label: const Text('Contact Support'), // Texto del botón
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    Theme.of(context).primaryColor, // Color del texto del botón
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
