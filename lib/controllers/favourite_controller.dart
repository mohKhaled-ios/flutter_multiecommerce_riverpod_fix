import 'dart:convert';
import 'package:multivendor_ecommerce_riverpod/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String _key = "favorites";

  /// إضافة منتج إلى المفضلة
  static Future<void> addToFavorites(ProductModel product) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_key) ?? [];

    // تحويل المنتج لـ JSON وتخزينه كسلسلة نصية
    final productJson = jsonEncode(product.toJson()..['id'] = product.id);

    // تجنب التكرار
    if (!favorites.contains(productJson)) {
      favorites.add(productJson);
      await prefs.setStringList(_key, favorites);
    }
  }

  /// إزالة منتج من المفضلة
  static Future<void> removeFromFavorites(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_key) ?? [];

    favorites.removeWhere((item) {
      final decoded = jsonDecode(item);
      return decoded['id'] == productId;
    });

    await prefs.setStringList(_key, favorites);
  }

  /// جلب قائمة المفضلة
  static Future<List<ProductModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_key) ?? [];

    return favorites.map((item) {
      final decoded = jsonDecode(item);
      return ProductModel.fromJson(decoded..['_id'] = decoded['id']);
    }).toList();
  }

  /// التحقق إذا المنتج في المفضلة
  static Future<bool> isFavorite(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_key) ?? [];

    return favorites.any((item) {
      final decoded = jsonDecode(item);
      return decoded['id'] == productId;
    });
  }
}
