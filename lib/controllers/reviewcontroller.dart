// // lib/services/review_service.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:multivendor_ecommerce_riverbod/models/review.dart';

// class ReviewService {
//   static const String baseUrl = "http://192.168.1.3:5000/api/reviews";

//   static Future<void> addReview({
//     required String buyerId,
//     required String email,
//     required String fullName,
//     required String productId,
//     required double rating,
//     String? review,
//   }) async {
//     final url = Uri.parse("$baseUrl/add");

//     final bodyData = {
//       "buyerId": buyerId, // ✅ تم التصحيح
//       "email": email,
//       "fullName": fullName,
//       "productId": productId,
//       "rating": rating,
//       "review": review ?? "",
//     };

//     // Debug print
//     print("Sending review body: ${jsonEncode(bodyData)}");

//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(bodyData),
//     );

//     if (response.statusCode != 201) {
//       throw Exception("Failed to add review: ${response.body}");
//     }
//   }

//   static Future<List<ReviewModel>> getProductReviews(String productId) async {
//     final url = Uri.parse("$baseUrl/product/$productId");
//     final res = await http.get(url);

//     if (res.statusCode == 200) {
//       final List data = jsonDecode(res.body);
//       return data.map((e) => ReviewModel.fromJson(e)).toList();
//     }
//     return [];
//   }
// }

// static Future<bool> addReview({
//   required String buyerId,
//   required String email,
//   required String fullName,
//   required String productId,
//   required double rating,
//   String? review,
// }) async {
//   final url = Uri.parse("$baseUrl/add");

//   final res = await http.post(
//     url,
//     headers: {"Content-Type": "application/json"},
//     body: jsonEncode({
//       "buryId": buyerId,
//       "email": email,
//       "fullName": fullName,
//       "productId": productId,
//       "rating": rating,
//       "review": review ?? "",
//     }),
//   );

//   return res.statusCode == 201;
// }
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:multivendor_ecommerce_riverbod/models/review.dart';

// class ReviewService {
//   static const String baseUrl = "http://192.168.1.3:5000/api/reviews";

//   static Future<bool> addReview({
//     required String buyerId,
//     required String email,
//     required String fullName,
//     required String productId,
//     required double rating,
//     String? review,
//   }) async {
//     final url = Uri.parse("$baseUrl/add");

//     final bodyData = {
//       "buyerId": buyerId, // ✅ تم التصحيح
//       "email": email,
//       "fullName": fullName,
//       "productId": productId,
//       "rating": rating,
//       "review": review ?? "",
//     };

//     // Debug print
//     print("Sending review body: ${jsonEncode(bodyData)}");

//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(bodyData),
//       );

//       if (response.statusCode == 201) {
//         return true; // ✅ تم الإضافة بنجاح
//       } else {
//         print("Failed to add review: ${response.body}");
//         return false;
//       }
//     } catch (e) {
//       print("Error adding review: $e");
//       return false;
//     }
//   }

//   static Future<List<ReviewModel>> getProductReviews(String productId) async {
//     final url = Uri.parse("$baseUrl/product/$productId");
//     try {
//       final res = await http.get(url);

//       if (res.statusCode == 200) {
//         final List data = jsonDecode(res.body);
//         return data.map((e) => ReviewModel.fromJson(e)).toList();
//       }
//     } catch (e) {
//       print("Error fetching reviews: $e");
//     }
//     return [];
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:multivendor_ecommerce_riverpod/models/review.dart';

class ReviewService {
  static const String baseUrl = "http://192.168.1.3:5000/api/reviews";

  static Future<bool> addReview({
    required String buyerId,
    required String email,
    required String fullName,
    required String productId,
    required double rating,
    String? review,
  }) async {
    final url = Uri.parse("$baseUrl/add");

    // تعديل الأسماء بما يتماشى مع الـ API
    final bodyData = {
      "buryId": buyerId, // اسم الحقل حسب ما السيرفر متوقعه
      "email": email,
      "fullName": fullName,
      "productId": productId,
      "rating": rating,
      "review": review ?? "",
    };

    print("Sending review body: ${jsonEncode(bodyData)}");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(bodyData),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print("Failed to add review: ${response.body}");
      return false;
    }
  }

  static Future<List<ReviewModel>> getProductReviews(String productId) async {
    final url = Uri.parse("$baseUrl/product/$productId");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => ReviewModel.fromJson(e)).toList();
    }
    return [];
  }

  static Future<Map<String, dynamic>?> getAverageRating(
    String productId,
  ) async {
    final url = Uri.parse("$baseUrl/product/$productId/average");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return {
        "averageRating":
            double.tryParse(data["averageRating"].toString()) ?? 0.0,
        "totalReviews": data["totalReviews"] ?? 0,
      };
    } else {
      print("Failed to get average rating: ${res.body}");
      return null;
    }
  }
}
