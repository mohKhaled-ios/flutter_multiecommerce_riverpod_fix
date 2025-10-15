// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:multivendor_ecommerce_riverbod/models/product.dart';
// import 'package:multivendor_ecommerce_riverbod/provider/subcategory_product_provider.dart';

// enum SortOption { newest, priceLowHigh, priceHighLow, nameAZ, nameZA }

// class SubCategoryProductsScreen extends ConsumerStatefulWidget {
//   final String subcategoryName;
//   const SubCategoryProductsScreen({super.key, required this.subcategoryName});

//   @override
//   ConsumerState<SubCategoryProductsScreen> createState() =>
//       _SubCategoryProductsScreenState();
// }

// class _SubCategoryProductsScreenState
//     extends ConsumerState<SubCategoryProductsScreen> {
//   SortOption _sort = SortOption.newest;
//   RangeValues? _priceRange;
//   String _keyword = '';

//   @override
//   Widget build(BuildContext context) {
//     final asyncProducts = ref.watch(
//       subcategoryProductsProvider(widget.subcategoryName),
//     );

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.subcategoryName),
//         centerTitle: true,
//         elevation: 0.5,
//         actions: [
//           IconButton(
//             tooltip: 'بحث',
//             icon: const Icon(Icons.search),
//             onPressed: () async {
//               final text = await showSearch<String?>(
//                 context: context,
//                 delegate: _ProductSearchDelegate(initial: _keyword),
//               );
//               if (text != null) {
//                 setState(() => _keyword = text.trim());
//               }
//             },
//           ),
//           IconButton(
//             tooltip: 'فلترة',
//             icon: const Icon(Icons.filter_list),
//             onPressed: () => _openFilterSheet(context, asyncProducts),
//           ),
//           IconButton(
//             tooltip: 'ترتيب',
//             icon: const Icon(Icons.sort),
//             onPressed: _openSortSheet,
//           ),
//         ],
//       ),
//       body: asyncProducts.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (e, _) => Center(child: Text('حدث خطأ: $e')),
//         data: (products) {
//           final List<ProductModel> source = List<ProductModel>.from(products);

//           if (source.isNotEmpty && _priceRange == null) {
//             final minPrice = source
//                 .map((p) => p.productPrice)
//                 .reduce((a, b) => a < b ? a : b);
//             final maxPrice = source
//                 .map((p) => p.productPrice)
//                 .reduce((a, b) => a > b ? a : b);
//             _priceRange = RangeValues(minPrice, maxPrice);
//           }

//           var filtered =
//               source.where((p) {
//                 final k = _keyword.toLowerCase();
//                 if (k.isEmpty) return true;
//                 return p.productName.toLowerCase().contains(k) ||
//                     p.description.toLowerCase().contains(k);
//               }).toList();

//           if (_priceRange != null) {
//             filtered =
//                 filtered
//                     .where(
//                       (p) =>
//                           p.productPrice >= _priceRange!.start &&
//                           p.productPrice <= _priceRange!.end,
//                     )
//                     .toList();
//           }

//           filtered.sort((a, b) {
//             switch (_sort) {
//               case SortOption.newest:
//                 final dateA = a.createdAt ?? DateTime(2000);
//                 final dateB = b.createdAt ?? DateTime(2000);
//                 return dateB.compareTo(dateA);
//               case SortOption.priceLowHigh:
//                 return a.productPrice.compareTo(b.productPrice);
//               case SortOption.priceHighLow:
//                 return b.productPrice.compareTo(a.productPrice);
//               case SortOption.nameAZ:
//                 return a.productName.toLowerCase().compareTo(
//                   b.productName.toLowerCase(),
//                 );
//               case SortOption.nameZA:
//                 return b.productName.toLowerCase().compareTo(
//                   a.productName.toLowerCase(),
//                 );
//             }
//           });

//           if (filtered.isEmpty) {
//             return const Center(child: Text('لا توجد منتجات مطابقة'));
//           }

//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: GridView.builder(
//               itemCount: filtered.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//                 childAspectRatio: 0.66,
//               ),
//               itemBuilder: (context, i) => _ProductCard(product: filtered[i]),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _openSortSheet() {
//     showModalBottomSheet(
//       context: context,
//       showDragHandle: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
//       ),
//       builder: (context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               for (var option in SortOption.values)
//                 RadioListTile<SortOption>(
//                   title: Text(_getSortText(option)),
//                   value: option,
//                   groupValue: _sort,
//                   onChanged:
//                       (v) => setState(() {
//                         _sort = v!;
//                         Navigator.pop(context);
//                       }),
//                 ),
//               const SizedBox(height: 10),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   String _getSortText(SortOption option) {
//     switch (option) {
//       case SortOption.newest:
//         return 'الأحدث';
//       case SortOption.priceLowHigh:
//         return 'السعر: من الأقل للأعلى';
//       case SortOption.priceHighLow:
//         return 'السعر: من الأعلى للأقل';
//       case SortOption.nameAZ:
//         return 'الاسم: A → Z';
//       case SortOption.nameZA:
//         return 'الاسم: Z → A';
//     }
//   }

//   void _openFilterSheet(
//     BuildContext context,
//     AsyncValue<List<ProductModel>> asyncProducts,
//   ) {
//     // TODO: إضافة منطق فلترة متقدم لاحقاً
//   }
// }

// class _ProductCard extends StatelessWidget {
//   final ProductModel product;
//   const _ProductCard({required this.product});

//   bool _isBase64(String str) {
//     final base64RegExp = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
//     return str.isNotEmpty && base64RegExp.hasMatch(str.replaceAll('\n', ''));
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget imageWidget;
//     if (product.images.isNotEmpty) {
//       final img = product.images.first;
//       if (_isBase64(img)) {
//         try {
//           Uint8List imageBytes = base64Decode(img);
//           imageWidget = Image.memory(
//             imageBytes,
//             fit: BoxFit.cover,
//             errorBuilder:
//                 (_, __, ___) => const Icon(Icons.broken_image, size: 80),
//           );
//         } catch (e) {
//           imageWidget = const Icon(Icons.broken_image, size: 80);
//         }
//       } else {
//         imageWidget = Image.network(
//           img,
//           fit: BoxFit.cover,
//           errorBuilder:
//               (_, __, ___) => const Icon(Icons.broken_image, size: 80),
//         );
//       }
//     } else {
//       imageWidget = const Icon(Icons.image, size: 80);
//     }

//     return Card(
//       elevation: 2,
//       child: Column(
//         children: [
//           Expanded(child: imageWidget),
//           Text(
//             product.productName,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           Text(
//             '${product.productPrice} ج.م',
//             style: const TextStyle(color: Colors.green),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ProductSearchDelegate extends SearchDelegate<String?> {
//   final String initial;
//   _ProductSearchDelegate({this.initial = ''}) {
//     query = initial;
//   }

//   @override
//   List<Widget>? buildActions(BuildContext context) => [
//     IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
//   ];

//   @override
//   Widget? buildLeading(BuildContext context) => IconButton(
//     icon: const Icon(Icons.arrow_back),
//     onPressed: () => close(context, null),
//   );

//   @override
//   Widget buildResults(BuildContext context) =>
//       Center(child: Text('نتيجة البحث: $query'));

//   @override
//   Widget buildSuggestions(BuildContext context) => Container();
// }
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multivendor_ecommerce_riverpod/models/product.dart';
import 'package:multivendor_ecommerce_riverpod/provider/subcategory_product_provider.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/wedget/productdetails_screen.dart';

enum SortOption { newest, priceLowHigh, priceHighLow, nameAZ, nameZA }

class SubCategoryProductsScreen extends ConsumerStatefulWidget {
  final String subcategoryName;
  const SubCategoryProductsScreen({super.key, required this.subcategoryName});

  @override
  ConsumerState<SubCategoryProductsScreen> createState() =>
      _SubCategoryProductsScreenState();
}

class _SubCategoryProductsScreenState
    extends ConsumerState<SubCategoryProductsScreen> {
  SortOption _sort = SortOption.newest;
  RangeValues? _priceRange;
  String _keyword = '';

  @override
  Widget build(BuildContext context) {
    final asyncProducts = ref.watch(
      subcategoryProductsProvider(widget.subcategoryName),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subcategoryName),
        centerTitle: true,
        elevation: 0.5,
        actions: [
          IconButton(
            tooltip: 'بحث',
            icon: const Icon(Icons.search),
            onPressed: () async {
              final text = await showSearch<String?>(
                context: context,
                delegate: _ProductSearchDelegate(initial: _keyword),
              );
              if (text != null) {
                setState(() => _keyword = text.trim());
              }
            },
          ),
          IconButton(
            tooltip: 'فلترة',
            icon: const Icon(Icons.filter_list),
            onPressed: () => _openFilterSheet(context, asyncProducts),
          ),
          IconButton(
            tooltip: 'ترتيب',
            icon: const Icon(Icons.sort),
            onPressed: _openSortSheet,
          ),
        ],
      ),
      body: asyncProducts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('حدث خطأ: $e')),
        data: (products) {
          final List<ProductModel> source = List<ProductModel>.from(products);

          if (source.isNotEmpty && _priceRange == null) {
            final minPrice = source
                .map((p) => p.productPrice)
                .reduce((a, b) => a < b ? a : b);
            final maxPrice = source
                .map((p) => p.productPrice)
                .reduce((a, b) => a > b ? a : b);
            _priceRange = RangeValues(minPrice, maxPrice);
          }

          var filtered =
              source.where((p) {
                final k = _keyword.toLowerCase();
                if (k.isEmpty) return true;
                return p.productName.toLowerCase().contains(k) ||
                    p.description.toLowerCase().contains(k);
              }).toList();

          if (_priceRange != null) {
            filtered =
                filtered
                    .where(
                      (p) =>
                          p.productPrice >= _priceRange!.start &&
                          p.productPrice <= _priceRange!.end,
                    )
                    .toList();
          }

          filtered.sort((a, b) {
            switch (_sort) {
              case SortOption.newest:
                final dateA = a.createdAt ?? DateTime(2000);
                final dateB = b.createdAt ?? DateTime(2000);
                return dateB.compareTo(dateA);
              case SortOption.priceLowHigh:
                return a.productPrice.compareTo(b.productPrice);
              case SortOption.priceHighLow:
                return b.productPrice.compareTo(a.productPrice);
              case SortOption.nameAZ:
                return a.productName.toLowerCase().compareTo(
                  b.productName.toLowerCase(),
                );
              case SortOption.nameZA:
                return b.productName.toLowerCase().compareTo(
                  a.productName.toLowerCase(),
                );
            }
          });

          if (filtered.isEmpty) {
            return const Center(child: Text('لا توجد منتجات مطابقة'));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: filtered.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.66,
              ),
              itemBuilder: (context, i) => _ProductCard(product: filtered[i]),
            ),
          );
        },
      ),
    );
  }

  void _openSortSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var option in SortOption.values)
                RadioListTile<SortOption>(
                  title: Text(_getSortText(option)),
                  value: option,
                  groupValue: _sort,
                  onChanged:
                      (v) => setState(() {
                        _sort = v!;
                        Navigator.pop(context);
                      }),
                ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  String _getSortText(SortOption option) {
    switch (option) {
      case SortOption.newest:
        return 'الأحدث';
      case SortOption.priceLowHigh:
        return 'السعر: من الأقل للأعلى';
      case SortOption.priceHighLow:
        return 'السعر: من الأعلى للأقل';
      case SortOption.nameAZ:
        return 'الاسم: A → Z';
      case SortOption.nameZA:
        return 'الاسم: Z → A';
    }
  }

  void _openFilterSheet(
    BuildContext context,
    AsyncValue<List<ProductModel>> asyncProducts,
  ) {
    // TODO: إضافة منطق فلترة متقدم لاحقاً
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  const _ProductCard({required this.product});

  bool _isBase64(String str) {
    final base64RegExp = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
    return str.isNotEmpty && base64RegExp.hasMatch(str.replaceAll('\n', ''));
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (product.images.isNotEmpty) {
      final img = product.images.first;
      if (_isBase64(img)) {
        try {
          Uint8List imageBytes = base64Decode(img);
          imageWidget = Image.memory(
            imageBytes,
            fit: BoxFit.cover,
            errorBuilder:
                (_, __, ___) => const Icon(Icons.broken_image, size: 80),
          );
        } catch (e) {
          imageWidget = const Icon(Icons.broken_image, size: 80);
        }
      } else {
        imageWidget = Image.network(
          img,
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) => const Icon(Icons.broken_image, size: 80),
        );
      }
    } else {
      imageWidget = const Icon(Icons.image, size: 80);
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Card(
        elevation: 2,
        child: Column(
          children: [
            Expanded(child: imageWidget),
            Text(
              product.productName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${product.productPrice} ج.م',
              style: const TextStyle(color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductSearchDelegate extends SearchDelegate<String?> {
  final String initial;
  _ProductSearchDelegate({this.initial = ''}) {
    query = initial;
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) =>
      Center(child: Text('نتيجة البحث: $query'));

  @override
  Widget buildSuggestions(BuildContext context) => Container();
}
