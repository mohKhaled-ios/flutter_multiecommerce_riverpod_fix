// class UserProvider extends StateNotifier<UserModel?> {
//   UserProvider() : super(null) {
//     _loadUserFromPrefs(); // ✅ تحميل البيانات عند التهيئة
//   }

//   UserModel? get user => state;

//   void setUser(Map<String, dynamic> userJson) {
//     state = UserModel.fromJson(userJson);
//   }

//   void clearUser() {
//     state = null;
//   }

//   void logout() {
//     clearUser();
//   }

//   Future<void> _loadUserFromPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userData = prefs.getString('user');
//     if (userData != null) {
//       final userMap = jsonDecode(userData);
//       state = UserModel.fromJson(userMap);
//     }
//   }
// }

// final userproviderr = StateNotifierProvider<UserProvider, UserModel?>(
//   (ref) => UserProvider(),
// );

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart'; // تأكد المسار الصحيح

class UserProvider extends StateNotifier<UserModel?> {
  UserProvider() : super(null) {
    _loadUserFromPrefs();
  }

  UserModel? get user => state;

  void setUser(Map<String, dynamic> userJson) {
    state = UserModel.fromJson(userJson);
  }

  void clearUser() {
    state = null;
  }

  void logout() {
    clearUser();
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData != null) {
      final userMap = jsonDecode(userData) as Map<String, dynamic>;
      state = UserModel.fromJson(userMap);
    }
  }
}

final userProvider = StateNotifierProvider<UserProvider, UserModel?>(
  (ref) => UserProvider(),
);
