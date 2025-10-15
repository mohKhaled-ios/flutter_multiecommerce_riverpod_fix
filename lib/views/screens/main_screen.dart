import 'package:flutter/material.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/Account_screen.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/cart_screen.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/favourete_screen.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/home_screen.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/Navescreen/wedget/category_screen.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/payment_history_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    FavoriteProductsScreen(),
    CategoryScreen(),
    PaymentHistoryScreen(),
    CartScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _pageIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/home.png', width: 25),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/love.png', width: 25),
            label: 'Favourite  ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories  ',
          ),

          // BottomNavigationBarItem(
          //   icon: Image.asset('assets/icons/mart.png', width: 25),
          //   label: 'Stores',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'المدفوعات',
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
