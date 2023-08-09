import 'package:app_latin_food/src/env/env.dart';
import 'package:app_latin_food/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:app_latin_food/src/models/category.dart';


class CategoriesProviders extends GetConnect{
  String url='${Env.API_URL}api';

  User userSession=User.fromJson(GetStorage().read('user')??{});

    Future<List<Category>> getAll() async {
    Response response = await get(
        '$url/categories',
        headers: {
          'Content-Type': 'application/json',
         
        }
    ); 

    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada', 'Tu usuario no tiene permitido leer esta informacion');
      return [];
    }
    
    List<Category> categories = Category.fromJsonList(response.body);

    return categories;
  }



}

