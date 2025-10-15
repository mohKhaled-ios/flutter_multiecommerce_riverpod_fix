// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:multivendor_ecommerce_riverbod/controllers/product_controller.dart';
// import 'package:multivendor_ecommerce_riverbod/models/product.dart';

// final topRatedProvider =
//     StateNotifierProvider<TopRatedNotifier, List<ProductModel>>(
//       (ref) => TopRatedNotifier(),
//     );

// class TopRatedNotifier extends StateNotifier<List<ProductModel>> {
//   TopRatedNotifier() : super([]);

//   Future<void> fetchTopRated(BuildContext context) async {
//     final products = await ProductService().getTopRatedProducts(context);
//     state = products;
//   }
// }
// controllers/top_rated_controller.dart
// controllers/top_rated_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/product_controller.dart';
import 'package:multivendor_ecommerce_riverpod/top_rated_state.dart';

final topRatedProvider = StateNotifierProvider<TopRatedNotifier, TopRatedState>(
  (ref) {
    return TopRatedNotifier();
  },
);

class TopRatedNotifier extends StateNotifier<TopRatedState> {
  TopRatedNotifier() : super(TopRatedInitial());

  Future<void> fetchTopRatedProducts(context) async {
    try {
      state = TopRatedLoading();
      final products = await ProductService().fetchTopRatedProducts(context);
      state = TopRatedLoaded(products);
    } catch (e) {
      state = TopRatedError(e.toString());
    }
  }
}
