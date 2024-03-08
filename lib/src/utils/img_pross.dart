import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:typed_data';


class ImageProcessor {
  static Future<Uint8List> compressImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      final compressedBytes = await FlutterImageCompress.compressWithList(
        response.bodyBytes,
        minWidth: 1280 ,
        minHeight: 720 ,
        quality: 30, // Ajusta la calidad de compresión según tus necesidades
      );
      return compressedBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }
}