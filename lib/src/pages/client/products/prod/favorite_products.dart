// ignore_for_file: library_private_types_in_public_api

import 'package:app_latin_food/src/models/favoritos.dart';
import 'package:app_latin_food/src/pages/client/products/prod/favorite_controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../models/product.dart';

class Favoriteprod extends StatefulWidget {
  final int customerId;

  final Product? product;
  const Favoriteprod({Key? key, required this.customerId, this.product})
      : super(key: key);

  @override
  _FavoriteprodState createState() => _FavoriteprodState();
}

class _FavoriteprodState extends State<Favoriteprod> {
  final FavoritesController _favoriteController = FavoritesController();

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
        title: Text(
          'Favorite Products',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: 10.0), // Ajusta el valor según tu preferencia
            child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/latin-food-8635c.appspot.com/o/splash%2FlogoAnimadoNaranjaLoop.gif?alt=media&token=0f2cb2ee-718b-492c-8448-359705b01923',
              width: 50, // Ajusta el ancho de la imagen según tus necesidades
              height: 50, // Ajusta el alto de la imagen según tus necesidades
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<ProductFavorite>>(
        future: _favoriteController.getFavoriteProducts(widget.customerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  CupertinoAlertDialog(
              content: Column(
                children:const [
                  CupertinoActivityIndicator(),
                  SizedBox(height: 8),
                  Text('Loading data...'),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const[
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
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Cargando datos...'));
          } else if (snapshot.data!.isEmpty) {
            return  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:const [
                  AnimatedOpacity(
                    opacity: 1.0,
                    duration: Duration(milliseconds: 500),
                    child: Icon(
                      Icons
                          .hourglass_empty_outlined, // Cambiar por el icono deseado
                      size: 100,
                      color: Color(0xE5FF5100),
                    ),
                  ),
                  SizedBox(height: 16),
                  AnimatedOpacity(
                    opacity: 1.0,
                    duration: Duration(milliseconds: 500),
                    child: Text(
                      'Sin Productos en favoritos',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xE5FF5100),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            List<ProductFavorite> favoriteProducts = snapshot.data!;
            return ScrollConfiguration(
              behavior: const ScrollBehavior(),
              child: ListView.builder(
                physics:
                    const BouncingScrollPhysics(), // Añade esta línea para el efecto de rebote
                itemCount: favoriteProducts.length,
                itemBuilder: (context, index) {
                  ProductFavorite product = favoriteProducts[index];
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) async {
                      await _favoriteController.RemoveFromFavorites(
                          product.id, widget.customerId);
                      setState(() {
                        favoriteProducts.removeAt(index);
                      });
                    },
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                  /*  decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.grey[300]!, width: 1),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: product.image ?? 'no image',
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                    child: Icon(Icons.error),
                                  ),
                                ),*/
                                  ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 0.0, 10.0, 1.0),
                            child: SizedBox(
                              width: double
                                  .infinity, // O ajusta un valor específico
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${product.name}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${product.description}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                  const SizedBox(height: 4),
                                   Row(
                                    children:const [
                                      Icon(Icons.star,
                                          color: Colors.yellow, size: 16),
                                      Icon(Icons.star,
                                          color: Colors.yellow, size: 16),
                                      Icon(Icons.star,
                                          color: Colors.yellow, size: 16),
                                      Icon(Icons.star,
                                          color: Colors.yellow, size: 16),
                                      Icon(Icons.star_border,
                                          color: Colors.yellow, size: 16),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${product.price}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xE5FF5100),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
