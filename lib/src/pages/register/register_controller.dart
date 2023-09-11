import 'package:app_latin_food/src/models/user.dart';
import 'package:app_latin_food/src/providers/users_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirm = TextEditingController();
  void goToRegisterPage() {
    Get.toNamed('/login');
  }

  UsersProviders usersProviders = UsersProviders();
  Future<void> register() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String name = nameController.text.trim();
    String lastName = lastNameController.text.trim();
    
    String phone = phoneController.text.trim();
    String address = addressController.text.trim();
    String passwordConfirmation = passwordConfirm.text.trim();

    if (kDebugMode) {
      print('Email:  $email');
    }
    if (kDebugMode) {
      print('Password: $password');
    }

    if (isValidForm(email, password, name, phone, address, lastName,
        passwordConfirmation)) {
      User user = User(
        name: name,
        lastName: lastName,
       
        email: email,
        password: password,
        address: address,
        phone: phone,
      );
// ignore: unused_local_variable
      Response response = await usersProviders.create(user);
      Get.toNamed('/login');
      Get.snackbar('Ya Puedes iniciar sesion con tu cuenta creada ', name);
    }
  }

  bool isValidForm(
      String email,
      String password,
      String name,
      String phone,
      String address,
      String lastName,
      
      String passwordConfirmation) {
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Correo no válido', 'Ingresa un correo válido');
      return false;
    }

    if (email.isEmpty) {
      Get.snackbar('Error', 'Ingresa tu email');
      return false;
    }

    if (password.length < 6) {
      Get.snackbar('Error', 'La contraseña debe tener al menos 6 caracteres');
      return false;
    }

    if (name.isEmpty) {
      Get.snackbar('Error', 'Ingresa tu nombre');
      return false;
    }

    if (lastName.isEmpty) {
      Get.snackbar('Error', 'Ingresa tu apellido');
      return false;
    }



    if (phone.isEmpty) {
      Get.snackbar('Error', 'Ingresa tu número de teléfono');
      return false;
    }

    if (phone.length < 10) {
      Get.snackbar('Error', 'El teléfono debe tener al menos 10 dígitos');
      return false;
    }

    if (address.isEmpty) {
      Get.snackbar('Error', 'Ingresa tu dirección');
      return false;
    }

    if (passwordConfirmation != password) {
      Get.snackbar('Error', 'Las contraseñas deben coincidir');
      return false;
    }

    return true;
  }
}
