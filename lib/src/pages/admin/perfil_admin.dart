import 'package:app_latin_food/main.dart';
import 'package:flutter/material.dart';



class PerfilAdmin extends StatelessWidget {
  const PerfilAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Perfil',
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
        body: Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => con1.singOut(),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xE5FF5100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                minimumSize: const Size(40, 30),
              ),
              child: const Text('Sign off'),
            ),
          ),
        )
        );
  }
}
