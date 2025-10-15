// import 'package:flutter/material.dart';
// import 'package:multivendor_ecommerce_riverbod/controllers/sub_category_controller.dart';
// import 'package:multivendor_ecommerce_riverbod/models/category.dart';
// import 'package:multivendor_ecommerce_riverbod/models/subcategory.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/Navescreen/Account_screen.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/Navescreen/cart_screen.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/Navescreen/favourete_screen.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/Navescreen/stores_screen.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/Navescreen/wedget/category_screen.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/Navescreen/wedget/header_wedget.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/Navescreen/wedget/inner_category_content.dart';

// class InnerCategoryScreen extends StatefulWidget {
//   final CategoryModel category;
//   const InnerCategoryScreen({super.key, required this.category});

//   @override
//   State<InnerCategoryScreen> createState() => _InnerCategoryScreenState();
// }

// class _InnerCategoryScreenState extends State<InnerCategoryScreen> {
//   final SubCategoryController _subCategoryController = SubCategoryController();
//   late Future<List<SubCategoryModel>> _subcategory;

//   @override
//   void initState() {
//     super.initState();
//     _subcategory = _subCategoryController.getSubCategoriesByCategoryName(
//       widget.category.name,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     int _pageIndex = 0;

//     final List<Widget> _screens = [
//       InnerCategoryContentWedget(category: widget.category),
//       FavoureteScreen(),
//       CategoryScreen(),
//       StoresScreen(),
//       CartScreen(),
//       AccountScreen(),
//     ];

//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 20),
//         child: HeaderWedget(),
//       ),
//       body: _screens[_pageIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _pageIndex,
//         onTap: (value) {
//           setState(() {
//             _pageIndex = value;
//           });
//         },
//         selectedItemColor: Colors.purple,
//         unselectedItemColor: Colors.grey,
//         items: [
//           BottomNavigationBarItem(
//             icon: Image.asset('assets/icons/home.png', width: 25),
//             label: 'innercategory',
//           ),
//           BottomNavigationBarItem(
//             icon: Image.asset('assets/icons/love.png', width: 25),
//             label: 'Favourite  ',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.category),
//             label: 'Categories  ',
//           ),

//           BottomNavigationBarItem(
//             icon: Image.asset('assets/icons/mart.png', width: 25),
//             label: 'Stores',
//           ),
//           BottomNavigationBarItem(
//             icon: Image.asset('assets/icons/cart.png', width: 25),
//             label: 'Cart',
//           ),
//           BottomNavigationBarItem(
//             icon: Image.asset('assets/icons/user.png', width: 25),
//             label: 'Account',
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/sub_category_controller.dart';
import 'package:multivendor_ecommerce_riverpod/models/category.dart';
import 'package:multivendor_ecommerce_riverpod/models/subcategory.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/Account_screen.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/cart_screen.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/favourete_screen.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/stores_screen.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/wedget/category_screen.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/wedget/inner_category_content.dart';

class InnerCategoryScreen extends StatefulWidget {
  final CategoryModel category;
  const InnerCategoryScreen({super.key, required this.category});

  @override
  State<InnerCategoryScreen> createState() => _InnerCategoryScreenState();
}

class _InnerCategoryScreenState extends State<InnerCategoryScreen> {
  final SubCategoryController _subCategoryController = SubCategoryController();
  late Future<List<SubCategoryModel>> _subcategory;

  // ✅ هنا الحل: نعرفه في الكلاس مش داخل build
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _subcategory = _subCategoryController.getSubCategoriesByCategoryName(
      widget.category.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      InnerCategoryContentWedget(category: widget.category),
      FavoriteProductsScreen(),
      CategoryScreen(),
      StoresScreen(),
      CartScreen(),
      AccountScreen(),
    ];

    return Scaffold(
      body: screens[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/home.png', width: 25),
            label: 'innercategory',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/love.png', width: 25),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/mart.png', width: 25),
            label: 'Stores',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/cart.png', width: 25),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/user.png', width: 25),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
