import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/category_controller.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/sub_category_controller.dart';
import 'package:multivendor_ecommerce_riverpod/models/category.dart';
import 'package:multivendor_ecommerce_riverpod/models/subcategory.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/wedget/header_wedget.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/wedget/sub_category_title.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/subcategory_products_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<CategoryModel>> futureCategories;
  CategoryModel? _selectcategory;
  List<SubCategoryModel> _subcategory = [];
  final SubCategoryController _subCategoryController = SubCategoryController();

  // @override
  // void initState() {
  //   super.initState();
  //   futureCategories = CategoryController().fetchAllCategories(context);
  //   futureCategories.then(categories){

  //   for (var category in categories) {

  //     if (category.name=='Fashion') {
  //       setState(() {
  //         _selectcategory=category;
  //       });
  //       _loadsubcategory(category.name);

  //     }
  //   }
  //   }
  // }
  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().fetchAllCategories(context);
    futureCategories.then((categories) {
      for (var category in categories) {
        if (category.name == 'Fashion') {
          setState(() {
            _selectcategory = category;
          });
          _loadsubcategory(category.name);
        }
      }
    });
  }

  Future<void> _loadsubcategory(String categoryName) async {
    final subcategories = await _subCategoryController
        .getSubCategoriesByCategoryName(categoryName);
    setState(() {
      _subcategory = subcategories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 20),
        child: HeaderWedget(),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade200,
              child: FutureBuilder(
                future: futureCategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(color: Colors.blue);
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text("لا توجد أقسام");
                  } else {
                    final categories = snapshot.data!;
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: categories.length,

                      itemBuilder: (context, i) {
                        Uint8List imageBytes = base64Decode(
                          categories[i].image,
                        );
                        final category = categories[i];
                        return ListTile(
                          onTap: () {
                            setState(() {
                              _selectcategory = category;
                            });
                            _loadsubcategory(category.name);
                          },
                          title: Text(
                            categories[i].name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color:
                                  _selectcategory == category
                                      ? Colors.blue
                                      : Colors.black,
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child:
                _selectcategory != null
                    ? SingleChildScrollView(
                      child: Column(
                        children: [
                          //Uint8List
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _selectcategory!.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.7,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 150,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Image.memory(
                                base64Decode(_selectcategory!.banner),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          _subcategory.isNotEmpty
                              ? GridView.builder(
                                shrinkWrap: true,
                                itemCount: _subcategory.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 8,
                                      childAspectRatio: 2 / 3,
                                      mainAxisSpacing: 4,
                                    ),
                                itemBuilder: (context, i) {
                                  final subcategory = _subcategory[i];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => SubCategoryProductsScreen(
                                                subcategoryName:
                                                    subcategory.subCategoryName,
                                              ), // مثال
                                        ),
                                      );
                                    },
                                    child: SubCategoryTitleWidget(
                                      image:
                                          'http://192.168.1.3:5000${subcategory.image}',
                                      title: subcategory.subCategoryName,
                                    ),
                                  );
                                },
                              )
                              : Center(child: Text('no subcategory')),
                        ],
                      ),
                    )
                    : Container(),
          ),
        ],
      ),
    );
  }
}


// Column(
//                                     children: [
//                                       Container(
//                                         width: 50,
//                                         height: 50,
//                                         decoration: BoxDecoration(
//                                           color: Colors.grey.shade200,
//                                         ),
//                                         child: Center(
//                                           child: Image.network(
//                                             'http://192.168.1.3:5000${subcategory.image}',
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//                                       Center(
//                                         child: Text(
//                                           subcategory.subCategoryName,
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   );