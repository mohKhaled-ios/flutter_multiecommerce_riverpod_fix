import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multivendor_ecommerce_riverpod/models/banner.dart';
import 'package:multivendor_ecommerce_riverpod/service/manager_http_response.dart';

class BannerController {
  Future<void> uploadBanner({
    required BuildContext context,
    required Uint8List bannerImage,
    required String fileName,
  }) async {
    try {
      var uri = Uri.parse('http://192.168.1.3:5000/api/banners');

      var request = http.MultipartRequest('POST', uri);
      request.files.add(
        http.MultipartFile.fromBytes('image', bannerImage, filename: fileName),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      httpResponseHandler(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, '✅ تم رفع البانر بنجاح');
        },
      );
    } catch (e) {
      showSnackBar(context, '❌ فشل رفع البانر: $e');
    }
  }

  /// ✅ جلب البانرات
  Future<List<BannerModel>> fetchBanners(BuildContext context) async {
    try {
      final uri = Uri.parse('http://192.168.1.3:5000/api/banners');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((json) => BannerModel.fromJson(json)).toList();
      } else {
        showSnackBar(context, 'فشل في جلب البانرات');
        return [];
      }
    } catch (e) {
      showSnackBar(context, 'خطأ في الاتصال بالسيرفر: $e');
      return [];
    }
  }
}
