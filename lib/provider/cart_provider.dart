import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multivendor_ecommerce_riverpod/models/cartmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends StateNotifier<List<CartItem>> {
  CartController() : super([]) {
    _loadCartFromPrefs();
  }

  Future<void> _loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('cart_items');
    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      final items = decoded.map((e) => CartItem.fromJson(e)).toList();
      state = items;
    }
  }

  Future<void> _saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = state.map((item) => item.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await prefs.setString('cart_items', jsonString);
  }

  void _updateState(List<CartItem> newState) {
    state = newState;
    _saveCartToPrefs();
  }

  void addToCart(CartItem item) {
    final index = state.indexWhere((i) => i.id == item.id);
    if (index >= 0) {
      state[index].quantity += item.quantity;
      _updateState([...state]);
    } else {
      _updateState([...state, item]);
    }
  }

  void removeFromCart(String id) {
    _updateState(state.where((item) => item.id != id).toList());
  }

  void incrementQuantity(String id) {
    final index = state.indexWhere((item) => item.id == id);
    if (index >= 0) {
      state[index].quantity++;
      _updateState([...state]);
    }
  }

  void decrementQuantity(String id) {
    final index = state.indexWhere((item) => item.id == id);
    if (index >= 0 && state[index].quantity > 1) {
      state[index].quantity--;
      _updateState([...state]);
    }
  }

  double get totalPrice {
    return state.fold(0.0, (sum, item) => sum + item.price * item.quantity);
  }

  void clearCart() {
    _updateState([]);
  }
}

final cartProvider = StateNotifierProvider<CartController, List<CartItem>>((
  ref,
) {
  return CartController();
});

// class CartController extends StateNotifier<List<CartItem>> {
//   CartController() : super([]);

//   void addToCart(CartItem item) {
//     final index = state.indexWhere((i) => i.id == item.id);
//     if (index >= 0) {
//       state[index].quantity += item.quantity;
//       state = [...state];
//     } else {
//       state = [...state, item];
//     }
//   }

//   void removeFromCart(String id) {
//     state = state.where((item) => item.id != id).toList();
//   }

//   void incrementQuantity(String id) {
//     final index = state.indexWhere((item) => item.id == id);
//     if (index >= 0) {
//       state[index].quantity++;
//       state = [...state];
//     }
//   }

//   void decrementQuantity(String id) {
//     final index = state.indexWhere((item) => item.id == id);
//     if (index >= 0 && state[index].quantity > 1) {
//       state[index].quantity--;
//       state = [...state];
//     }
//   }

//   double get totalPrice {
//     return state.fold(0.0, (sum, item) => sum + item.price * item.quantity);
//   }

//   void clearCart() {
//     state = [];
//   }
// }

// final cartProvider = StateNotifierProvider<CartController, List<CartItem>>((
//   ref,
// ) {
//   return CartController();
// });
