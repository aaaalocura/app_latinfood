import 'package:app_latin_food/src/pages/admin/envios_admin.dart';
import 'package:app_latin_food/src/pages/admin/pedidos_admin.dart';
import 'package:app_latin_food/src/pages/admin/perfil_admin.dart';

import 'package:app_latin_food/src/pages/client/profile/info/client_profile_info_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:app_latin_food/src/utils/custom_animated_bottom_bar.dart';

import '../client/products/list/client_products_list_controller.dart';

class ClientProductsListPageAdmin extends StatelessWidget {
  final ClientProductsListController con =
      Get.put(ClientProductsListController());

  final ClientProfileInfoController con1 =
      Get.put(ClientProfileInfoController());

  // ignore: use_key_in_widget_constructors
  ClientProductsListPageAdmin({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomBar(),
      body: Obx(
        () => IndexedStack(
          index: con.indexTab.value,
          children: const [
            PedidosAdmin(),
            SalesListPage(),
            PerfilAdmin(),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return Obx(
      () => CustomAnimatedBottomBar(
        containerHeight: 70,
        backgroundColor: const Color(0xE5FF5100),
        showElevation: true,
        itemCornerRadius: 30,
        curve: Curves.ease,
        selectedIndex: con.indexTab.value,
        onItemSelected: (index) => con.changeTab(index),
        items: [
          BottomNavyBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Deliveries'),
            activeColor: Colors.white,
            inactiveColor: Colors.white,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.delivery_dining),
            title: const Text('Shipping'),
            activeColor: Colors.white,
            inactiveColor: Colors.white,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.person),
            title: const Text('My Profile'),
            activeColor: Colors.white,
            inactiveColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
