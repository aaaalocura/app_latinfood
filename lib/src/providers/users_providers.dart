import 'package:app_latin_food/src/env/env.dart';
import 'package:app_latin_food/src/models/response_api.dart';
import 'package:app_latin_food/src/models/user.dart';
import 'package:get/get.dart';

class UsersProviders extends GetConnect {
  String url = '${Env.API_URL}api';

  Future<Response> create(User user) async {
    Response response = await post(
        'http://51.161.35.133:6501/intranet/public/backend/api/customers/create/', user.toJson(),
        headers: {'Content-Type': 'application/json'});
    return response;
  }

  Future<ResponseApi> login(String email, String password) async {
    Response response = await post(
       'http://51.161.35.133:6501/intranet/public/backend/api/customers/login/',
        {'email': email, 'password': password},
        headers: {'Content-Type': 'application/json'});

    if (response.body == null) {
      Get.snackbar('Error', 'Hubo un error');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

    Future<ResponseApi> loginAdmin(String email, String password) async {
    Response response = await post(
       'http://51.161.35.133:6501/intranet/public/backend/api/users/login/admin/',
        {'email': email, 'password': password},
        headers: {'Content-Type': 'application/json'});

    if (response.body == null) {
      Get.snackbar('Error', 'Hubo un error');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }
}
