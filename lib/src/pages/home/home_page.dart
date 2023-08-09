import 'package:app_latin_food/src/pages/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomeController con = Get.put(HomeController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text(
        'hola',
      )),
    );
  }
}
