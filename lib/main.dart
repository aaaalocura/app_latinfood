import 'package:app_latin_food/src/models/category.dart';
import 'package:app_latin_food/src/models/user.dart';
import 'package:app_latin_food/src/pages/client/delivery/list/client_delivery_page.dart';
import 'package:app_latin_food/src/pages/client/products/list/client_products_list_page.dart';
import 'package:app_latin_food/src/pages/client/products/prod/cart_controller.dart';
import 'package:app_latin_food/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:app_latin_food/src/pages/envios/envios_page.dart';
//import 'package:app_latin_food/src/pages/home/home_page.dart';
import 'package:app_latin_food/src/pages/login/login_page.dart';
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
    final int? userId =
        con1.user.id != null ? int.tryParse('${con1.user.id}') : null;
    return GetMaterialApp(
      title: 'LatinFood',
      // Configura el tema claro por defecto

      debugShowCheckedModeBanner: false,
        initialRoute: '/',
      getPages: [
         GetPage(name: '/', page: () => const SecondClass()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/register', page: () => const RegisterPage()),
        //GetPage(name: '/home', page: () =>  HomePage()),
        GetPage(
          name: '/home',
          page: () => GetBuilder<CartController>(
            builder: (controller) => ClientProductsListPage(),
          ),
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
            onBackground: Colors.grey,
            onPrimary: Color.fromARGB(255, 16, 16, 16),
            surface: Colors.grey,
            onSurface: Colors.grey,
            error: Colors.red,
            onError: Colors.grey,
            background: Colors.grey,
            onSecondary: Colors.grey,
          )),

      navigatorKey: Get.key,
    );
  }
}
