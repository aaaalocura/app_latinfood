import 'dart:ui';

import 'package:app_latin_food/src/pages/register/register_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

////FUNCION PRINCIPAL
class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

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
        title: const Text('Create Account'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
         flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: [
              // Coloca aquí la imagen o cualquier otro contenido que desees tener detrás del AppBar

              // BackdropFilter para aplicar el efecto de difuminado
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  color: const Color.fromARGB(255, 255, 255, 255)
                      .withOpacity(0.1), // Color de difuminado
                ),
              ),
            ],
          ),
        ),
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
      body: ScrollConfiguration(
        behavior: const CupertinoScrollBehavior(),
        child: Column(
          children: [
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            const SizedBox(height: 5),
            Expanded(
              // Agregado el Expanded
              child: _boxForm(context),
            ),
          ],
        ),
      ),
    );
  }
}

///////////FORMULARIO
Widget _boxForm(BuildContext context) {
  return SingleChildScrollView(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(15),
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
        children: [
          _textFieldName(),
          const SizedBox(height: 10),
          _textFieldLastName(),
          const SizedBox(height: 10),
          _textFielLastdName2(),
          const SizedBox(height: 10),
          _textFieldEmail(),
          const SizedBox(height: 10),
          _textFieldPhone(),
          const SizedBox(height: 10),
          _textFieldAddress(),
          const SizedBox(height: 10),
          _textFieldPassword(),
          const SizedBox(height: 10),
          _textFieldConfirmPassword(),
          const SizedBox(height: 10),
          _buttonRegister(),
          _textOyarce(),
        ],
      ),
    ),
  );
}


Widget _textOyarce() {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
    padding: const EdgeInsets.symmetric(
        horizontal: 7, vertical: 7), // Ajustar el padding
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.orange[800]!,
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
//

///////////////////////*     INPUTS     */////////////////////////
//Nombre input
Widget _textFieldName() {
  RegisterController con = Get.put(RegisterController());
  return TextFormField(
    controller: con.nameController,
    decoration: InputDecoration(
      labelText: 'Name',
      prefixIcon: const Icon(Icons.person),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
    ),
  );
}

Widget _textFieldLastName() {
  RegisterController con = Get.put(RegisterController());
   return TextFormField(
    controller: con.lastNameController,
    decoration: InputDecoration(
      labelText: 'Last Name',
      prefixIcon: const Icon(Icons.person_pin),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
    ),
  );
}

Widget _textFielLastdName2() {
  RegisterController con = Get.put(RegisterController());
  return TextFormField(
    controller: con.lastName2Controller,
    decoration: InputDecoration(
      labelText: 'Last  Name 2 (optional)',
      prefixIcon: const Icon(Icons.person_pin_outlined),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
    ),
  );
}

//Email input
Widget _textFieldEmail() {
  RegisterController con = Get.put(RegisterController());
  return TextFormField(
    controller: con.emailController,
    decoration: InputDecoration(
      labelText: 'Email',
      prefixIcon: const Icon(Icons.email_outlined),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
    ),
  );
}

//phone input
Widget _textFieldPhone() {
  RegisterController con = Get.put(RegisterController());
    return TextFormField(
    controller: con.phoneController,
    decoration: InputDecoration(
      labelText: 'phone',
      prefixIcon: const Icon(Icons.phone_enabled_outlined),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
    ),
  );
}

//address input
Widget _textFieldAddress() {
  RegisterController con = Get.put(RegisterController());
  return TextFormField(
    controller: con.addressController,
    decoration: InputDecoration(
      labelText: 'Address',
      prefixIcon: const Icon(Icons.maps_home_work_outlined),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
    ),
  );
}

//password input
Widget _textFieldPassword() {
  RegisterController con = Get.put(RegisterController());
  return TextFormField(
    controller: con.passwordController,
    decoration: InputDecoration(
      labelText: 'Password',
      prefixIcon: const Icon(Icons.password_outlined),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
    ),
  );
}

//confirmar password input
Widget _textFieldConfirmPassword() {
  RegisterController con = Get.put(RegisterController());
  return TextFormField(
    controller: con.passwordConfirm,
    decoration: InputDecoration(
      labelText: 'Confirm Password',
      prefixIcon: const Icon(Icons.password_outlined),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xE5FF5100),
        ),
      ),
    ),
  );
}

///////////////////////*     BOTONES     */////////////////////////
//BOTON REGISTRAR
Widget _buttonRegister() {
  RegisterController con = Get.put(RegisterController());
  return Container(
    width: double.infinity,
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(
        colors: [
          const Color(0xE5FF5100),
          Colors.orange[200]!,
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    ),
    child: ElevatedButton(
      onPressed: () => con.register(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        'Create Account',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );
}
