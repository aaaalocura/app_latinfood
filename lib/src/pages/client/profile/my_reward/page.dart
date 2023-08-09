import 'package:flutter/material.dart';

class ClientMyRewardPage extends StatelessWidget {
  const ClientMyRewardPage({super.key});

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
          'My Reward',
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              backgroundColor:Color(0xE5FF5100), // Color de fondo del círculo
              radius: 64,
              child: Icon(
                Icons.redeem, // Icono relacionado con recompensas
                size: 64,
                color: Colors.white, // Color del icono
              ),
            ),
            const SizedBox(height: 16), // Aumentamos el margen a 16 para más espacio
            const Text(
              'No rewards for now!\nThere will be new surprises soon.',
              style: TextStyle(
                fontSize: 20, // Aumentamos el tamaño del texto
                fontWeight: FontWeight.bold,
                color:Color(0xE5FF5100), // Color del texto
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24), // Agregamos más espacio debajo del texto
            ElevatedButton.icon(
              onPressed: () {
                // Lógica para redimir recompensas
              },
              icon: const Icon(Icons.shopping_cart), // Icono de carrito de compras
              label: const Text('See available offers'), // Texto del botón
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: const Color(0xE5FF5100), // Color del texto del botón
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Bordes redondeados
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Espaciado interno
              ),
            ),
          ],
        ),
      ),
    );
  }
}
