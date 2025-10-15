import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/subcategory_product_controller.dart';
import 'package:multivendor_ecommerce_riverpod/models/product.dart';

/// Provider يجلب قائمة منتجات حسب اسم الـ Subcategory
final subcategoryProductsProvider = FutureProvider.family
    .autoDispose<List<ProductModel>, String>((ref, subcategoryName) async {
      final service = SubcategoryProductService();
      final products = await service.getProductsBySubcategory(subcategoryName);
      return products;
    });
