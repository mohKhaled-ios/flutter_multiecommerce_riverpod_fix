// // lib/provider/review_provider.dart
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:multivendor_ecommerce_riverbod/controllers/reviewcontroller.dart';
// import 'package:multivendor_ecommerce_riverbod/models/review.dart';

// final reviewProvider = StateNotifierProvider<ReviewNotifier, List<ReviewModel>>((ref) {
//   return ReviewNotifier();
// });

// class ReviewNotifier extends StateNotifier<List<ReviewModel>> {
//   ReviewNotifier() : super([]);

//   Future<void> fetchReviews(String productId) async {
//     final reviews = await ReviewService.getProductReviews(productId);
//     state = reviews;
//   }

//   Future<bool> addReview({
//     required String buyerId,
//     required String email,
//     required String fullName,
//     required String productId,
//     required double rating,
//     String? review,
//   }) async {
//     final success = await ReviewService.addReview(
//       buyerId: buyerId,
//       email: email,
//       fullName: fullName,
//       productId: productId,
//       rating: rating,
//       review: review,
//     );
//     if (success) {
//       await fetchReviews(productId);
//     }
//     return success;
//   }
// }
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:multivendor_ecommerce_riverbod/controllers/reviewcontroller.dart';
// import 'package:multivendor_ecommerce_riverbod/models/review.dart';

// final reviewProvider = StateNotifierProvider<ReviewNotifier, List<ReviewModel>>(
//   (ref) {
//     return ReviewNotifier();
//   },
// );

// class ReviewNotifier extends StateNotifier<List<ReviewModel>> {
//   ReviewNotifier() : super([]);

//   Future<void> fetchReviews(String productId) async {
//     final reviews = await ReviewService.getProductReviews(productId);
//     state = reviews;
//   }

//   Future<bool> addReview({
//     required String buyerId,
//     required String email,
//     required String fullName,
//     required String productId,
//     required double rating,
//     String? review,
//   }) async {
//     final success = await ReviewService.addReview(
//       buyerId: buyerId,
//       email: email,
//       fullName: fullName,
//       productId: productId,
//       rating: rating,
//       review: review,
//     );

//     if (success) {
//       await fetchReviews(productId); // تحديث القائمة فوراً بعد الإضافة
//     }

//     return success;
//   }
// }

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/reviewcontroller.dart';
import 'package:multivendor_ecommerce_riverpod/models/review.dart';

final reviewProvider = StateNotifierProvider<ReviewNotifier, List<ReviewModel>>(
  (ref) {
    return ReviewNotifier();
  },
);

class ReviewNotifier extends StateNotifier<List<ReviewModel>> {
  ReviewNotifier() : super([]);

  Future<void> fetchReviews(String productId) async {
    final reviews = await ReviewService.getProductReviews(productId);
    state = reviews;
  }

  Future<bool> addReview({
    required String buyerId,
    required String email,
    required String fullName,
    required String productId,
    required double rating,
    String? review,
  }) async {
    final success = await ReviewService.addReview(
      buyerId: buyerId,
      email: email,
      fullName: fullName,
      productId: productId,
      rating: rating,
      review: review,
    );

    if (success) {
      await fetchReviews(productId);
    }
    return success;
  }

  Future<Map<String, dynamic>?> fetchAverageRating(String productId) async {
    return await ReviewService.getAverageRating(productId);
  }
}
