import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/product_controller.dart';

import 'package:multivendor_ecommerce_riverpod/models/product.dart';

// 🏷️ حالة البحث (AsyncValue)
final productSearchProvider = StateNotifierProvider.autoDispose<
  ProductSearchNotifier,
  AsyncValue<List<ProductModel>>
>((ref) => ProductSearchNotifier());

class ProductSearchNotifier
    extends StateNotifier<AsyncValue<List<ProductModel>>> {
  ProductSearchNotifier() : super(const AsyncValue.data([]));

  Future<void> search(String keyword) async {
    if (keyword.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final results = await ProductService().searchProducts(keyword);
      state = AsyncValue.data(results);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
