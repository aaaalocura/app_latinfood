import 'dart:ui';


import 'package:app_latin_food/src/pages/categorias/categorias_controller.dart';
import 'package:app_latin_food/src/pages/client/products/prod/favorite_controller.dart';
import 'package:app_latin_food/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/cat.dart';



class ProdCategoria extends StatelessWidget {
  final int categoryId;
  final Product? product;
    final ClientProfileInfoController con1 =
      Get.put(ClientProfileInfoController());
   ProdCategoria({required this.categoryId, Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _favoriteController = Get.put(FavoritesController());
      final int? userId =
        con1.user.id != null ? int.tryParse('${con1.user.id}') : null;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Productos ', // Mostrar el nombre de la categoría en el título
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          Padding(
            padding:  const EdgeInsets.only(
                right: 10.0), // Ajusta el valor según tu preferencia
            child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/latin-food-8635c.appspot.com/o/splash%2FlogoAnimadoNaranjaLoop.gif?alt=media&token=0f2cb2ee-718b-492c-8448-359705b01923',
              width: 50, // Ajusta el ancho de la imagen según tus necesidades
              height: 50, // Ajusta el alto de la imagen según tus necesidades
            ),
          ),
        ],
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: [
              // Coloca aquí la imagen o cualquier otro contenido que desees tener detrás del AppBar

              // BackdropFilter para aplicar el efecto de difuminado
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  color:  const Color.fromARGB(255, 255, 255, 255)
                      .withOpacity(0.1), // Color de difuminado
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Product>>(
        future: ProductController().fetchProductsByCategory(categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  const CupertinoAlertDialog(
              content: Column(
                children: [
                  CupertinoActivityIndicator(),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return  const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: 1.0,
                    duration: Duration(milliseconds: 500),
                    child: Icon(
                      Icons
                          .wifi_tethering_off_sharp, // Cambiar por el icono deseado
                      size: 100,
                      color: Color(0xE5FF5100),
                    ),
                  ),
                  SizedBox(height: 16),
                  AnimatedOpacity(
                    opacity: 1.0,
                    duration: Duration(milliseconds: 500),
                    child: Text(
                      'No tienes conexion a internet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xE5FF5100),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }else {
  final products = snapshot.data!;
  return ListView.builder(
    itemCount: products.length,
    itemBuilder: (context, index) {
      var product = products[index];
      return Container(
        margin:  const EdgeInsets.all(8),
        child: Card(
          elevation: 2,
          child: InkWell(
            onLongPress: () {
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) => CupertinoActionSheet(
                  actions: [
                    CupertinoActionSheetAction(
                      onPressed: () {
                      // ProductDetailsPage( product: product, customerId: userId);
                      },
                      child:  const Text('View this product'),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () {
                                _favoriteController.AddToFavorites(
                                    product.id, userId!);
                                Navigator.pop(context);
                              },
                      child:  const Text('Add Favorites'),
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:  const Text('Cancelar'),
                  ),
                ),
              );
            },
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:  const EdgeInsets.all(8.0),
                    child: Text(product.name ?? ''),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

        },
      ),
    );
  }
}
