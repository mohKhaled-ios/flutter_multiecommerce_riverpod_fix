import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:multivendor_ecommerce_riverpod/models/product.dart';

class SubcategoryProductService {
  final String baseUrl = 'http://192.168.1.3:5000/api/products';

  /// جلب المنتجات حسب اسم الـ Subcategory
  Future<List<ProductModel>> getProductsBySubcategory(
    String subcategoryName,
  ) async {
    final uri = Uri.parse('$baseUrl/subcategory/$subcategoryName');

    final response = await http.get(
      uri,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else if (response.statusCode == 404) {
      // لا توجد منتجات في هذه الفئة الفرعية
      return <ProductModel>[];
    } else {
      throw Exception(
        'فشل في جلب منتجات الفئة الفرعية (${response.statusCode})',
      );
    }
  }
}
