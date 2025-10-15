import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:multivendor_ecommerce_riverpod/glopal_variable.dart';
import 'package:multivendor_ecommerce_riverpod/models/user.dart';
import 'package:multivendor_ecommerce_riverpod/provider/user_provider.dart';
import 'package:multivendor_ecommerce_riverpod/service/manager_http_response.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/authanticationscreen/login_screen.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// مؤقتًا نستخدم ProviderContainer (يفضل استخدام ref لاحقًا داخل Widget)
final providercontainer = ProviderContainer();

class Authcontroller {
  /// التسجيل (SignUp)
  Future<void> signupuser({
    required BuildContext context,
    required String fullname,
    required String email,
    required String password,
  }) async {
    try {
      UserModel user = UserModel(
        token: '',
        id: '',
        fullname: fullname,
        email: email,
        state: '',
        city: '',
        locality: '',
        password: password,
      );

      http.Response response = await http.post(
        Uri.parse('$uri/api/auth/signup'),
        body: jsonEncode(user.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      httpResponseHandler(
        response: response,
        context: context,
        onSuccess: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Loginscreen()),
          );
          showSnackBar(context, 'تم إنشاء الحساب بنجاح');
        },
      );
    } catch (e) {
      showSnackBar(context, 'حدث خطأ أثناء التسجيل: ${e.toString()}');
    }
  }

  Future<void> sigininuser({
    required BuildContext context,
    required WidgetRef ref,
    required String email,
    required String password,
  }) async {
    try {
      final requestBody = {'email': email, 'password': password};

      final response = await http.post(
        Uri.parse('$uri/api/auth/signin'),
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      print('Signin response body: ${response.body}');

      httpResponseHandler(
        response: response,
        context: context,
        onSuccess: () async {
          final prefs = await SharedPreferences.getInstance();
          final decodedBody = jsonDecode(response.body);
          final payload = decodedBody['data'] ?? decodedBody;

          final token =
              (payload['token'] ?? decodedBody['token'] ?? '').toString();
          final userId = ((payload['_id'] ?? payload['id']) ?? '').toString();

          if (userId.isEmpty) {
            print('❗ خطأ: userId فارغ في response. payload: $payload');
            showSnackBar(
              context,
              'فشل تسجيل الدخول: معرف المستخدم غير متوفر من السيرفر.',
            );
            return;
          }

          final userMap = {
            'token': token,
            '_id': userId,
            'fullname': (payload['fullname'] ?? '').toString(),
            'email': (payload['email'] ?? '').toString(),
            'state': (payload['state'] ?? '').toString(),
            'city': (payload['city'] ?? '').toString(),
            'locality': (payload['locality'] ?? '').toString(),
            'password': '', // لا تحفظ كلمة السر
          };

          await prefs.setString('auth_token', token);
          await prefs.setString('user', jsonEncode(userMap));

          ref.read(userProvider.notifier).setUser(userMap);
          final currentUser = ref.read(userProvider);
          print(
            'Current user in provider after set: ${currentUser?.id}, ${currentUser?.fullname}',
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );

          showSnackBar(context, 'تم تسجيل الدخول بنجاح');
        },
      );
    } catch (e) {
      print('خطأ في تسجيل الدخول: $e');
      showSnackBar(context, 'حدث خطأ أثناء تسجيل الدخول');
    }
  }

  Future<void> signoutuser({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove('auth_token');
      await prefs.remove('user');

      ref.read(userProvider.notifier).logout();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Loginscreen()),
        (route) => false,
      );

      showSnackBar(context, 'تم تسجيل الخروج بنجاح');
    } catch (e) {
      showSnackBar(context, 'فشل تسجيل الخروج: ${e.toString()}');
    }
  }
}

//   Future<void> sigininuser({
//     required BuildContext context,
//     required WidgetRef ref,
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final requestUser = UserModel(
//         token: '',
//         id: '',
//         fullname: '',
//         email: email,
//         state: '',
//         city: '',
//         locality: '',
//         password: password,
//       );

//       final response = await http.post(
//         Uri.parse('$uri/api/auth/signin'),
//         body: jsonEncode(requestUser.toJson()),
//         headers: {'Content-Type': 'application/json'},
//       );

//       print('Signin response body: ${response.body}');

//       httpResponseHandler(
//         response: response,
//         context: context,
//         onSuccess: () async {
//           final prefs = await SharedPreferences.getInstance();
//           final decodedBody = jsonDecode(response.body);
//           final payload = decodedBody['data'] ?? decodedBody;

//           final token =
//               (payload['token'] ?? decodedBody['token'] ?? '').toString();
//           final userId = ((payload['_id'] ?? payload['id']) ?? '').toString();

//           if (userId.isEmpty) {
//             print('❗ خطأ: userId فارغ في response. payload: $payload');
//             showSnackBar(
//               context,
//               'فشل تسجيل الدخول: معرف المستخدم غير متوفر من السيرفر.',
//             );
//             return;
//           }

//           final userMap = {
//             'token': token,
//             'id': userId,
//             'fullname': (payload['fullname'] ?? '').toString(),
//             'email': (payload['email'] ?? '').toString(),
//             'state': (payload['state'] ?? '').toString(),
//             'city': (payload['city'] ?? '').toString(),
//             'locality': (payload['locality'] ?? '').toString(),
//             'password': '',
//           };

//           await prefs.setString('auth_token', token);
//           await prefs.setString('user', jsonEncode(userMap));

//           ref.read(userproviderr.notifier).setUser(userMap);
//           final currentUser = ref.read(userproviderr);
//           print(
//             'Current user in provider after set: ${currentUser?.id}, ${currentUser?.fullname}',
//           );

//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => MainScreen()),
//           );

//           showSnackBar(context, 'تم تسجيل الدخول بنجاح');
//         },
//       );
//     } catch (e) {
//       print('خطأ في تسجيل الدخول: $e');
//       showSnackBar(context, 'حدث خطأ أثناء تسجيل الدخول');
//     }
//   }



//   /// ✅ تسجيل الخروج
//   Future<void> signoutuser({
//     required BuildContext context,
//     required WidgetRef ref,
//   }) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();

//       // حذف البيانات المخزنة
//       await prefs.remove('auth_token');
//       await prefs.remove('user');

//       // تفريغ الحالة داخل Riverpod
//       ref.read(userproviderr.notifier).logout();

//       // الانتقال إلى شاشة تسجيل الدخول
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => Loginscreen()),
//         (route) => false,
//       );

//       showSnackBar(context, 'تم تسجيل الخروج بنجاح');
//     } catch (e) {
//       showSnackBar(context, 'فشل تسجيل الخروج: ${e.toString()}');
//     }
//   }
// }
    





    // Future<void> sigininuser({
  //   required BuildContext context,
  //   required WidgetRef ref, // ✅ إضافة ref
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     UserModel user = UserModel(
  //       token: '',
  //       id: '',
  //       fullname: '',
  //       email: email,
  //       state: '',
  //       city: '',
  //       locality: '',
  //       password: password,
  //     );

  //     http.Response response = await http.post(
  //       Uri.parse('$uri/api/auth/signin'),
  //       body: jsonEncode(user.toJson()),
  //       headers: {'Content-Type': 'application/json'},
  //     );
  //     print('Signin response body: ${response.body}');
  //     httpResponseHandler(
  //       response: response,
  //       context: context,
  //       onSuccess: () async {
  //         final prefs = await SharedPreferences.getInstance();
  //         final decodedBody = jsonDecode(response.body);
  //         final token = decodedBody['token'];

  //         final userMap = {
  //           'token': token,
  //           'id': decodedBody['_id'] ?? '',
  //           'fullname': decodedBody['fullname'] ?? '',
  //           'email': decodedBody['email'] ?? '',
  //           'state': decodedBody['state'] ?? '',
  //           'city': decodedBody['city'] ?? '',
  //           'locality': decodedBody['locality'] ?? '',
  //           'password': '', // لا تحفظ الباسورد أبدًا
  //         };

  //         await prefs.setString('auth_token', token);
  //         await prefs.setString('user', jsonEncode(userMap));

  //         // ✅ استخدام ref هنا
  //         ref.read(userprovider.notifier).setUser(userMap);

  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => MainScreen()),
  //         );

  //         showSnackBar(context, 'تم تسجيل الدخول بنجاح');
  //       },
  //     );
  //   } catch (e) {
  //     print(' خطأ في تسجيل الدخول: $e');
  //     showSnackBar(context, 'حدث خطأ أثناء تسجيل الدخول');
  //   }
  // }