import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/favourite_controller.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/reviewcontroller.dart';
import 'package:multivendor_ecommerce_riverpod/models/cartmodel.dart';
import 'package:multivendor_ecommerce_riverpod/models/product.dart';
import 'package:multivendor_ecommerce_riverpod/provider/cart_provider.dart';
import 'package:multivendor_ecommerce_riverpod/provider/related_producte_provider.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  Map<String, dynamic>? ratingData;
  bool isLoadingRating = true;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    fetchAverageRating();
    checkFavoriteStatus();
  }

  Future<void> checkFavoriteStatus() async {
    final favStatus = await FavoriteService.isFavorite(widget.product.id);
    setState(() {
      isFavorite = favStatus;
    });
  }

  Future<void> fetchAverageRating() async {
    final data = await ReviewService.getAverageRating(
      widget.product.id.toString(),
    );
    setState(() {
      ratingData = data ?? {"averageRating": 0.0, "totalReviews": 0};
      isLoadingRating = false;
    });
  }

  /// يحول Base64 إلى صورة
  Uint8List base64ToImage(String base64String) {
    return base64Decode(base64String);
  }

  /// يصلح روابط unsplash
  String fixUnsplashUrl(String url) {
    final regex = RegExp(r'unsplash\.com/photos/([a-zA-Z0-9_-]+)');
    final match = regex.firstMatch(url);
    if (match != null) {
      final photoId = match.group(1);
      return 'https://source.unsplash.com/$photoId/600x600';
    }
    return url;
  }

  /// يبني صورة سواء كانت URL أو Base64
  Widget buildProductImage(
    String rawImageUrl, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    if (rawImageUrl.isEmpty) {
      return const Icon(Icons.broken_image, size: 80);
    }

    if (rawImageUrl.startsWith('http')) {
      String fixedUrl = fixUnsplashUrl(rawImageUrl);
      return Image.network(
        fixedUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder:
            (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 80),
      );
    } else {
      try {
        final imageBytes = base64ToImage(rawImageUrl);
        return Image.memory(imageBytes, width: width, height: height, fit: fit);
      } catch (e) {
        return const Icon(Icons.error, size: 80);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        widget.product.images.isNotEmpty ? widget.product.images.first : '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المنتج'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildProductImage(
              imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),

            // اسم المنتج
            Text(
              widget.product.productName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // عرض التقييم
            isLoadingRating
                ? const CircularProgressIndicator()
                : Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      (ratingData?["averageRating"] ?? 0.0).toStringAsFixed(1),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "(${ratingData?["totalReviews"] ?? 0} تقييم)",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
            const SizedBox(height: 8),

            // السعر
            Text(
              '${widget.product.productPrice} ج.م',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // القسم
            Row(
              children: [
                const Icon(Icons.category),
                const SizedBox(width: 8),
                Text('القسم: ${widget.product.category}'),
              ],
            ),
            const SizedBox(height: 8),

            // الفئة الفرعية
            Row(
              children: [
                const Icon(Icons.subdirectory_arrow_right),
                const SizedBox(width: 8),
                Text('الفئة الفرعية: ${widget.product.subcategory}'),
              ],
            ),
            const Divider(height: 32),

            // الوصف
            const Text(
              'الوصف:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.description,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),
            const Text(
              'منتجات مشابهة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 📌 المنتجات المرتبطة
            Consumer(
              builder: (context, ref, child) {
                final relatedProductsAsync = ref.watch(
                  relatedProductsProvider(widget.product.id),
                );

                return relatedProductsAsync.when(
                  data: (relatedProducts) {
                    if (relatedProducts.isEmpty) {
                      return const Text("لا توجد منتجات مرتبطة");
                    }
                    return SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: relatedProducts.length,
                        itemBuilder: (context, index) {
                          final product = relatedProducts[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => ProductDetailsScreen(
                                        product: product,
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              width: 140,
                              margin: const EdgeInsets.only(right: 10),
                              child: Column(
                                children: [
                                  buildProductImage(
                                    product.images.isNotEmpty
                                        ? product.images.first
                                        : '',
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    product.productName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "${product.productPrice} ج.م",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text("خطأ: $err"),
                );
              },
            ),

            const SizedBox(height: 20),

            // زر الإضافة إلى السلة وزر المفضلة
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('إضافة إلى السلة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      final cartItem = CartItem(
                        category: widget.product.category,
                        vendorId: widget.product.vendorId,
                        id: widget.product.id,
                        name: widget.product.productName,
                        image: imageUrl,
                        price: widget.product.productPrice,
                      );

                      ref.read(cartProvider.notifier).addToCart(cartItem);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تمت الإضافة إلى السلة'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),

                IconButton(
                  onPressed: () async {
                    if (isFavorite) {
                      await FavoriteService.removeFromFavorites(
                        widget.product.id,
                      );
                      setState(() => isFavorite = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم الإزالة من المفضلة')),
                      );
                    } else {
                      await FavoriteService.addToFavorites(widget.product);
                      setState(() => isFavorite = true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تمت الإضافة إلى المفضلة'),
                        ),
                      );
                    }
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  color: Colors.red,
                  iconSize: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
