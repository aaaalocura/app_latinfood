import 'dart:async';
import 'package:animations/animations.dart';
import 'package:app_latin_food/src/pages/client/products/list/client_products_list_page.dart';
import 'package:app_latin_food/src/pages/client/products/prod/client_products_list_page.dart';
import 'package:app_latin_food/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:app_latin_food/src/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';





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

  double _opacity = 0;
  bool _value = true;

  @override
  void initState() {
    super.initState();
  final ClientProfileInfoController con1 = Get.put(ClientProfileInfoController());
    final int? userId = con1.user.id != null ? int.tryParse('${con1.user.id}') : null;
    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            Navigator.of(context).pushReplacement(
        ThisIsFadeRoute(
                page: userId != null ? ClientProductsListPage() : LoginPage(),
                route: Text(userId != null ? '/home' : '/login'), // Provide the correct route here
              ),

            );
            Timer(
              const Duration(milliseconds: 300),
              () {
                scaleController.reset();
              },
            );
          }
        },
      );

    scaleAnimation =
        Tween<double>(begin: 0.0, end: 12).animate(scaleController);

    Timer(const Duration(milliseconds: 600), () {
      setState(() {
        _opacity = 1.0;
        _value = false;
      });
    });
    Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        scaleController.forward();
      });
    });
  }

  @override
  void dispose() {
    scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Padding(
                padding: EdgeInsets.only(top: 80),
                child: Text(
                  'Welcome to KD Latinfood',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: AnimatedOpacity(
              curve: Curves.fastLinearToSlowEaseIn,
              duration: const Duration(seconds: 6),
              opacity: _opacity,
              child: AnimatedContainer(
                curve: Curves.fastLinearToSlowEaseIn,
                duration: const Duration(seconds: 2),
                height: _value ? 50 : 200,
                width: _value ? 50 : 200,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xE5FF5100).withOpacity(.2),
                      blurRadius: 100,
                      spreadRadius: 10,
                    ),
                  ],
                  color: const Color(0xE5FF5100),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                 child: Container(
  width: 100,
  height: 100,
  child: AnimatedBuilder(
    animation: scaleAnimation,
    builder: (context, child) => Transform.scale(
      scale: scaleAnimation.value,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.orange,
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/img/Login.jpg', // Reemplaza esto con la ruta de tu imagen en los assets
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  ),
),

                ),
              ),
            ),
          ),
        ],
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
