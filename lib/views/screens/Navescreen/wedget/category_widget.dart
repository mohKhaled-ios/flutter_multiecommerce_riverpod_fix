import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/category_controller.dart';
import 'package:multivendor_ecommerce_riverpod/models/category.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/wedget/reusable_text.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/details/category/inner_category.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  late Future<List<CategoryModel>> futureCategories;

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().fetchAllCategories(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ReusableText(title: 'Categories', subtitle: 'View all'),
          ),
          FutureBuilder(
            future: futureCategories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                );
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text("لا توجد أقسام");
              } else {
                final categories = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.8, // جرب حتى تظبط المساحة
                  ),
                  itemBuilder: (context, i) {
                    final category = categories[i];
                    // Uint8List imageBytes = base64Decode(category.image);
                    Uint8List? imageBytes;
                    try {
                      imageBytes = base64Decode(category.image);
                    } catch (e) {
                      imageBytes = null;
                    }
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return InnerCategoryScreen(category: category);
                            },
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          imageBytes != null
                              ? Image.memory(
                                imageBytes,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              )
                              : const Icon(Icons.image_not_supported),

                          // Image.memory(
                          //   imageBytes,
                          //   width: 40,
                          //   height: 40,
                          //   fit: BoxFit.cover,
                          // ),
                          const SizedBox(height: 4),
                          Text(
                            category.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}





// GridView.builder(
                //   padding: const EdgeInsets.all(8),
                //   physics: const NeverScrollableScrollPhysics(),
                //   shrinkWrap: true,
                //   itemCount: categories.length,
                //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 4,
                //     crossAxisSpacing: 8,
                //     mainAxisSpacing: 8,
                //   ),
                //   itemBuilder: (context, i) {
                //     final category = categories[i];
                //     Uint8List imageBytes = base64Decode(category.image);

                //     return InkWell(
                //       onTap: () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) {
                //               return InnerCategoryScreen(category: category);
                //             },
                //           ),
                //         );
                //       },
                //       child: Column(
                //         children: [
                //           Image.memory(
                //             imageBytes,
                //             width: 47,
                //             height: 47,
                //             fit: BoxFit.cover,
                //           ),
                //           const SizedBox(height: 4),
                //           // Text(
                //           //   category.name,
                //           //   style: const TextStyle(
                //           //     fontWeight: FontWeight.bold,
                //           //     fontSize: 16,
                //           //   ),
                //           //   textAlign: TextAlign.center,
                //           // ),
                //           Text(
                //             category.name,
                //             style: const TextStyle(
                //               fontWeight: FontWeight.w500,
                //               fontSize: 12,
                //             ),
                //             maxLines: 1,
                //             overflow: TextOverflow.ellipsis,
                //             textAlign: TextAlign.center,
                //           ),
                //         ],
                //       ),
                //     );
                //   },
                // );


  //////////////////////////
//
// Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ReusableText(title: 'Categories', subtitle: 'View all'),
//         ),
//         FutureBuilder(
//           future: futureCategories,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const CircularProgressIndicator(color: Colors.blue);
//             } else if (snapshot.hasError) {
//               return Text("Error: ${snapshot.error}");
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Text("لا توجد أقسام");
//             } else {
//               final categories = snapshot.data!;
//               return GridView.builder(
//                 physics: NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: categories.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   crossAxisSpacing: 8,
//                   mainAxisSpacing: 8,
//                 ),
//                 itemBuilder: (context, i) {
//                   final category = categories[i];
//                   Uint8List imageBytes = base64Decode(categories[i].image);

//                   return InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) {
//                             return InnerCategoryScreen(category: category);
//                           },
//                         ),
//                       );
//                     },
//                     child: Column(
//                       children: [
//                         Image.memory(
//                           imageBytes,
//                           width: 47,
//                           height: 47,
//                           fit: BoxFit.cover,
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           categories[i].name,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ],
//     );
//   }
// }
