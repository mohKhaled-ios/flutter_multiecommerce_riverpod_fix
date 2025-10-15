import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/favourite_controller.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/product_controller.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/reviewcontroller.dart';
import 'package:multivendor_ecommerce_riverpod/models/cartmodel.dart';
import 'package:multivendor_ecommerce_riverpod/models/product.dart';
import 'package:multivendor_ecommerce_riverpod/provider/cart_provider.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/wedget/productdetails_screen.dart';

class PopularProductsScreen extends ConsumerStatefulWidget {
  const PopularProductsScreen({super.key});

  @override
  ConsumerState<PopularProductsScreen> createState() =>
      _PopularProductsScreenState();
}

class _PopularProductsScreenState extends ConsumerState<PopularProductsScreen> {
  List<ProductModel> products = [];
  Map<String, bool> favoritesMap = {}; // حالة المفضلة لكل منتج
  Map<String, Map<String, dynamic>> ratingsMap = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchPopularProducts();
  }

  Future<void> fetchPopularProducts() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    products = await ProductService().getPopularProducts(context);

    // جلب التقييمات وحالة المفضلة
    for (var product in products) {
      final ratingData = await ReviewService.getAverageRating(
        product.id.toString(),
      );
      if (ratingData != null) {
        ratingsMap[product.id.toString()] = ratingData;
      }

      final favStatus = await FavoriteService.isFavorite(product.id);
      favoritesMap[product.id.toString()] = favStatus;
    }

    if (!mounted) return;
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

  Uint8List base64ToImage(String base64String) {
    return base64Decode(base64String);
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
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : products.isEmpty
        ? const Center(child: Text('لا يوجد منتجات شعبية حالياً'))
        : SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              String rawImageUrl =
                  product.images.isNotEmpty ? product.images.first : '';

              final ratingData =
                  ratingsMap[product.id.toString()] ??
                  {"averageRating": 0.0, "totalReviews": 0};

              bool isFavorite = favoritesMap[product.id.toString()] ?? false;

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsScreen(product: product),
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
                                    : const Icon(Icons.image, size: 100),
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
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                ratingData["averageRating"].toStringAsFixed(1),
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${ratingData["totalReviews"]})',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        top: 15,
                        right: 2,
                        child: InkWell(
                          onTap: () async {
                            if (isFavorite) {
                              await FavoriteService.removeFromFavorites(
                                product.id,
                              );
                              setState(
                                () =>
                                    favoritesMap[product.id.toString()] = false,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تم الإزالة من المفضلة'),
                                ),
                              );
                            } else {
                              await FavoriteService.addToFavorites(product);
                              setState(
                                () =>
                                    favoritesMap[product.id.toString()] = true,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تمت الإضافة إلى المفضلة'),
                                ),
                              );
                            }
                          },
                          child:
                              isFavorite
                                  ? Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 26,
                                  ) // قلب أحمر
                                  : Image.asset(
                                    'assets/icons/love.png',
                                    height: 26,
                                    width: 26,
                                  ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            final cartItem = CartItem(
                              category: product.category,
                              vendorId: product.vendorId,
                              id: product.id,
                              name: product.productName,
                              image: product.images.first,
                              price: product.productPrice,
                            );

                            ref.read(cartProvider.notifier).addToCart(cartItem);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تمت الإضافة إلى السلة'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/icons/cart.png',
                            height: 26,
                            width: 26,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
  }
}
//   List<ProductModel> products = [];
//   Map<String, Map<String, dynamic>> ratingsMap =
//       {}; // لتخزين التقييمات لكل منتج
//   bool isLoading = false;
//   bool isFavorite = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchPopularProducts();
//     checkFavoriteStatus();
//   }

//   Future<void> checkFavoriteStatus() async {
//     final favStatus = await FavoriteService.isFavorite(widget.product.id);
//     setState(() {
//       isFavorite = favStatus;
//     });
//   }

//   void fetchPopularProducts() async {
//     if (!mounted) return;
//     setState(() => isLoading = true);
//     products = await ProductService().getPopularProducts(context);

//     // جلب متوسط التقييم لكل منتج
//     for (var product in products) {
//       final ratingData = await ReviewService.getAverageRating(
//         product.id.toString(),
//       );
//       if (ratingData != null) {
//         ratingsMap[product.id.toString()] = ratingData;
//       }
//     }

//     if (!mounted) return;
//     setState(() => isLoading = false);
//   }

//   String fixUnsplashUrl(String url) {
//     final regex = RegExp(r'unsplash\.com/photos/([a-zA-Z0-9_-]+)');
//     final match = regex.firstMatch(url);
//     if (match != null) {
//       final photoId = match.group(1);
//       return 'https://source.unsplash.com/$photoId/400x400';
//     }
//     return url;
//   }

//   Uint8List base64ToImage(String base64String) {
//     return base64Decode(base64String);
//   }

//   Widget buildProductImage(String rawImageUrl) {
//     if (rawImageUrl.startsWith('http')) {
//       String fixedUrl = fixUnsplashUrl(rawImageUrl);
//       return Image.network(
//         fixedUrl,
//         width: 100,
//         height: 100,
//         fit: BoxFit.cover,
//         errorBuilder:
//             (context, error, stackTrace) =>
//                 const Icon(Icons.broken_image, size: 60),
//         loadingBuilder: (context, child, loadingProgress) {
//           if (loadingProgress == null) return child;
//           return const SizedBox(
//             height: 100,
//             width: 100,
//             child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
//           );
//         },
//       );
//     } else {
//       try {
//         final imageBytes = base64ToImage(rawImageUrl);
//         return Image.memory(
//           imageBytes,
//           width: 100,
//           height: 100,
//           fit: BoxFit.cover,
//         );
//       } catch (e) {
//         return const Icon(Icons.error, size: 60);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isLoading
//         ? const Center(child: CircularProgressIndicator())
//         : products.isEmpty
//         ? const Center(child: Text('لا يوجد منتجات شعبية حالياً'))
//         : SizedBox(
//           height: 250,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: products.length,
//             itemBuilder: (context, index) {
//               final product = products[index];
//               String rawImageUrl =
//                   product.images.isNotEmpty ? product.images.first : '';

//               final ratingData =
//                   ratingsMap[product.id.toString()] ??
//                   {"averageRating": 0.0, "totalReviews": 0};

//               return InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => ProductDetailsScreen(product: product),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   width: 150,
//                   margin: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.2),
//                         spreadRadius: 2,
//                         blurRadius: 6,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Stack(
//                     children: [
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child:
//                                 rawImageUrl.isNotEmpty
//                                     ? buildProductImage(rawImageUrl)
//                                     : const Icon(Icons.image, size: 100),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             product.productName,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           Text(
//                             '${product.productPrice} ج.م',
//                             style: const TextStyle(
//                               color: Colors.green,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.star, color: Colors.amber, size: 16),
//                               const SizedBox(width: 4),
//                               Text(
//                                 ratingData["averageRating"].toStringAsFixed(1),
//                                 style: const TextStyle(fontSize: 12),
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 '(${ratingData["totalReviews"]})',
//                                 style: const TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       Positioned(
//                         top: 15,
//                         right: 2,
//                         child: InkWell(
//                           onTap: () async{
//                             if (isFavorite) {
//       await FavoriteService.removeFromFavorites(widget.product.id);
//       setState(() => isFavorite = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('تم الإزالة من المفضلة')),
//       );
//     } else {
//       await FavoriteService.addToFavorites(widget.product);
//       setState(() => isFavorite = true);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('تمت الإضافة إلى المفضلة')),
//       );
//     }
//                           },
//                           child: Image.asset(
//                             'assets/icons/love.png',
//                             height: 26,
//                             width: 26,
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: InkWell(
//                           onTap: () {
//                             final cartItem = CartItem(
//                               category: product.category,
//                               vendorId: product.vendorId,
//                               id: product.id,
//                               name: product.productName,
//                               image: product.images.first,
//                               price: product.productPrice,
//                             );

//                             ref.read(cartProvider.notifier).addToCart(cartItem);

//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('تمت الإضافة إلى السلة'),
//                                 duration: Duration(seconds: 2),
//                               ),
//                             );
//                           },
//                           child: Image.asset(
//                             'assets/icons/cart.png',
//                             height: 26,
//                             width: 26,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//   }
// }



// class PopularProductsScreen extends ConsumerStatefulWidget {
//   const PopularProductsScreen({super.key});

//   @override
//   ConsumerState<PopularProductsScreen> createState() =>
//       _PopularProductsScreenState();
// }

// class _PopularProductsScreenState extends ConsumerState<PopularProductsScreen> {
//   List<ProductModel> products = [];
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchPopularProducts();
//   }

//   void fetchPopularProducts() async {
//     if (!mounted) return;
//     setState(() => isLoading = true);
//     products = await ProductService().getPopularProducts(context);
//     if (!mounted) return;
//     setState(() => isLoading = false);
//   }

//   String fixUnsplashUrl(String url) {
//     final regex = RegExp(r'unsplash\.com/photos/([a-zA-Z0-9_-]+)');
//     final match = regex.firstMatch(url);
//     if (match != null) {
//       final photoId = match.group(1);
//       return 'https://source.unsplash.com/$photoId/400x400';
//     }
//     return url;
//   }

//   Uint8List base64ToImage(String base64String) {
//     return base64Decode(base64String);
//   }

//   Widget buildProductImage(String rawImageUrl) {
//     if (rawImageUrl.startsWith('http')) {
//       String fixedUrl = fixUnsplashUrl(rawImageUrl);
//       return Image.network(
//         fixedUrl,
//         width: 100,
//         height: 100,
//         fit: BoxFit.cover,
//         errorBuilder:
//             (context, error, stackTrace) =>
//                 const Icon(Icons.broken_image, size: 60),
//         loadingBuilder: (context, child, loadingProgress) {
//           if (loadingProgress == null) return child;
//           return const SizedBox(
//             height: 100,
//             width: 100,
//             child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
//           );
//         },
//       );
//     } else {
//       try {
//         final imageBytes = base64ToImage(rawImageUrl);
//         return Image.memory(
//           imageBytes,
//           width: 100,
//           height: 100,
//           fit: BoxFit.cover,
//         );
//       } catch (e) {
//         return const Icon(Icons.error, size: 60);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isLoading
//         ? const Center(child: CircularProgressIndicator())
//         : products.isEmpty
//         ? const Center(child: Text('لا يوجد منتجات شعبية حالياً'))
//         : SizedBox(
//           height: 230,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: products.length,
//             itemBuilder: (context, index) {
//               final product = products[index];
//               String rawImageUrl =
//                   product.images.isNotEmpty ? product.images.first : '';

//               return InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => ProductDetailsScreen(product: product),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   width: 150,
//                   margin: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.2),
//                         spreadRadius: 2,
//                         blurRadius: 6,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Stack(
//                     children: [
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child:
//                                 rawImageUrl.isNotEmpty
//                                     ? buildProductImage(rawImageUrl)
//                                     : const Icon(Icons.image, size: 100),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             product.productName,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           Text(
//                             '${product.productPrice} ج.م',
//                             style: const TextStyle(
//                               color: Colors.green,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Positioned(
//                         top: 15,
//                         right: 2,
//                         child: Image.asset(
//                           'assets/icons/love.png',
//                           height: 26,
//                           width: 26,
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: InkWell(
//                           onTap: () {
//                             final cartItem = CartItem(
//                               category: product.category,
//                               vendorId: product.vendorId,
//                               id: product.id,
//                               name: product.productName,
//                               image: product.images.first,
//                               price: product.productPrice,
//                             );

//                             ref.read(cartProvider.notifier).addToCart(cartItem);

//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('تمت الإضافة إلى السلة'),
//                                 duration: Duration(seconds: 2),
//                               ),
//                             );
//                           },
//                           child: Image.asset(
//                             'assets/icons/cart.png',
//                             height: 26,
//                             width: 26,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//   }
// }



