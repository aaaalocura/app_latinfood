import 'package:app_latin_food/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SaleEditController extends GetxController{
  User user=User.fromJson(GetStorage().read('user'));
  TextEditingController barcodeController = TextEditingController();
TextEditingController quantityController = TextEditingController();

}