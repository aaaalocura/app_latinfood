import 'package:app_latin_food/src/models/response_api.dart';
import 'package:app_latin_food/src/providers/users_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
UsersProviders usersProviders = UsersProviders();

  void goToRegisterPage() {
    Get.toNamed('/register');
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (kDebugMode) {
      print('Email:  $email');
    }
    if (kDebugMode) {
      print('Password: $password');
    }

if (isValidForm(email, password)){
  ResponseApi responseApi=await usersProviders.login(email, password);
  if (kDebugMode) {
    print(responseApi.toJson());
  }
  if(responseApi.success==true){
    GetStorage ().write('user', responseApi.data);
goToHomePage();
      Get.snackbar('WELCOME', email
     ,
    barBlur: 100,
    animationDuration: const Duration(seconds: 1),
     ); 
  }
    if(responseApi.success==false){
   

      Get.snackbar('Usuario o contraseña incorrecta', 'intenta otra vez'
     ,
    barBlur: 100,
    animationDuration: const Duration(seconds: 1),
     ); 
  }
   
}

}
void goToHomePage() {
 Get.offNamedUntil('/home', (route) => false);
}

  bool isValidForm(String email, String password){
  if(!GetUtils.isEmail(email)){
    Get.snackbar(
      'Correo no valido'
    ,'Ingresa un Correo Valido',
    barBlur: 100,
    animationDuration: const Duration(seconds: 1),
    
    );
    return  false;
  }
  if(email.isEmpty){
    Get.snackbar('Error', 'Ingresa tu email');
    return false;
  }
    if(password.isEmpty){
    Get.snackbar('Error', 'Ingresa tu Contraseña');
    return false;
  }
  return true;
}

}
