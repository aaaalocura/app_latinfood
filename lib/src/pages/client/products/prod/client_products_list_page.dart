// ignore_for_file: unused_local_variable

import 'dart:ui';

import 'package:app_latin_food/main.dart';
import 'package:app_latin_food/src/models/category.dart';
import 'package:app_latin_food/src/models/product.dart';
import 'package:app_latin_food/src/models/user.dart';
import 'package:app_latin_food/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:app_latin_food/src/pages/client/products/prod/cart_controller.dart';
import 'package:app_latin_food/src/pages/client/products/prod/client_products_list_controller.dart';
import 'package:app_latin_food/src/pages/client/products/prod/favorite_controller.dart';
import 'package:app_latin_food/src/pages/client/products/prod/prod_detail.dart';
import 'package:app_latin_food/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_storage/get_storage.dart';

// ignore: must_be_immutable
class ProductsListPage extends StatelessWidget {
  final RxList<Category> categories = RxList<Category>();
  final SelectedCategoryController selectedCategoryController =
      Get.put(SelectedCategoryController());

  final ClientProfileInfoController con1 =
      Get.put(ClientProfileInfoController());
  final ProductsListController con = Get.put(ProductsListController());

  final ClientProductsListController con5 =
      Get.put(ClientProductsListController());
  final CartController cartController = Get.find();
  bool isFavorite = false;

  ProductsListPage({super.key, required int customerId});

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _favoriteController = Get.put(FavoritesController());

    final categoryIcons = {
      "04-Tequeños": Icons.abc_sharp,
      "03-Cachitos": Icons.access_alarm,
      "02-Pastelitos": Icons.add_home,
      "01-Empanadas": Icons.accessibility,
      "05-Mini Pan": Icons.account_box,
    };

    User user = User.fromJson(GetStorage().read('user') ?? {});
    final int? userId = user.id;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 10),
                child: Container(
                  color:
                      const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Obx(() {
            return IconButton(
              icon: Stack(
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 32,
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
              ),
              onPressed: () {
                con5.changeTab(1);
              },
            );
          }),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 223, 222, 222),
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: const Color.fromARGB(255, 223, 222, 222)),
              ),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 18),
                ),
                onFieldSubmitted: (value) {
                  showSearch(
                    context: context,
                    delegate: ProductSearchDelegate(con.products),
                    query: value,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/latin-food-8635c.appspot.com/o/splash%2FlogoAnimadoNaranjaLoop.gif?alt=media&token=0f2cb2ee-718b-492c-8448-359705b01923',
              width: 50,
              height: 50,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130),
          child: buildCategoriesList(),
        ),
      ),
      backgroundColor: Colors.white,
      body: Obx(
        () => IndexedStack(
          index: con.indexTab.value,
          children: [
            ScrollConfiguration(
              behavior: const CupertinoScrollBehavior(),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                ),
                itemCount: con.filteredProducts.length,
                itemBuilder: (context, index) {
                  var product = con.filteredProducts[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(
                              product: product, customerId: userId),
                        ),
                      );
                    },
                    onLongPress: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) => CupertinoActionSheet(
                          actions: [
                            CupertinoActionSheetAction(
                              onPressed: () {
                                cartController.addToCart(product, userId!, product.tam1!);
                                Navigator.pop(context);
                              },
                              child: const Text('Add Cart'),
                            ),
                            CupertinoActionSheetAction(
                              onPressed: () {
                                _favoriteController.AddToFavorites(
                                    product.id, userId!);
                                Navigator.pop(context);
                              },
                              child: const Text('Add Favorite'),
                            ),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancelar'),
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.grey[300]!, width: 1),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: product.image!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                    child: Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 0.0, 2.0, 1.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'SKU: ${product.barcode}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF999999),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tamaño: ${_getBarcodeDescription(product.barcode)}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF999999),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Caja: ${product.tam1} Unidades',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF999999),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${((product.tam1 ?? 1) * product.price).toStringAsFixed(2)}',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoriesList() {
    final selectedCategoryId =
        selectedCategoryController.selectedCategoryId.obs;

    final categoryIcons = {
      "04-Tequeños": Icons.abc_sharp,
      "03-Cachitos": Icons.access_alarm,
      "02-Pastelitos": Icons.add_home,
      "01-Empanadas": Icons.accessibility,
      "05-Mini Pan": Icons.account_box,
    };
    return FutureBuilder<List<Category>>(
      future: CategoryController.fetchCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CupertinoActivityIndicator(
            radius: 20.0,
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error al obtener las categorías'),
          );
        } else {
          final categories = snapshot.data!;
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                final icon = categoryIcons[category.name];
                final isSelected =
                    selectedCategoryController.selectedCategoryId.value ==
                        category.id;

                return GestureDetector(
                  onTap: () async {
                    selectedCategoryController.setSelectedCategory(category.id);
                    con.getProductsByCategory(category
                        .name); // Llama a la función para obtener productos por categoría
                  },
                  child: SizedBox(
                    width: 80,
                    height: 130,
                    child: Obx(() {
                      final isSelected =
                          selectedCategoryId.value == category.id;
                      final icon = categoryIcons[category.name];

                      return Column(
                        children: [
                          Card(
                            color: isSelected
                                ? const Color(0xE5FF5100)
                                : const Color.fromARGB(255, 223, 222, 222),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                color: Color.fromARGB(255, 223, 222, 222),
                              ),
                            ),
                            child: Container(
                              width: 80,
                              height: 80,
                              padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
                              child: Icon(
                                icon ?? Icons.abc_outlined,
                                size: 40,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }

  String _getBarcodeDescription(String barcode) {
    String secondSet = barcode.substring(2, 4);

    switch (secondSet) {
      case '01':
        return 'Grande';
      case '02':
        return 'Mediano';
      case '03':
        return 'Chico';
      default:
        return 'sin tamaño';
    }
  }
}

class ProductSearchDelegate extends SearchDelegate<Product> {
  final List<Product> products;

  ProductSearchDelegate(this.products);

  @override
  String get searchFieldLabel => 'Search Products';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: Theme.of(context).textTheme.bodyLarge!.color,
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredProducts = products.where((product) {
      final nameLower = product.name.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();

    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        final ClientProfileInfoController con1 =
            Get.put(ClientProfileInfoController());
        final int? userId =
            con1.user.id != null ? int.tryParse('${con1.user.id}') : null;
        return ListTile(
          title: Text(product.name),
          subtitle: Text('\$${product.price}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsPage(
                  product: product,
                  customerId: userId,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredProducts = products.where((product) {
      final nameLower = product.name.toLowerCase();
      final queryLower = query.toLowerCase();

      return nameLower.contains(queryLower);
    }).toList();

    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        final ClientProfileInfoController con1 =
            Get.put(ClientProfileInfoController());
        final int? userId =
            con1.user.id != null ? int.tryParse('${con1.user.id}') : null;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: CupertinoScrollbar(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Price: ${product.price}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Category: ${product.categoryId}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsPage(
                                product: product,
                                customerId: userId,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xE5FF5100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          child: Text(
                            'See Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SelectedCategoryController extends GetxController {
  RxInt selectedCategoryId = RxInt(-1);

  void setSelectedCategory(int categoryId) {
    selectedCategoryId.value = categoryId;
  }
}

Future<void> refreshCategories() async {
  try {
    final newCategories = await CategoryController.fetchCategories();
    categories.assignAll(newCategories);
  } catch (e) {
    // ignore: avoid_print
    print('Error al recargar las categorías: $e');
  }
}
