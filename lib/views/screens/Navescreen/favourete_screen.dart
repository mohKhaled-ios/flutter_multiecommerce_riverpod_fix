import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/favourite_controller.dart';
import 'package:multivendor_ecommerce_riverpod/models/product.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/wedget/productdetails_screen.dart';

class FavoriteProductsScreen extends StatefulWidget {
  const FavoriteProductsScreen({super.key});

  @override
  State<FavoriteProductsScreen> createState() => _FavoriteProductsScreenState();
}

class _FavoriteProductsScreenState extends State<FavoriteProductsScreen> {
  List<ProductModel> favoriteProducts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    setState(() => isLoading = true);
    favoriteProducts = await FavoriteService.getFavorites();
    setState(() => isLoading = false);
  }

  Uint8List base64ToImage(String base64String) {
    return base64Decode(base64String);
  }

  String fixUnsplashUrl(String url) {
    final regex = RegExp(r'unsplash\.com/photos/([a-zA-Z0-9_-]+)');
    final match = regex.firstMatch(url);
    if (match != null) {
      final photoId = match.group(1);
      return 'https://source.unsplash.com/$photoId/400x400';
    }
    return url;
  }

  Widget buildProductImage(String rawImageUrl) {
    if (rawImageUrl.startsWith('http')) {
      String fixedUrl = fixUnsplashUrl(rawImageUrl);
      return Image.network(
        fixedUrl,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 60),
      );
    } else {
      try {
        final imageBytes = base64ToImage(rawImageUrl);
        return Image.memory(
          imageBytes,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        );
      } catch (e) {
        return const Icon(Icons.error, size: 60);
      }
    }
  }

  Future<void> removeFromFavorites(String productId) async {
    await FavoriteService.removeFromFavorites(productId);
    fetchFavorites();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم الإزالة من المفضلة')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("المفضلة"),
        backgroundColor: Colors.green,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : favoriteProducts.isEmpty
              ? const Center(child: Text("لا يوجد منتجات في المفضلة"))
              : ListView.builder(
                itemCount: favoriteProducts.length,
                itemBuilder: (context, index) {
                  final product = favoriteProducts[index];
                  String rawImageUrl =
                      product.images.isNotEmpty ? product.images.first : '';

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:
                            rawImageUrl.isNotEmpty
                                ? buildProductImage(rawImageUrl)
                                : const Icon(Icons.image, size: 60),
                      ),
                      title: Text(
                        product.productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        "${product.productPrice} ج.م",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed:
                            () => removeFromFavorites(product.id.toString()),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ProductDetailsScreen(product: product),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
