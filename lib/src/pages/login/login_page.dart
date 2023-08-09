import 'package:app_latin_food/src/pages/login/login_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginController conex = Get.put(LoginController());

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
return Scaffold(
  bottomNavigationBar: SizedBox(
    height: 100,
    child: _textOyarce(),
  ),
  backgroundColor: Colors.white,
  body: Stack(
    children: [
      _fondo(),
      SingleChildScrollView(
        
        child: Column(
          children: [
            _imageCover(),
            const SizedBox(height: 20),
            _boxForm(context),
            const SizedBox(height: 20),
            _textDontHaveAccount(),
          ],
        ),
      ),
    ],
  ),
);


  }
}

Widget _fondo() {
  return Container(
    width: double.infinity,
    height: double.infinity,
    color: Colors.white,
  );
}

Widget _imageCover() {
  return SafeArea(
   child: Container(
  margin: const EdgeInsets.only(top: 40),
  alignment: Alignment.center,
  child: Image.network(
    'https://firebasestorage.googleapis.com/v0/b/latin-food-8635c.appspot.com/o/splash%2FlogoAnimadoNaranjaLoop.gif?alt=media&token=0f2cb2ee-718b-492c-8448-359705b01923',
    width: 160,
    height: 160,
  ),
),

  );
}

Widget _textInfo() {
  return const Text(
    'Welcome',
    style: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 25,
    ),
  );
}

Widget _boxForm(BuildContext context) {
  return SingleChildScrollView(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textInfo(), // Mover el texto "Welcome" aquí para que esté arriba del formulario
          const SizedBox(height: 20),
          _textFieldEmail(),
          const SizedBox(height: 20),
          _textFieldPassword(),
          const SizedBox(height: 20),
          _buttonLogin(),
        ],
      ),
    ),
  );
}


Widget _textFieldEmail() {
  LoginController con = Get.put(LoginController());
  return TextField(
    controller: con.emailController,
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
      hintText: 'Email',

      suffixIcon:
          const Icon(Icons.email_rounded), // Colocar el icono a la derecha
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xE5FF5100), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xE5FF5100), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        // Mantener el borde de color naranja siempre activo
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xE5FF5100), width: 2),
      ),
    ),
  );
}

Widget _textFieldPassword() {
  LoginController con = Get.put(LoginController());
  return TextField(
    controller: con.passwordController,
    keyboardType: TextInputType.text,
    obscureText: true,
    decoration: InputDecoration(
      hintText: 'Password',

      suffixIcon: const Icon(Icons.lock), // Colocar el icono a la derecha
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xE5FF5100), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xE5FF5100), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        // Mantener el borde de color naranja siempre activo
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xE5FF5100), width: 2),
      ),
    ),
  );
}

Widget _buttonLogin() {
  LoginController con = Get.put(LoginController());
  return Container(
    width: double.infinity,
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: const LinearGradient(
        colors: [
          Color(0xE5FF5100),
          Color.fromARGB(255, 253, 171, 49),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    ),
    child: ElevatedButton(
      onPressed: () => con.login(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        'Login',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );
}

Widget _textDontHaveAccount() {
  LoginController conex = Get.put(LoginController());
  return Container(
    color: Colors.white,
    width: double.infinity,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Don\'t have account?'),
        const SizedBox(width: 7),
        GestureDetector(
          onTap: () => conex.goToRegisterPage(),
          child: const Text(
            'create a new account',
            style: TextStyle(
              color: Color(0xE5FF5100),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _textOyarce() {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 30),
    padding: const EdgeInsets.symmetric(
        horizontal: 12, vertical: 6), // Ajustar el padding
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          const Color(0xE5FF5100),
          Colors.orange[200]!,
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    alignment: Alignment.center, // Centrar el texto dentro del contenedor
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'Design by ',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        Text(
          'OyarceGroup',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
