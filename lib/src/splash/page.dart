// ignore_for_file: unused_import

import 'dart:async';
import 'package:app_latin_food/src/pages/admin/botonbar.dart';
import 'package:app_latin_food/src/pages/client/products/list/client_products_list_page.dart';
import 'package:app_latin_food/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:app_latin_food/src/pages/login/login_page.dart';
import 'package:app_latin_food/src/pages/login/login_page_admin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SecondClass extends StatefulWidget {
  const SecondClass({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SecondClassState createState() => _SecondClassState();
}

class _SecondClassState extends State<SecondClass>
    with TickerProviderStateMixin {
  late AnimationController scaleController;
  late Animation<double> scaleAnimation;

  // ignore: unused_field
  double _opacity = 0;
  // ignore: unused_field
  bool _value = true;

  bool isControllerActive =
      true; // Variable de estado para verificar si el controlador está activo

  @override
  void dispose() {
    // Asegúrate de desactivar el controlador antes de liberar recursos
    isControllerActive = false;
    scaleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final ClientProfileInfoController con1 =
        Get.put(ClientProfileInfoController());
    final int? userId =
        con1.user.id != null ? int.tryParse('${con1.user.id}') : null;
    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            Navigator.of(context).pushReplacement(
              ThisIsFadeRoute(
                page: userId != null
                    ? (GetStorage().read('isAdmin') == true
                        ? LoginPage()
                        : LoginPage()
                        
                        )
                    : LoginPage(), // Redirige al inicio de sesión si userId es null
                route: Text(userId != null
                    ? (GetStorage().read('isAdmin') == true
                        ? '/PedidosAdmin'
                        : '/login')
                    : '/login'),
              ),
            );
            Timer(
              const Duration(milliseconds: 500),
              () {
                // Verifica si el controlador todavía está activo antes de llamar a reset
                if (isControllerActive) {
                  scaleController.reset();
                }
              },
            );
          }
        },
      );

    scaleAnimation =
        Tween<double>(begin: 0.0, end: 12).animate(scaleController);

    Timer(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _opacity = 0;
          _value = false;
        });
      }
    });
    Timer(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          scaleController.forward();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/splash.gif'), // Ruta de tu archivo GIF
      ),
    );
  }
}

class ThisIsFadeRoute extends PageRouteBuilder {
  final Widget page;
  final Widget route;

  ThisIsFadeRoute({required this.page, required this.route})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
