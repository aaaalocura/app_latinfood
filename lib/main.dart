import 'package:app_latin_food/src/models/category.dart';
import 'package:app_latin_food/src/models/user.dart';
import 'package:app_latin_food/src/pages/admin/botonbar.dart';
import 'package:app_latin_food/src/pages/admin/pedidos_admin.dart';
import 'package:app_latin_food/src/pages/client/delivery/list/client_delivery_page.dart';
import 'package:app_latin_food/src/pages/client/products/list/client_products_list_page.dart';
import 'package:app_latin_food/src/pages/client/products/prod/cart_controller.dart';
import 'package:app_latin_food/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:app_latin_food/src/pages/envios/envios_page.dart';
//import 'package:app_latin_food/src/pages/home/home_page.dart';
import 'package:app_latin_food/src/pages/login/login_page.dart';
import 'package:app_latin_food/src/pages/login/login_page_admin.dart';
import 'package:app_latin_food/src/pages/register/register_page.dart';
import 'package:app_latin_food/src/providers/category_provider.dart';
import 'package:app_latin_food/src/splash/page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

CategoriesProviders categoriesProviders = CategoriesProviders();
User userSession = User.fromJson(GetStorage().read('user') ?? {});
final ClientProfileInfoController con1 = Get.put(ClientProfileInfoController());
void main() async {
  await GetStorage.init();
  runApp(const MyApp());
  Get.put(CartController());
}

List<Category> categories = <Category>[].obs;
void getCategories() async {
  var categoriesProviders2 = categoriesProviders;
  // ignore: unused_local_variable
  var result = await categoriesProviders2.getAll();
  // Imprimir el contenido de result por consola
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkTheme = false;
  @override
  void initState() {
    //  getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = User.fromJson(GetStorage().read('user') ?? {});
    final int? userId = user.id;

    return GetMaterialApp(
      title: 'LatinFood',
      // Configura el tema claro por defecto
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SecondClass()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/loginAdmin', page: () => LoginPageAdmin()),
        GetPage(name: '/register', page: () => const RegisterPage()),
        GetPage(name: '/PedidosAdmin', page: () => const PedidosAdmin()),
        //GetPage(name: '/home', page: () =>  HomePage()),
        GetPage(
          name: '/homeadmin',
          page: () => ClientProductsListPageAdmin(),
        ),
        GetPage(
          name: '/home',
          page: () => ClientProductsListPage(),
        ),
        // GetPage(name: '/home/info', page: () =>  ClientProfileInfoPage()),
        if (userId != null)
          GetPage(
            name: '/home/delyvery',
            page: () => ClientOrdersPage(customerId: userId),
          ),
        GetPage(
          name: '/home/profile/address',
          page: () => const ClientDeliveryListPage(),
        ),
      ],
      theme: ThemeData(
          primaryColor: const Color(0xE5FF5100),
          fontFamily: '.SF UI Text',
          colorScheme: const ColorScheme(
            secondary: Color(0xE5FF5100),
            primary: Color(0xE5FF5100),
            brightness: Brightness.light,
            onBackground: Colors.white,
            onPrimary: Color.fromARGB(255, 16, 16, 16),
            surface: Colors.white,
            onSurface: Colors.white,
            error: Colors.red,
            onError: Colors.white,
            background: Colors.white,
            onSecondary: Colors.white,
          )),

      navigatorKey: Get.key,
    );
  }
}
