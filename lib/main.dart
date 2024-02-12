// ignore_for_file: avoid_print

import 'package:app_latin_food/src/models/category.dart';
import 'package:app_latin_food/src/models/user.dart';
import 'package:app_latin_food/src/pages/admin/botonbar.dart';
import 'package:app_latin_food/src/pages/admin/envios_admin.dart';
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
import 'package:app_latin_food/src/utils/firebase_config.dart';
import 'package:app_latin_food/src/utils/push_notificacion_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

CategoriesProviders categoriesProviders = CategoriesProviders();
User userSession = User.fromJson(GetStorage().read('user') ?? {});
final ClientProfileInfoController con1 = Get.put(ClientProfileInfoController());
PushNotificationsProvider pushNotificationsProvider= PushNotificationsProvider();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: FireBaseConfig.currentPlatform);
  
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Recibiendo notificacio nen segundo plano ${message.messageId}');
  pushNotificationsProvider.showNotification(message);
}
void main() async {
  await GetStorage.init();
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: FireBaseConfig.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    pushNotificationsProvider.initPushNotifications();
  
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

// Esta función se llama cuando la aplicación se cierra

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool isDarkTheme = false;
  @override
  void initState() {
    //  getCategories();
    super.initState();
    WidgetsBinding.instance.addObserver(
        this); // Registra esta instancia como observador de ciclo de vida
        pushNotificationsProvider.onMessageListener();
  }

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this); // Elimina el observador cuando se dispose
    super.dispose();
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
        // ignore: prefer_const_constructors
        GetPage(name: '/PedidosAdmin', page: () =>  PedidosAdmin()),
        GetPage(name: '/SalesListPage', page: () => const SalesListPage()),
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

        GetPage(
          name: '/home/delyvery',
          page: () => ClientOrdersPage(customerId: userId!),
        ),
        GetPage(
          name: '/home/profile/address',
          page: () => const ClientDeliveryListPage(),
        ),
      ],
      theme: ThemeData(
        primaryColor: const Color(0xE5FF5100),
        fontFamily: 'Poppoins',
        colorScheme: const ColorScheme.light(
          primary: Color.fromARGB(228, 255, 255, 255),
          onPrimary: Colors.black,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        brightness: Brightness.light,
      ),
      navigatorKey: Get.key,
    );
  }
}
