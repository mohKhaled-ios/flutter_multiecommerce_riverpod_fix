import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multivendor_ecommerce_riverpod/models/subcategory.dart';
import 'package:multivendor_ecommerce_riverpod/service/manager_http_response.dart';

class SubCategoryController {
  static const String baseUrl = 'http://192.168.1.3:5000/api/subcategories';

  // /// ⬆️ إضافة فئة فرعية جديدة
  // Future<void> addSubCategory({
  //   required String categoryId,
  //   required String categoryName,
  //   required String subCategoryName,
  //   required File imageFile,
  //   required BuildContext context,
  //   required VoidCallback onSuccess,
  // }) async {
  //   try {
  //     var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
  //     request.fields['categoryId'] = categoryId;
  //     request.fields['categoryname'] = categoryName;
  //     request.fields['subcategoryname'] = subCategoryName;
  //     request.files.add(
  //       await http.MultipartFile.fromPath('image', imageFile.path),
  //     );

  //     var streamedResponse = await request.send();
  //     var response = await http.Response.fromStream(streamedResponse);

  //     httpResponseHandler(
  //       response: response,
  //       context: context,
  //       onSuccess: onSuccess,
  //     );
  //   } catch (e) {
  //     showSnackBar(context, 'حدث خطأ أثناء إرسال الطلب: $e');
  //   }
  // }

  // /// ✏️ تعديل فئة فرعية
  // Future<void> updateSubCategory({
  //   required String id,
  //   required String categoryId,
  //   required String categoryName,
  //   required String subCategoryName,
  //   File? imageFile,
  //   required BuildContext context,
  //   required VoidCallback onSuccess,
  // }) async {
  //   try {
  //     var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/$id'));
  //     request.fields['categoryId'] = categoryId;
  //     request.fields['categoryname'] = categoryName;
  //     request.fields['subcategoryname'] = subCategoryName;

  //     if (imageFile != null) {
  //       request.files.add(
  //         await http.MultipartFile.fromPath('image', imageFile.path),
  //       );
  //     }

  //     var streamedResponse = await request.send();
  //     var response = await http.Response.fromStream(streamedResponse);

  //     httpResponseHandler(
  //       response: response,
  //       context: context,
  //       onSuccess: onSuccess,
  //     );
  //   } catch (e) {
  //     showSnackBar(context, 'حدث خطأ أثناء تحديث الفئة الفرعية: $e');
  //   }
  // }

  /// 📦 جلب كل الفئات الفرعية
  Future<List<SubCategoryModel>> getAllSubCategories() async {
    final res = await http.get(Uri.parse(baseUrl));

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => SubCategoryModel.fromJson(e)).toList();
    } else {
      throw Exception('فشل في تحميل الفئات الفرعية');
    }
  }

  /// 📦 جلب الفئات الفرعية حسب اسم القسم
  Future<List<SubCategoryModel>> getSubCategoriesByCategoryName(
    String categoryName,
  ) async {
    final res = await http.get(Uri.parse('$baseUrl/category/$categoryName'));

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => SubCategoryModel.fromJson(e)).toList();
    } else {
      throw Exception('فشل في تحميل الفئات الفرعية حسب القسم');
    }
  }

  /// 🗑️ حذف فئة فرعية
  Future<void> deleteSubCategory(
    String id,
    BuildContext context,
    VoidCallback onSuccess,
  ) async {
    try {
      final res = await http.delete(Uri.parse('$baseUrl/$id'));

      httpResponseHandler(
        response: res,
        context: context,
        onSuccess: onSuccess,
      );
    } catch (e) {
      showSnackBar(context, 'حدث خطأ أثناء حذف الفئة الفرعية: $e');
    }
  }
}
