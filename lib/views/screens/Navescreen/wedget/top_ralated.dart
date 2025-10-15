// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:multivendor_ecommerce_riverbod/models/product.dart';
// import 'package:multivendor_ecommerce_riverbod/provider/top_rated_provider.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/Navescreen/wedget/productdetails_screen.dart';

// class TopRatedWidget extends ConsumerWidget {
//   const TopRatedWidget({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final topRated = ref.watch(topRatedProvider);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "الأعلى تقييماً ⭐",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 12),
//         topRated.isEmpty
//             ? const Center(child: CircularProgressIndicator())
//             : SizedBox(
//               height: 220,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: topRated.length,
//                 itemBuilder: (context, index) {
//                   final product = topRated[index];
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder:
//                               (_) => ProductDetailsScreen(product: product),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       width: 160,
//                       margin: const EdgeInsets.only(right: 12),
//                       child: Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: ClipRRect(
//                                 borderRadius: const BorderRadius.vertical(
//                                   top: Radius.circular(12),
//                                 ),
//                                 child: Image.network(
//                                   product.images.isNotEmpty
//                                       ? product.images.first
//                                       : "",
//                                   fit: BoxFit.cover,
//                                   width: double.infinity,
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     product.productName,
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     "${product.productPrice} ج.م",
//                                     style: const TextStyle(
//                                       color: Colors.green,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//       ],
//     );
//   }
// }
// widgets/top_rated_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multivendor_ecommerce_riverpod/models/product.dart';
import 'package:multivendor_ecommerce_riverpod/provider/top_rated_provider.dart';
import 'package:multivendor_ecommerce_riverpod/top_rated_state.dart';

class TopRatedWidget extends ConsumerStatefulWidget {
  const TopRatedWidget({super.key});

  @override
  ConsumerState<TopRatedWidget> createState() => _TopRatedWidgetState();
}

class _TopRatedWidgetState extends ConsumerState<TopRatedWidget> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(topRatedProvider.notifier).fetchTopRatedProducts(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(topRatedProvider);

    if (state is TopRatedLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is TopRatedError) {
      return Center(child: Text(state.message));
    } else if (state is TopRatedLoaded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Top Rated Products",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                ProductModel product = state.products[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: SizedBox(
                    width: 140,
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            product.images.isNotEmpty
                                ? product.images[0]
                                : "https://via.placeholder.com/150",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          product.productName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("\$${product.productPrice}"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
