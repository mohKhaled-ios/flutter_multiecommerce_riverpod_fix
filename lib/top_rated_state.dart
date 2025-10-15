// controllers/top_rated_state.dart

import 'package:multivendor_ecommerce_riverpod/models/product.dart';

abstract class TopRatedState {}

class TopRatedInitial extends TopRatedState {}

class TopRatedLoading extends TopRatedState {}

class TopRatedLoaded extends TopRatedState {
  final List<ProductModel> products;
  TopRatedLoaded(this.products);
}

class TopRatedError extends TopRatedState {
  final String message;
  TopRatedError(this.message);
}
