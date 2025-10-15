import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:multivendor_ecommerce_riverpod/provider/search_provider.dart';

class ProductSearchScreen extends ConsumerWidget {
  const ProductSearchScreen({super.key});

  /// تحويل Base64 إلى صورة
  Uint8List base64ToImage(String base64String) {
    return base64Decode(base64String);
  }

  /// إصلاح روابط Unsplash
  String fixUnsplashUrl(String url) {
    final regex = RegExp(r'unsplash\.com/photos/([a-zA-Z0-9_-]+)');
    final match = regex.firstMatch(url);
    if (match != null) {
      final photoId = match.group(1);
      return 'https://source.unsplash.com/$photoId/600x600';
    }
    return url;
  }

  /// عرض الصورة (Base64 أو Network)
  Widget buildProductImage(
    String rawImageUrl, {
    double width = 50,
    double height = 50,
  }) {
    if (rawImageUrl.isEmpty) {
      return const Icon(Icons.image, size: 50);
    }

    if (rawImageUrl.startsWith('http')) {
      String fixedUrl = fixUnsplashUrl(rawImageUrl);
      return Image.network(
        fixedUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 50),
      );
    } else {
      try {
        final imageBytes = base64ToImage(rawImageUrl);
        return Image.memory(
          imageBytes,
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
      } catch (e) {
        return const Icon(Icons.error, size: 50);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(productSearchProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('بحث عن المنتجات')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'اكتب اسم المنتج...',
                border: OutlineInputBorder(),
              ),
              onChanged:
                  (value) =>
                      ref.read(productSearchProvider.notifier).search(value),
            ),
          ),
          Expanded(
            child: searchState.when(
              data:
                  (products) =>
                      products.isEmpty
                          ? const Center(child: Text('لا توجد نتائج'))
                          : ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              final imageUrl =
                                  product.images.isNotEmpty
                                      ? product.images.first
                                      : '';
                              return ListTile(
                                onTap: () {},
                                leading: buildProductImage(imageUrl),
                                title: Text(product.productName),
                                subtitle: Text('${product.productPrice} جنيه'),
                              );
                            },
                          ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('خطأ: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
