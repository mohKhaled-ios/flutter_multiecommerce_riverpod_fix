// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:multivendor_ecommerce_riverbod/controllers/shipping_address_service.dart';
// import 'package:multivendor_ecommerce_riverbod/models/product.dart';
// import 'package:multivendor_ecommerce_riverbod/service/manager_http_response.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ProductService {
//   final String baseUrl =
//       'http://192.168.1.3:5000/api/products'; // ✅ غيّرها حسب السيرفر الخاص بك

//   Future<void> createProduct({
//     required BuildContext context,
//     required ProductModel product,
//     required VoidCallback onSuccess,
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse(baseUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(product.toJson()),
//       );

//       httpResponseHandler(
//         response: response,
//         context: context,
//         onSuccess: onSuccess,
//       );
//     } catch (e) {
//       showSnackBar(context, e.toString());
//     }
//   }

//   // Future<List<ProductModel>> getRelatedProducts(
//   //   BuildContext context,
//   //   String productId,
//   // ) async {
//   //   try {
//   //     final response = await http.get(Uri.parse('$baseUrl/related/$productId'));
//   //     if (response.statusCode == 200) {
//   //       final List data = jsonDecode(response.body);
//   //       return data.map((e) => ProductModel.fromJson(e)).toList();
//   //     } else {
//   //       showSnackBar(context, 'فشل تحميل المنتجات المرتبطة');
//   //       return [];
//   //     }
//   //   } catch (e) {
//   //     showSnackBar(context, e.toString());
//   //     return [];
//   //   }
//   // }

//   Future<List<ProductModel>> getRelatedProducts(String productId) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/related/$productId'),
//       headers: {"Content-Type": "application/json"},
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body) as List;
//       return data.map((e) => ProductModel.fromJson(e)).toList();
//     } else {
//       throw Exception("فشل في تحميل المنتجات المرتبطة");
//     }
//   }

//   Future<List<ProductModel>> getAllProducts(BuildContext context) async {
//     try {
//       final response = await http.get(Uri.parse(baseUrl));
//       if (response.statusCode == 200) {
//         final List data = jsonDecode(response.body);
//         return data.map((e) => ProductModel.fromJson(e)).toList();
//       } else {
//         showSnackBar(context, 'فشل تحميل المنتجات');
//         return [];
//       }
//     } catch (e) {
//       showSnackBar(context, e.toString());
//       return [];
//     }
//   }

//   Future<ProductModel?> getProductById(BuildContext context, String id) async {
//     try {
//       final response = await http.get(Uri.parse('$baseUrl/$id'));
//       if (response.statusCode == 200) {
//         return ProductModel.fromJson(jsonDecode(response.body));
//       } else {
//         showSnackBar(context, 'فشل تحميل المنتج');
//         return null;
//       }
//     } catch (e) {
//       showSnackBar(context, e.toString());
//       return null;
//     }
//   }

//   Future<List<ProductModel>> getPopularProducts(BuildContext context) async {
//     try {
//       final response = await http.get(Uri.parse('$baseUrl/popular/list'));
//       if (response.statusCode == 200) {
//         final List data = jsonDecode(response.body);
//         return data.map((e) => ProductModel.fromJson(e)).toList();
//       } else {
//         showSnackBar(context, 'فشل تحميل المنتجات الشعبية');
//         return [];
//       }
//     } catch (e) {
//       showSnackBar(context, e.toString());
//       return [];
//     }
//   }

//   Future<List<ProductModel>> getRecommendedProducts(
//     BuildContext context,
//   ) async {
//     try {
//       final response = await http.get(Uri.parse('$baseUrl/recommended/list'));
//       if (response.statusCode == 200) {
//         final List data = jsonDecode(response.body);
//         return data.map((e) => ProductModel.fromJson(e)).toList();
//       } else {
//         showSnackBar(context, 'فشل تحميل المنتجات الموصى بها');
//         return [];
//       }
//     } catch (e) {
//       showSnackBar(context, e.toString());
//       return [];
//     }
//   }

//   Future<void> deleteProduct({
//     required BuildContext context,
//     required String id,
//     required VoidCallback onSuccess,
//   }) async {
//     try {
//       final response = await http.delete(Uri.parse('$baseUrl/$id'));

//       httpResponseHandler(
//         response: response,
//         context: context,
//         onSuccess: onSuccess,
//       );
//     } catch (e) {
//       showSnackBar(context, e.toString());
//     }

// }

//     static Future<List<ProductModel>> fetchTopRatedProducts() async {
//     final response = await http.get(Uri.parse("$baseUrl/top-rated"));

//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);
//       return data.map((e) => ProductModel.fromJson(e)).toList();
//     } else {
//       throw Exception("فشل تحميل المنتجات الأعلى تقييماً");
//     }
//   }

//   Future<void> updateProduct({
//     required BuildContext context,
//     required ProductModel product,
//     required VoidCallback onSuccess,
//   }) async {
//     try {
//       final response = await http.put(
//         Uri.parse('$baseUrl/${product.id}'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(product.toJson()),
//       );

//       httpResponseHandler(
//         response: response,
//         context: context,
//         onSuccess: onSuccess,
//       );
//     } catch (e) {
//       showSnackBar(context, e.toString());
//     }
//   }

//   Future<List<ProductModel>> getProductsByCategory(
//     BuildContext context,
//     String categoryName,
//   ) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/category/$categoryName'),
//       );

//       if (response.statusCode == 200) {
//         final List data = jsonDecode(response.body);
//         return data.map((e) => ProductModel.fromJson(e)).toList();
//       } else if (response.statusCode == 404) {
//         showSnackBar(context, 'لا توجد منتجات في هذا القسم');
//         return [];
//       } else {
//         showSnackBar(context, 'فشل تحميل منتجات القسم');
//         return [];
//       }
//     } catch (e) {
//       showSnackBar(context, e.toString());
//       return [];
//     }
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:multivendor_ecommerce_riverpod/models/product.dart';
import 'package:multivendor_ecommerce_riverpod/service/manager_http_response.dart';

class ProductService {
  final String baseUrl =
      'http://192.168.1.3:5000/api/products'; // ✅ غيّرها حسب السيرفر الخاص بك

  // ==================== CRUD ==================== //

  Future<List<ProductModel>> searchProducts(String keyword) async {
    final url = Uri.parse('$baseUrl/search?keyword=$keyword');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => ProductModel.fromJson(item)).toList();
    } else if (response.statusCode == 404) {
      return []; // لا توجد نتائج
    } else {
      throw Exception('فشل في البحث عن المنتجات');
    }
  }

  Future<void> createProduct({
    required BuildContext context,
    required ProductModel product,
    required VoidCallback onSuccess,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product.toJson()),
      );

      httpResponseHandler(
        response: response,
        context: context,
        onSuccess: onSuccess,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<ProductModel>> getAllProducts(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => ProductModel.fromJson(e)).toList();
      } else {
        showSnackBar(context, 'فشل تحميل المنتجات');
        return [];
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      return [];
    }
  }

  Future<ProductModel?> getProductById(BuildContext context, String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return ProductModel.fromJson(jsonDecode(response.body));
      } else {
        showSnackBar(context, 'فشل تحميل المنتج');
        return null;
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      return null;
    }
  }

  Future<void> updateProduct({
    required BuildContext context,
    required ProductModel product,
    required VoidCallback onSuccess,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${product.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product.toJson()),
      );

      httpResponseHandler(
        response: response,
        context: context,
        onSuccess: onSuccess,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> deleteProduct({
    required BuildContext context,
    required String id,
    required VoidCallback onSuccess,
  }) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      httpResponseHandler(
        response: response,
        context: context,
        onSuccess: onSuccess,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // ==================== SPECIAL QUERIES ==================== //

  Future<List<ProductModel>> getRelatedProducts(String productId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/related/$productId'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception("فشل في تحميل المنتجات المرتبطة");
    }
  }

  // Future<List<ProductModel>> getRelatedProducts(
  //   BuildContext context,
  //   String productId,
  // ) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/related/$productId'),
  //       headers: {"Content-Type": "application/json"},
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body) as List;
  //       return data.map((e) => ProductModel.fromJson(e)).toList();
  //     } else {
  //       showSnackBar(context, "فشل في تحميل المنتجات المرتبطة");
  //       return [];
  //     }
  //   } catch (e) {
  //     showSnackBar(context, e.toString());
  //     return [];
  //   }
  // }

  Future<List<ProductModel>> getPopularProducts(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/popular/list'));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => ProductModel.fromJson(e)).toList();
      } else {
        showSnackBar(context, 'فشل تحميل المنتجات الشعبية');
        return [];
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> getRecommendedProducts(
    BuildContext context,
  ) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/recommended/list'));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => ProductModel.fromJson(e)).toList();
      } else {
        showSnackBar(context, 'فشل تحميل المنتجات الموصى بها');
        return [];
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> fetchTopRatedProducts(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/top-rated"));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => ProductModel.fromJson(e)).toList();
      } else {
        showSnackBar(context, "فشل تحميل المنتجات الأعلى تقييماً");
        return [];
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> getProductsByCategory(
    BuildContext context,
    String categoryName,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/category/$categoryName'),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => ProductModel.fromJson(e)).toList();
      } else if (response.statusCode == 404) {
        showSnackBar(context, 'لا توجد منتجات في هذا القسم');
        return [];
      } else {
        showSnackBar(context, 'فشل تحميل منتجات القسم');
        return [];
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      return [];
    }
  }
}
