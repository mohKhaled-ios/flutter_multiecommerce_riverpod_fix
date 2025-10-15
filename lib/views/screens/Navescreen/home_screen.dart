// import 'package:flutter/material.dart';

// import 'package:multivendor_ecommerce_riverbod/provider/top_rated_provider.dart';

// import 'package:multivendor_ecommerce_riverbod/views/screens/Navescreen/wedget/banner_widget.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/Navescreen/wedget/category_widget.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/Navescreen/wedget/header_wedget.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/Navescreen/wedget/popular_product.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/Navescreen/wedget/reusabletextwedget.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/Navescreen/wedget/top_ralated.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//  @override
// void initState() {
//   super.initState();
//   Future.microtask(() =>
//       ref.read(topRatedProvider.notifier).fetchTopRated(context));
// }
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             HeaderWedget(),
//             BannerWidget(),
//             CategoryWidget(),
//             ReusableDoubleTextRow(
//               firstText: 'Popular Product',
//               secondText: 'VIEW ALL',
//             ),
//             PopularProductsScreen(),

//             TopRatedWidget(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:multivendor_ecommerce_riverbod/provider/top_rated_provider.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/Navescreen/wedget/banner_widget.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/Navescreen/wedget/category_widget.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/Navescreen/wedget/header_wedget.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/Navescreen/wedget/popular_product.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/Navescreen/wedget/reusabletextwedget.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/Navescreen/wedget/top_ralated.dart';

// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(
//       () => ref.read(topRatedProvider.notifier).fetchTopRated(context),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             HeaderWedget(),
//             BannerWidget(),
//             CategoryWidget(),
//             ReusableDoubleTextRow(
//               firstText: 'Popular Product',
//               secondText: 'VIEW ALL',
//             ),
//             PopularProductsScreen(),
//             TopRatedWidget(),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multivendor_ecommerce_riverpod/provider/top_rated_provider.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/wedget/banner_widget.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/wedget/category_widget.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/wedget/header_wedget.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/wedget/popular_product.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/wedget/reusabletextwedget.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/wedget/top_ralated.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(topRatedProvider.notifier).fetchTopRatedProducts(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.20,
        ),
        child: HeaderWedget(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              BannerWidget(),
              CategoryWidget(),
              ReusableDoubleTextRow(
                firstText: 'Popular Product',
                secondText: 'VIEW ALL',
              ),
              PopularProductsScreen(),
              TopRatedWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
