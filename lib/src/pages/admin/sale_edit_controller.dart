import 'dart:convert';

import 'package:app_latin_food/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../models/sale_model.dart';

class SaleEditController extends GetxController {




  Future<List<Sale>> fetchSales() async {
    final response = await http.get(
        Uri.parse('https://kdlatinfood.com/intranet/public/api/despachos'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['data'];
      return jsonList.map((json) => Sale.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sales');
    }
  }
}
