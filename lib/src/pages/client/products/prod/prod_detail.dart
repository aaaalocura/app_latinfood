import 'dart:math';
import 'dart:ui';

import 'package:app_latin_food/main.dart';
import 'package:app_latin_food/src/pages/client/products/prod/cart_controller.dart';
import 'package:app_latin_food/src/pages/client/products/prod/favorite_controller.dart';
import 'package:app_latin_food/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_latin_food/src/models/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

// ignore: must_be_immutable
class ProductDetailsPage extends StatefulWidget {
  final Product product;
  final ClientProfileInfoController con1 =
      Get.put(ClientProfileInfoController());
  ProductDetailsPage({super.key, required this.product, int? customerId});
  RxList<Product> filteredProducts = RxList<Product>();
  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;

  final cartController = Get.find<CartController>();
  // ignore: unused_element
  double _generateRandomRating() {
    final random = Random();
    return (random.nextInt(51)) / 10;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _favoriteController = Get.put(FavoritesController());

    final int? userId =
        con1.user.id != null ? int.tryParse('${con1.user.id}') : null;
    // ignore: non_constant_identifier_names
    final int id_prod = widget.product.id;
    // ignore: unused_local_variable
    final RxBool isFavorite = false.obs;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Detail Item'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: [

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
          Stack(
            children: [
              IconButton(
                  onPressed: () {
                  
                  },
                  icon: Stack(
                    children: [
                      const Positioned(
                        left: 0, 
                        top: 4, 
                        child: Icon(
                          Icons.shopping_cart,
                          size: 32,
                        ),
                      ),
                      if (cartController.cartItemCount > 0)
                        Positioned(
                          right: -1,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red, 
                            ),
                            child: Text(
                              '${cartController.cartItemCount}',
                              style: const TextStyle(
                                color: Colors.white, 
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  )),
            ],
          ),
          IconButton(
            onPressed: () {
              _favoriteController.toggleFavorite(id_prod, userId!);
            },
            icon: Obx(() => Stack(
                  children: [
                    Icon(
                      _favoriteController.isFavorite.value
                          ? Icons.favorite
                          : Icons.favorite_border_sharp,
                    ),
                  ],
                )),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.product.image ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre del producto
                    // Nombre del producto y puntuación aleatoria
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.product.name,
                            style: const TextStyle(
                              fontSize: 22,
                              height: 1.5,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.star, color: Colors.amber),
                            Text(
                              '5',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    // Descripción del producto
                    const Text(
                      'Description:',
                      style: TextStyle(
                        fontSize: 14, // Tamaño de fuente en sp
                        height: 1.5, // Altura de línea en sp
                        fontFamily:
                            'Inter', // Nombre de la fuente (si se ha agregado a los recursos)
                        fontWeight: FontWeight
                            .w400, // Peso de la fuente (400 es igual a FontWeight.normal)
                        color: Color(
                            0xFF999999), // Color del texto en formato ARGB (8 dígitos hexadecimales)
                      ),
                    ),

                    const SizedBox(height: 4),
                    Text(
                      widget.product.descripcion,
                      style: const TextStyle(
                        fontSize: 14, // Tamaño de fuente en sp
                        height: 1.5, // Altura de línea en sp
                        fontFamily:
                            'Inter', // Nombre de la fuente (si se ha agregado a los recursos)
                        fontWeight: FontWeight
                            .w400, // Peso de la fuente (400 es igual a FontWeight.normal)
                        color: Color(
                            0xFF999999), // Color del texto en formato ARGB (8 dígitos hexadecimales)
                      ),
                    ),
                    const SizedBox(height: 50),
                    // Botón para la cantidad
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (quantity > 1) {
                                quantity--;
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.remove_circle_outline_rounded,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          quantity.toString(),
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 7),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                          icon: const Icon(
                            Icons.add_circle_outline,
                            size: 32,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 60),
                    // Precio del producto
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Price',
                                style: TextStyle(
                                  fontSize: 14, // Tamaño de fuente en sp
                                  height: 1.5, // Altura de línea en sp
                                  fontFamily:
                                      'Inter', // Nombre de la fuente (si se ha agregado a los recursos)
                                  fontWeight: FontWeight
                                      .w400, // Peso de la fuente (400 es igual a FontWeight.normal)
                                  color: Color(
                                      0xFF999999), // Color del texto en formato ARGB (8 dígitos hexadecimales)
                                ),
                              ),
                              Text(
                                '\$${widget.product.price}',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        // Botón "Add to Cart" con bordes redondeados y un ícono de bolsa de compras
                        ElevatedButton.icon(
                          onPressed: () {
                            // Lógica para agregar al carrito
                            cartController.addToCart(
                                widget.product, userId!, quantity);

                            // Actualizar el contador del carrito
                            cartController.update();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60),
                            ),
                          ),
                          icon: const Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.white,
                          ),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 1),
                            child: Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontSize: 16, // El tamaño de fuente en sp
                                height: 1.5, // La altura de línea en sp
                                fontFamily:
                                    'Inter', // El nombre de la fuente 'Inter'
                                fontWeight: FontWeight
                                    .w600, // El peso de fuente, en este caso 600 (negrita)
                                color: Colors.white, // El color del texto
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[200],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Related Products',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<List<Product>>(
                      future: getProductsWithSameFlavor(
                          widget.product.saborId ?? ''),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          List<Product> relatedProducts = snapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: relatedProducts.length,
                            itemBuilder: (context, index) {
                              Product relatedProduct = relatedProducts[index];
                              return InkWell(
                                onTap: () {
                                  // Navegar a la página de detalles del producto relacionado
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailsPage(
                                        product: relatedProduct,
                                      ),
                                    ),
                                  );
                                },
                                onLongPress: () {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CupertinoActionSheet(
                                      actions: [
                                        CupertinoActionSheetAction(
                                          onPressed: () {
                                            // Lógica para añadir al carrito
                                            cartController.addToCart(
                                                relatedProduct, userId!, 1);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Add to Cart'),
                                        ),
                                      ],
                                      cancelButton: CupertinoActionSheetAction(
                                        onPressed: () {
                                          // ProductDetailsPage(product: product);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                    ),
                                  );
                                },
                                child: ExpansionTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        relatedProduct.image ?? ''),
                                  ),
                                  title: Text(relatedProduct.name),
                                  subtitle: Text('\$${relatedProduct.price}'),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Category: ${relatedProduct.categoryId}\n'),

                                          Text(
                                              'Status: ${relatedProduct.estado}'),
                                          // Otros datos adicionales del producto
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return const Text('No related products found.');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Product>> getProductsWithSameFlavor(String flavorId) async {
    try {
      final response = await http.get(
          Uri.parse('https://kdlatinfood.com/intranet/public/api/products'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<Product> allProducts = List<Product>.from(
            data.map((productData) => Product.fromJson(productData)));

        // Filtrar los productos con el mismo sabor
        final List<Product> relatedProducts = allProducts
            .where((product) => product.saborId == flavorId)
            .toList();

        return relatedProducts;
      } else {
        throw Exception('Failed to get products with same flavor');
      }
    } catch (e) {
      throw Exception('Failed to get related products: $e');
    }
  }
}
