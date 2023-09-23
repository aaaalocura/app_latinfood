import 'package:app_latin_food/main.dart';
import 'package:flutter/material.dart';

class PerfilAdmin extends StatelessWidget {
  const PerfilAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
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
      body: Center(
        child: Card(
          elevation: 4.0,
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 60.0,
                  //backgroundImage: AssetImage('assets/empanada.png'), // Reemplaza con la imagen de perfil del administrador
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Super Admin',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'superadmin@kdlatinfood.com',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    con1.singOut();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xE5FF5100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    minimumSize: const Size(120, 40),
                  ),
                  child: const Text('Cerrar sesion'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
