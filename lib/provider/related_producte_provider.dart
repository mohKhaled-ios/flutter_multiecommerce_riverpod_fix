import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/product_controller.dart';
import 'package:multivendor_ecommerce_riverpod/models/product.dart';

// final relatedProductsProvider =
//     FutureProvider.family<List<ProductModel>, String>((ref, productId) async {
//       final service = ProductService();
//       return await service.getRelatedProducts(
//         ref.read(navigatorKeyProvider).currentContext!, // عشان نمرر الـ context
//         productId,
//       );
//     });

final relatedProductsProvider =
    FutureProvider.family<List<ProductModel>, String>((ref, productId) async {
      final service = ProductService();
      return await service.getRelatedProducts(productId);
    });

// مفتاح عام للـ context
final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return GlobalKey<NavigatorState>();
});
