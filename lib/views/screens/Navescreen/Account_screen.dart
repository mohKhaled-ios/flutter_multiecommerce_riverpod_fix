import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/authcontroller.dart';
import 'package:multivendor_ecommerce_riverpod/provider/cart_provider.dart';

import 'package:multivendor_ecommerce_riverpod/provider/delivered_order_provider.dart';
import 'package:multivendor_ecommerce_riverpod/provider/user_provider.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/orderscreen.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/shipping_address.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final cartData = ref.watch(cartProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 450,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.network(
                      "https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/FBrbGWQJqIbpA5ZHEpajYAEh1V93%2Fuploads%2Fimages%2F78dbff80_1dfe_1db2_8fe9_13f5839e17c1_bg2.png?alt=media",
                      width: MediaQuery.of(context).size.width,
                      height: 451,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: 30,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Image.asset('assets/icons/not.png', width: 20),
                    ),
                  ),
                  Stack(
                    children: [
                      const Align(
                        alignment: Alignment(0, -0.53),
                        child: CircleAvatar(
                          radius: 65,
                          backgroundImage: NetworkImage(
                            "https://cdn.pixabay.com/photo/2014/04/03/10/32/businessman-310819_1280.png",
                          ),
                        ),
                      ),
                      Align(
                        alignment: const Alignment(0.23, -0.61),
                        child: InkWell(
                          onTap: () {},
                          child: Image.asset(
                            'assets/icons/edit.png',
                            width: 19,
                            height: 19,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: const Alignment(0, 0.03),
                    child:
                        (user != null && user.fullname.isNotEmpty)
                            ? Text(
                              user.fullname,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                            : Text(
                              'User',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                  Align(
                    alignment: const Alignment(0.05, 0.17),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const ShippingAddressDesignPage();
                            },
                          ),
                        );
                      },
                      child:
                          (user != null && user.state.isNotEmpty)
                              ? Text(
                                user.state,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                              : Text(
                                'States',
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0.09, 0.81),
                    child: SizedBox(
                      width: 287,
                      height: 117,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // ✅ عدد الطلبات المكتملة (delivered)
                          Positioned(
                            left: 240,
                            top: 66,
                            child: Consumer(
                              builder: (context, ref, _) {
                                if (user != null && user.id.isNotEmpty) {
                                  final deliveredCountAsync = ref.watch(
                                    deliveredOrderCountProvider(user.id),
                                  );

                                  return deliveredCountAsync.when(
                                    data:
                                        (count) => Text(
                                          count.toString(),
                                          style: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontSize: 22,
                                            letterSpacing: 0.4,
                                          ),
                                        ),
                                    loading:
                                        () => const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        ),
                                    error:
                                        (err, _) => Text(
                                          "0",
                                          style: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontSize: 22,
                                          ),
                                        ),
                                  );
                                } else {
                                  return Text(
                                    "0",
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 22,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          Positioned(
                            left: 212,
                            top: 99,
                            child: Text(
                              "Completed",
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 224,
                            top: 2,
                            child: Container(
                              width: 52,
                              height: 58,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    "https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Ff0db1e22e37c1e2a001bbb5bd4b9aafc.png",
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 13,
                                    top: 18,
                                    child: Image.network(
                                      width: 26,
                                      height: 26,
                                      'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F4ad2eb1752466c61c6bb41a0e223251a906a1a7bcorrect%201.png?alt=media&token=57abd4a6-50b4-4609-bb59-b48dce4c8cc6',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 108,
                            top: 99,
                            child: Text(
                              'Favorite',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 114,
                            top: 2,
                            child: Container(
                              width: 52,
                              height: 58,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: NetworkImage(
                                    "https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Ff0db1e22e37c1e2a001bbb5bd4b9aafc.png",
                                  ),
                                ),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 15,
                                    top: 18,
                                    child: Image.network(
                                      width: 26,
                                      height: 26,
                                      "https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F068bdad59a9aff5a9ee67737678b8d5438866afewish-list%201.png?alt=media&token=4a8abc27-022f-4a53-8f07-8c10791468e4",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            top: 66,
                            child: Text(
                              cartData.length.toString(),
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 22,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 13,
                            top: 99,
                            child: Text(
                              'Cart',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 5,
                            top: 0,
                            child: Container(
                              width: 56,
                              height: 63,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: NetworkImage(
                                    'https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Fe0080f58f1ec1f2200fcf329b10ce4c4.png',
                                  ),
                                ),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 12,
                                    top: 15,
                                    child: Image.network(
                                      width: 33,
                                      height: 33,
                                      'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Fc2afb7fb33cd20f4f1aed312669aa43b8bb2d431cart%20(2)%201.png?alt=media&token=be3d8494-1ccd-4925-91f1-ee30402dfb0e',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const OrdersScreen();
                    },
                  ),
                );
              },
              leading: Image.asset('assets/icons/orders.png'),
              title: Text(
                'Track your order',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const OrdersScreen();
                    },
                  ),
                );
              },
              leading: Image.asset('assets/icons/history.png'),
              title: Text(
                'History',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              onTap: () {},
              leading: Image.asset('assets/icons/help.png'),
              title: Text(
                'Help',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              onTap: () {
                Authcontroller().signoutuser(context: context, ref: ref);
              },
              leading: Image.asset('assets/icons/logout.png'),
              title: Text(
                'Logout',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 /////////////////////////////////
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:multivendor_ecommerce_riverbod/provider/cart_provider.dart';
// import 'package:multivendor_ecommerce_riverbod/provider/delivered_order_provider.dart';
// import 'package:multivendor_ecommerce_riverbod/provider/user_provider.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/orderscreen.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/shipping_address.dart';

// class AccountScreen extends ConsumerStatefulWidget {
//   const AccountScreen({Key? key}) : super(key: key);

//   @override
//   _AccountScreenState createState() => _AccountScreenState();
// }

// class _AccountScreenState extends ConsumerState<AccountScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final user = ref.watch(userProvider);
//     final cartData = ref.watch(cartProvider);
//     // final favoriteCount = ref.watch(favoriteProvider);

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: 450,
//               clipBehavior: Clip.antiAlias,
//               decoration: const BoxDecoration(),
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   Align(
//                     alignment: Alignment.center,
//                     child: Image.network(
//                       "https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/FBrbGWQJqIbpA5ZHEpajYAEh1V93%2Fuploads%2Fimages%2F78dbff80_1dfe_1db2_8fe9_13f5839e17c1_bg2.png?alt=media",
//                       width: MediaQuery.of(context).size.width,
//                       height: 451,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Positioned(
//                     top: 30,
//                     right: 30,
//                     child: Align(
//                       alignment: Alignment.topRight,
//                       child: Image.asset('assets/icons/not.png', width: 20),
//                     ),
//                   ),
//                   Stack(
//                     children: [
//                       const Align(
//                         alignment: Alignment(0, -0.53),
//                         child: CircleAvatar(
//                           radius: 65,
//                           backgroundImage: NetworkImage(
//                             "https://cdn.pixabay.com/photo/2014/04/03/10/32/businessman-310819_1280.png",
//                           ),
//                         ),
//                       ),
//                       Align(
//                         alignment: const Alignment(0.23, -0.61),
//                         child: InkWell(
//                           onTap: () {},
//                           child: Image.asset(
//                             'assets/icons/edit.png',
//                             width: 19,
//                             height: 19,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Align(
//                     alignment: const Alignment(0, 0.03),
//                     child:
//                         (user != null && user.fullname.isNotEmpty)
//                             ? Text(
//                               user.fullname,
//                               style: GoogleFonts.montserrat(
//                                 color: Colors.white,
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             )
//                             : Text(
//                               'User',
//                               style: GoogleFonts.montserrat(
//                                 color: Colors.white,
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                   ),
//                   Align(
//                     alignment: const Alignment(0.05, 0.17),
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) {
//                               return const ShippingAddressDesignPage();
//                             },
//                           ),
//                         );
//                       },
//                       child:
//                           (user != null && user.state.isNotEmpty)
//                               ? Text(
//                                 user.state,
//                                 style: GoogleFonts.montserrat(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               )
//                               : Text(
//                                 'States',
//                                 style: GoogleFonts.montserrat(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                     ),
//                   ),
//                   Align(
//                     alignment: const Alignment(0.09, 0.81),
//                     child: SizedBox(
//                       width: 287,
//                       height: 117,
//                       child: Stack(
//                         clipBehavior: Clip.none,
//                         children: [
//                           Positioned(
//                             left: 240,
//                             top: 66,
//                             child: Consumer(
//                               builder: (context, ref, _) {
//                                 // final deliveredCountAsync = ref.watch(
//                                 //   deliveredOrderCountProvider("buyerId_123"),
//                                 ); // حط الـ buyerId

//                                 return deliveredCountAsync.when(
//                                   data:
//                                       (count) =>
//                                           Text("عدد الطلبات المستلمة: $count"),
//                                   loading:
//                                       () => const CircularProgressIndicator(),
//                                   error: (err, _) => Text("خطأ: $err"),
//                                 );
//                               },
//                             ),

//                             // Text(
//                             //   "15",
//                             //   style: GoogleFonts.roboto(
//                             //     color: Colors.white,
//                             //     fontSize: 22,
//                             //     letterSpacing: 0.4,
//                             //   ),
//                             // ),
//                           ),
//                           Positioned(
//                             left: 212,
//                             top: 99,
//                             child: Text(
//                               "Completed",
//                               style: GoogleFonts.quicksand(
//                                 fontSize: 14,
//                                 color: Colors.white,
//                                 letterSpacing: 0.3,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 224,
//                             top: 2,
//                             child: Container(
//                               width: 52,
//                               height: 58,
//                               clipBehavior: Clip.antiAlias,
//                               decoration: const BoxDecoration(
//                                 image: DecorationImage(
//                                   image: NetworkImage(
//                                     "https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Ff0db1e22e37c1e2a001bbb5bd4b9aafc.png",
//                                   ),
//                                   fit: BoxFit.contain,
//                                 ),
//                               ),
//                               child: Stack(
//                                 clipBehavior: Clip.none,
//                                 children: [
//                                   Positioned(
//                                     left: 13,
//                                     top: 18,
//                                     child: Image.network(
//                                       width: 26,
//                                       height: 26,
//                                       'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F4ad2eb1752466c61c6bb41a0e223251a906a1a7bcorrect%201.png?alt=media&token=57abd4a6-50b4-4609-bb59-b48dce4c8cc6',
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 108,
//                             top: 99,
//                             child: Text(
//                               'Favorite',
//                               style: GoogleFonts.montserrat(
//                                 color: Colors.white,
//                                 letterSpacing: 0.3,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 114,
//                             top: 2,
//                             child: Container(
//                               width: 52,
//                               height: 58,
//                               clipBehavior: Clip.antiAlias,
//                               decoration: const BoxDecoration(
//                                 image: DecorationImage(
//                                   fit: BoxFit.contain,
//                                   image: NetworkImage(
//                                     "https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Ff0db1e22e37c1e2a001bbb5bd4b9aafc.png",
//                                   ),
//                                 ),
//                               ),
//                               child: Stack(
//                                 clipBehavior: Clip.none,
//                                 children: [
//                                   Positioned(
//                                     left: 15,
//                                     top: 18,
//                                     child: Image.network(
//                                       width: 26,
//                                       height: 26,
//                                       "https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F068bdad59a9aff5a9ee67737678b8d5438866afewish-list%201.png?alt=media&token=4a8abc27-022f-4a53-8f07-8c10791468e4",
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 20,
//                             top: 66,
//                             child: Text(
//                               cartData.length.toString(),
//                               style: GoogleFonts.montserrat(
//                                 color: Colors.white,
//                                 fontSize: 22,
//                                 letterSpacing: 0.4,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 13,
//                             top: 99,
//                             child: Text(
//                               'Cart',
//                               style: GoogleFonts.montserrat(
//                                 fontSize: 14,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 letterSpacing: 0.4,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 5,
//                             top: 0,
//                             child: Container(
//                               width: 56,
//                               height: 63,
//                               clipBehavior: Clip.antiAlias,
//                               decoration: const BoxDecoration(
//                                 image: DecorationImage(
//                                   fit: BoxFit.contain,
//                                   image: NetworkImage(
//                                     'https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Fe0080f58f1ec1f2200fcf329b10ce4c4.png',
//                                   ),
//                                 ),
//                               ),
//                               child: Stack(
//                                 clipBehavior: Clip.none,
//                                 children: [
//                                   Positioned(
//                                     left: 12,
//                                     top: 15,
//                                     child: Image.network(
//                                       width: 33,
//                                       height: 33,
//                                       'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Fc2afb7fb33cd20f4f1aed312669aa43b8bb2d431cart%20(2)%201.png?alt=media&token=be3d8494-1ccd-4925-91f1-ee30402dfb0e',
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             ListTile(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) {
//                       return const OrdersScreen();
//                     },
//                   ),
//                 );
//               },
//               leading: Image.asset('assets/icons/orders.png'),
//               title: Text(
//                 'Track your order',
//                 style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 10),
//             ListTile(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) {
//                       return const OrdersScreen();
//                     },
//                   ),
//                 );
//               },
//               leading: Image.asset('assets/icons/history.png'),
//               title: Text(
//                 'History',
//                 style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 10),
//             ListTile(
//               onTap: () {},
//               leading: Image.asset('assets/icons/help.png'),
//               title: Text(
//                 'Help',
//                 style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 10),
//             ListTile(
//               onTap: () {},
//               leading: Image.asset('assets/icons/logout.png'),
//               title: Text(
//                 'Logout',
//                 style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:multivendor_ecommerce_riverbod/provider/cart_provider.dart';
// import 'package:multivendor_ecommerce_riverbod/provider/user_provider.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/orderscreen.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/shipping_address.dart';

// class AccountScreen extends ConsumerStatefulWidget {
//   const AccountScreen({Key? key}) : super(key: key);

//   @override
//   _AccountScreenState createState() => _AccountScreenState();
// }

// class _AccountScreenState extends ConsumerState<AccountScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final user = ref.read(userProvider);
//     final cartData = ref.read(cartProvider);
//     // final favoriteCount = ref.read(favoriteProvider);
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: 450,
//               clipBehavior: Clip.antiAlias,
//               decoration: const BoxDecoration(),
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   Align(
//                     alignment: Alignment.center,
//                     child: Image.network(
//                       "https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/FBrbGWQJqIbpA5ZHEpajYAEh1V93%2Fuploads%2Fimages%2F78dbff80_1dfe_1db2_8fe9_13f5839e17c1_bg2.png?alt=media",
//                       width: MediaQuery.of(context).size.width,
//                       height: 451,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Positioned(
//                     top: 30,
//                     right: 30,
//                     child: Align(
//                       alignment: Alignment.topRight,
//                       child: Image.asset('assets/icons/not.png', width: 20),
//                     ),
//                   ),
//                   Stack(
//                     children: [
//                       const Align(
//                         alignment: Alignment(0, -0.53),
//                         child: CircleAvatar(
//                           radius: 65,
//                           backgroundImage: NetworkImage(
//                             "https://cdn.pixabay.com/photo/2014/04/03/10/32/businessman-310819_1280.png",
//                           ),
//                         ),
//                       ),
//                       Align(
//                         alignment: const Alignment(0.23, -0.61),
//                         child: InkWell(
//                           onTap: () {},
//                           child: Image.asset(
//                             'assets/icons/edit.png',
//                             width: 19,
//                             height: 19,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Align(
//                     alignment: const Alignment(0, 0.03),
//                     child:
//                         user?.fullname != ""
//                             ? Text(
//                               user!.fullname,
//                               style: GoogleFonts.montserrat(
//                                 color: Colors.white,
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             )
//                             : Text(
//                               'User',
//                               style: GoogleFonts.montserrat(
//                                 color: Colors.white,
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                   ),
//                   Align(
//                     alignment: const Alignment(0.05, 0.17),
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) {
//                               return const ShippingAddressDesignPage();
//                             },
//                           ),
//                         );
//                       },
//                       child:
//                           user?.state = ""
//                               ? Text(
//                                 user.state,
//                                 style: GoogleFonts.montserrat(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               )
//                               : Text(
//                                 'States',
//                                 style: GoogleFonts.montserrat(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                     ),
//                   ),
//                   Align(
//                     alignment: const Alignment(0.09, 0.81),
//                     child: SizedBox(
//                       width: 287,
//                       height: 117,
//                       child: Stack(
//                         clipBehavior: Clip.none,
//                         children: [
//                           Positioned(
//                             left: 240,
//                             top: 66,
//                             child: Text(
//                               "15",
//                               style: GoogleFonts.roboto(
//                                 color: Colors.white,
//                                 fontSize: 22,
//                                 letterSpacing: 0.4,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 212,
//                             top: 99,
//                             child: Text(
//                               "Completed",
//                               style: GoogleFonts.quicksand(
//                                 fontSize: 14,
//                                 color: Colors.white,
//                                 letterSpacing: 0.3,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 224,
//                             top: 2,
//                             child: Container(
//                               width: 52,
//                               height: 58,
//                               clipBehavior: Clip.antiAlias,
//                               decoration: const BoxDecoration(
//                                 image: DecorationImage(
//                                   image: NetworkImage(
//                                     "https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Ff0db1e22e37c1e2a001bbb5bd4b9aafc.png",
//                                   ),
//                                   fit: BoxFit.contain,
//                                 ),
//                               ),
//                               child: Stack(
//                                 clipBehavior: Clip.none,
//                                 children: [
//                                   Positioned(
//                                     left: 13,
//                                     top: 18,
//                                     child: Image.network(
//                                       width: 26,
//                                       height: 26,
//                                       'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F4ad2eb1752466c61c6bb41a0e223251a906a1a7bcorrect%201.png?alt=media&token=57abd4a6-50b4-4609-bb59-b48dce4c8cc6',
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           // Positioned(
//                           //   left: 130,
//                           //   top: 66,
//                           //   child: Text(
//                           //     favoriteCount.length.toString(),
//                           //     style: GoogleFonts.montserrat(
//                           //         color: Colors.white,
//                           //         fontSize: 22,
//                           //         letterSpacing: 0.4),
//                           //   ),
//                           // ),
//                           Positioned(
//                             left: 108,
//                             top: 99,
//                             child: Text(
//                               'Favorite',
//                               style: GoogleFonts.montserrat(
//                                 color: Colors.white,
//                                 letterSpacing: 0.3,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 114,
//                             top: 2,
//                             child: Container(
//                               width: 52,
//                               height: 58,
//                               clipBehavior: Clip.antiAlias,
//                               decoration: const BoxDecoration(
//                                 image: DecorationImage(
//                                   fit: BoxFit.contain,
//                                   image: NetworkImage(
//                                     "https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Ff0db1e22e37c1e2a001bbb5bd4b9aafc.png",
//                                   ),
//                                 ),
//                               ),
//                               child: Stack(
//                                 clipBehavior: Clip.none,
//                                 children: [
//                                   Positioned(
//                                     left: 15,
//                                     top: 18,
//                                     child: Image.network(
//                                       width: 26,
//                                       height: 26,
//                                       "https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F068bdad59a9aff5a9ee67737678b8d5438866afewish-list%201.png?alt=media&token=4a8abc27-022f-4a53-8f07-8c10791468e4",
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 20,
//                             top: 66,
//                             child: Text(
//                               cartData.length.toString(),
//                               style: GoogleFonts.montserrat(
//                                 color: Colors.white,
//                                 fontSize: 22,
//                                 letterSpacing: 0.4,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 13,
//                             top: 99,
//                             child: Text(
//                               'Cart',
//                               style: GoogleFonts.montserrat(
//                                 fontSize: 14,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 letterSpacing: 0.4,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 5,
//                             top: 0,
//                             child: Container(
//                               width: 56,
//                               height: 63,
//                               clipBehavior: Clip.antiAlias,
//                               decoration: const BoxDecoration(
//                                 image: DecorationImage(
//                                   fit: BoxFit.contain,
//                                   image: NetworkImage(
//                                     'https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Fe0080f58f1ec1f2200fcf329b10ce4c4.png',
//                                   ),
//                                 ),
//                               ),
//                               child: Stack(
//                                 clipBehavior: Clip.none,
//                                 children: [
//                                   Positioned(
//                                     left: 12,
//                                     top: 15,
//                                     child: Image.network(
//                                       width: 33,
//                                       height: 33,
//                                       'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Fc2afb7fb33cd20f4f1aed312669aa43b8bb2d431cart%20(2)%201.png?alt=media&token=be3d8494-1ccd-4925-91f1-ee30402dfb0e',
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             ListTile(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) {
//                       return const OrdersScreen();
//                     },
//                   ),
//                 );
//               },
//               leading: Image.asset('assets/icons/orders.png'),
//               title: Text(
//                 'Track your order',
//                 style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 10),
//             ListTile(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) {
//                       return const OrdersScreen();
//                     },
//                   ),
//                 );
//               },
//               leading: Image.asset('assets/icons/history.png'),
//               title: Text(
//                 'History',
//                 style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 10),
//             ListTile(
//               onTap: () {},
//               leading: Image.asset('assets/icons/help.png'),
//               title: Text(
//                 'Help',
//                 style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 10),
//             ListTile(
//               onTap: () {},
//               leading: Image.asset('assets/icons/logout.png'),
//               title: Text(
//                 'Logout',
//                 style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';

// class AccountScreen extends StatelessWidget {
//   const AccountScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(body: Center(child: ElevatedButton(
//   onPressed: () {
//     Authcontroller().signoutuser(
//       context: context,
//       ref: ref, // يجب أن تكون داخل ConsumerWidget أو HookConsumerWidget
//     );
//   },
//   child: Text('تسجيل الخروج'),
// ),));
//   }
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:multivendor_ecommerce_riverbod/controllers/authcontroller.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/Navescreen/wedget/top_ralated.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/orderscreen.dart';

// class AccountScreen extends ConsumerWidget {
//   const AccountScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(
//             height: 450,
//             child: Stack(
//               clipBehavior: Clip.none,

//               children: [
//                 Align(
//                   alignment: Alignment.center,
//                   child: Image.network(
//                     'https://sdmntprpolandcentral.oaiusercontent.com/files/00000000-fe84-620a-bbd8-0349e72a22d9/raw?se=2025-08-17T18%3A47%3A54Z&sp=r&sv=2024-08-04&sr=b&scid=9b1f2e85-8f8c-5988-bc74-1f53654b488a&skoid=76024c37-11e2-4c92-aa07-7e519fbe2d0f&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-08-17T08%3A33%3A22Z&ske=2025-08-18T08%3A33%3A22Z&sks=b&skv=2024-08-04&sig=D2JZcQ9eUGUftsFxalSm2/yteR5NBKx65%2BPTCOvwiX8%3D',
//                     fit: BoxFit.cover,
//                     width: MediaQuery.of(context).size.width,
//                   ),
//                 ),
//                 Positioned(
//                   child: Align(
//                     alignment: Alignment.topRight,
//                     child: Image.asset(
//                       'assets/icons/not.png',
//                       width: 30,
//                       height: 30,
//                     ),
//                   ),
//                 ),
//                 Stack(
//                   children: [
//                     InkWell(
//                       onTap: () {},
//                       child: Align(
//                         alignment: Alignment(0, -0.53),
//                         child: CircleAvatar(
//                           radius: 65,
//                           backgroundImage: NetworkImage(
//                             'https://sdmntprnorthcentralus.oaiusercontent.com/files/00000000-db84-622f-9ff3-7ab9a7ad4abe/raw?se=2025-08-17T15%3A02%3A51Z&sp=r&sv=2024-08-04&sr=b&scid=276e0cfc-bf9c-596b-952f-576741dfac18&skoid=24a7dec3-38fc-4904-b888-8abe0855c442&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-08-16T23%3A48%3A33Z&ske=2025-08-17T23%3A48%3A33Z&sks=b&skv=2024-08-04&sig=G/R8Exr6apR/WTXRRjFnZznH2Wj47azMzGXbQ57TeIc%3D',
//                           ),
//                         ),
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment(0.23, -0.61),
//                       child: Image.asset(
//                         'assets/icons/edit.png',
//                         width: 19,
//                         height: 19,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Align(
//                   alignment: Alignment(0, 0.03),
//                   child: Text(
//                     'mariam mohamed',
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),

//                 Align(
//                   alignment: Alignment(0.05, 0.17),
//                   child: InkWell(
//                     onTap: () {},
//                     child: Text(
//                       'unite state',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment(0.09, 0.81),
//                   child: SizedBox(
//                     width: 287,
//                     height: 117,
//                     child: Stack(
//                       clipBehavior: Clip.none,
//                       children: [
//                         Positioned(
//                           left: 240,
//                           top: 66,
//                           child: Text(
//                             '15',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 22,
//                               letterSpacing: 0.04,
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           left: 212,
//                           top: 99,
//                           child: Text(
//                             'combeleted',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.white,
//                               letterSpacing: 0.03,
//                             ),
//                           ),
//                         ),

//                         Positioned(
//                           left: 224,
//                           top: 2,
//                           child: Container(
//                             width: 52,
//                             height: 58,
//                             clipBehavior: Clip.antiAlias,
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                 image: NetworkImage(
//                                   'https://sdmntprpolandcentral.oaiusercontent.com/files/00000000-fe84-620a-bbd8-0349e72a22d9/raw?se=2025-08-17T18%3A47%3A54Z&sp=r&sv=2024-08-04&sr=b&scid=9b1f2e85-8f8c-5988-bc74-1f53654b488a&skoid=76024c37-11e2-4c92-aa07-7e519fbe2d0f&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-08-17T08%3A33%3A22Z&ske=2025-08-18T08%3A33%3A22Z&sks=b&skv=2024-08-04&sig=D2JZcQ9eUGUftsFxalSm2/yteR5NBKx65%2BPTCOvwiX8%3D',
//                                 ),
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                             child: Stack(
//                               clipBehavior: Clip.none,
//                               children: [
//                                 Positioned(
//                                   top: 18,
//                                   left: 13,
//                                   child: Image.network(
//                                     width: 26,
//                                     height: 26,
//                                     'https://sdmntprpolandcentral.oaiusercontent.com/files/00000000-66d8-620a-b5a2-a276df936ced/raw?se=2025-08-17T18%3A43%3A52Z&sp=r&sv=2024-08-04&sr=b&scid=6e8783e3-a8af-574f-b1d2-37ca55d5358d&skoid=76024c37-11e2-4c92-aa07-7e519fbe2d0f&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-08-17T07%3A48%3A13Z&ske=2025-08-18T07%3A48%3A13Z&sks=b&skv=2024-08-04&sig=aFe17rYISfCdPrk0GcN5S%2BFhn2YmtWob8EmF/tmL4jA%3D',
//                                   ),
//                                 ),
//                                 Positioned(
//                                   left: 130,
//                                   top: 66,

//                                   child: Text(
//                                     '5',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 22,
//                                       letterSpacing: 0.4,
//                                     ),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   left: 108,
//                                   top: 99,
//                                   child: Text(
//                                     'FAVOURITE',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       letterSpacing: 0.3,
//                                     ),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   left: 114,
//                                   top: 2,
//                                   child: Container(
//                                     width: 52,
//                                     height: 58,
//                                     clipBehavior: Clip.antiAlias,
//                                     decoration: BoxDecoration(
//                                       image: DecorationImage(
//                                         image: NetworkImage(''),
//                                         fit: BoxFit.contain,
//                                       ),
//                                     ),
//                                     child: Stack(
//                                       clipBehavior: Clip.none,
//                                       children: [
//                                         Positioned(
//                                           left: 15,
//                                           top: 15,
//                                           child: Image.network(
//                                             '',
//                                             width: 26,
//                                             height: 26,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
////////////////
// ElevatedButton(
//           onPressed: () {
//             Authcontroller().signoutuser(context: context, ref: ref);
//           },
//           child: const Text('تسجيل الخروج'),
//         ),


// Center(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               TopRatedWidget(),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) {
//                         return OrdersScreen();
//                       },
//                     ),
//                   );
//                 },
//                 child: const Text('طلباتى'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Authcontroller().signoutuser(context: context, ref: ref);
//                 },
//                 child: const Text('تسجيل الخروج'),
//               ),
//             ],
//           ),
//         ),
//       ),