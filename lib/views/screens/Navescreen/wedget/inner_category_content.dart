import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:multivendor_ecommerce_riverpod/controllers/product_controller.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/sub_category_controller.dart';
import 'package:multivendor_ecommerce_riverpod/models/category.dart';
import 'package:multivendor_ecommerce_riverpod/models/product.dart';
import 'package:multivendor_ecommerce_riverpod/models/subcategory.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/wedget/header_wedget.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/wedget/productdetails_screen.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/wedget/reusable_text.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/wedget/sub_category_title.dart';

class InnerCategoryContentWedget extends StatefulWidget {
  final CategoryModel category;

  const InnerCategoryContentWedget({Key? key, required this.category})
    : super(key: key);

  @override
  State<InnerCategoryContentWedget> createState() =>
      _InnerCategoryContentWedgetState();
}

class _InnerCategoryContentWedgetState
    extends State<InnerCategoryContentWedget> {
  final SubCategoryController _subCategoryController = SubCategoryController();
  late Future<List<SubCategoryModel>> _subcategory;
  bool isLoading = false;
  List<ProductModel> products = [];
  @override
  void initState() {
    super.initState();
    _subcategory = _subCategoryController.getSubCategoriesByCategoryName(
      widget.category.name,
    );
    fetchProductsbycategory();
  }

  void fetchProductsbycategory() async {
    setState(() => isLoading = true);
    products = await ProductService().getProductsByCategory(
      context,
      widget.category.name,
    );
    setState(() => isLoading = false);
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

  /// ✅ تحويل base64 إلى Uint8List
  Uint8List base64ToImage(String base64String) {
    return base64Decode(base64String);
  }

  /// ✅ اختيار نوع الصورة (رابط أم base64)
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
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const SizedBox(
            height: 100,
            width: 100,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },
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

  @override
  Widget build(BuildContext context) {
    Uint8List imageBytes = base64Decode(widget.category.image);
    Uint8List bannerBytes = base64Decode(widget.category.banner);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.7,
        ),
        child: HeaderWedget(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.category.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Center(
              child: Image.memory(
                imageBytes,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  bannerBytes,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Created At: ${widget.category.createdAt.toLocal().toString().split('.')[0]}",
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text(
              "Updated At: ${widget.category.updatedAt.toLocal().toString().split('.')[0]}",
              style: TextStyle(color: Colors.grey[700]),
            ),

            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Shop by subcategories',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),

            FutureBuilder<List<SubCategoryModel>>(
              future: _subcategory,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.blue),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("لا توجد أقسام فرعية");
                } else {
                  final subcategories = snapshot.data!;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children:
                        subcategories.map((subcategory) {
                          return SubCategoryTitleWidget(
                            image:
                                'http://192.168.1.3:5000${subcategory.image}',
                            title: subcategory.subCategoryName,
                          );
                        }).toList(),
                  );
                }
              },
            ),

            ReusableText(title: 'Popular producte', subtitle: 'VIEW ALL'),

            isLoading
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty
                ? const Center(child: Text('لا يوجد منتجات لهذا القسم حالياً'))
                : SizedBox(
                  height: 230,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];

                      String rawImageUrl =
                          product.images.isNotEmpty ? product.images.first : '';

                      print('رابط الصورة المستخدم: $rawImageUrl');

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                        child: Container(
                          width: 150,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child:
                                        rawImageUrl.isNotEmpty
                                            ? buildProductImage(rawImageUrl)
                                            : const Icon(
                                              Icons.image,
                                              size: 100,
                                            ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product.productName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${product.productPrice} ج.م',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 15,
                                right: 2,
                                child: Image.asset(
                                  'assets/icons/love.png',
                                  height: 26,
                                  width: 26,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Image.asset(
                                  'assets/icons/cart.png',
                                  height: 26,
                                  width: 26,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
