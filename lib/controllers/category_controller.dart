import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:multivendor_ecommerce_riverpod/models/category.dart';
import 'package:multivendor_ecommerce_riverpod/service/manager_http_response.dart';

class CategoryController {
  Future<void> uploadCategory({
    required BuildContext context,
    required String name,
    required Uint8List pickimage,
    required Uint8List pickbanner,
  }) async {
    try {
      var uri = Uri.parse('http://192.168.1.3:5000/api/categories');

      var request = http.MultipartRequest('POST', uri);

      request.fields['name'] = name;

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          pickimage,
          filename: 'category.jpg',
        ),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'banner',
          pickbanner,
          filename: 'banner.jpg',
        ),
      );

      // إرسال الطلب
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      httpResponseHandler(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, '✅ تم رفع القسم بنجاح');
        },
      );
    } catch (e) {
      showSnackBar(context, '❌ فشل رفع القسم: $e');
    }
  }

  Future<List<CategoryModel>> fetchAllCategories(BuildContext context) async {
    List<CategoryModel> categoryList = [];

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.3:5000/api/categories'),
      );

      httpResponseHandler(
        response: response,
        context: context,
        onSuccess: () {
          final List data = jsonDecode(response.body);
          categoryList =
              data
                  .map((categoryJson) => CategoryModel.fromJson(categoryJson))
                  .toList();
        },
      );
    } catch (e) {
      showSnackBar(context, 'حدث خطأ أثناء الاتصال بالسيرفر.');
    }

    return categoryList;
  }
}
