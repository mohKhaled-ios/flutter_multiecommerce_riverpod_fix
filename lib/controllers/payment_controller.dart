// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:multivendor_ecommerce_riverpod/glopal_variable.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// class PaymentService {
//   static const String baseUrl = '$uri/api/payments';

//   // تهيئة Stripe
//   static Future<void> initStripe() async {
//     try {
//       Stripe.publishableKey = 'your_publishable_key_here';
//       await Stripe.instance.applySettings();
//     } catch (e) {
//       debugPrint('❌ Stripe Init Error: $e');
//     }
//   }

//   // إنشاء دفع جديد
//   static Future<Map<String, dynamic>?> createPaymentIntent({
//     required double amount,
//     required String currency,
//     required Map<String, dynamic> orderDetails,
//     String paymentMethod = 'card',
//   }) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');

//       final response = await http.post(
//         Uri.parse('$baseUrl/create-payment-intent'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({
//           'amount': amount,
//           'currency': currency,
//           'orderDetails': orderDetails,
//           'paymentMethod': paymentMethod,
//         }),
//       );

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         debugPrint(
//           '❌ فشل إنشاء الدفع: ${response.statusCode} - ${response.body}',
//         );
//         return null;
//       }
//     } catch (e) {
//       debugPrint('💥 خطأ في إنشاء الدفع: $e');
//       return null;
//     }
//   }

//   // تأكيد الدفع
//   static Future<Map<String, dynamic>?> confirmPayment(
//     String paymentIntentId,
//   ) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');

//       final response = await http.post(
//         Uri.parse('$baseUrl/confirm-payment'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({'paymentIntentId': paymentIntentId}),
//       );

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         debugPrint(
//           '❌ فشل تأكيد الدفع: ${response.statusCode} - ${response.body}',
//         );
//         return null;
//       }
//     } catch (e) {
//       debugPrint('💥 خطأ في تأكيد الدفع: $e');
//       return null;
//     }
//   }

//   // معالجة الدفع باستخدام Stripe
//   static Future<Map<String, dynamic>?> processStripePayment({
//     required double amount,
//     required String currency,
//     required Map<String, dynamic> orderDetails,
//   }) async {
//     try {
//       final paymentIntent = await createPaymentIntent(
//         amount: amount,
//         currency: currency,
//         orderDetails: orderDetails,
//       );

//       if (paymentIntent == null) {
//         return {'success': false, 'message': 'فشل في إنشاء الدفع'};
//       }

//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: paymentIntent['clientSecret'],
//           merchantDisplayName: 'متجرك الإلكتروني',
//           style: ThemeMode.light,
//         ),
//       );

//       await Stripe.instance.presentPaymentSheet();

//       final confirmation = await confirmPayment(
//         paymentIntent['paymentIntentId'],
//       );

//       if (confirmation != null) {
//         return {'success': true, 'message': 'تم الدفع بنجاح'};
//       } else {
//         return {'success': false, 'message': 'فشل في الدفع'};
//       }
//     } on StripeException catch (e) {
//       return {'success': false, 'message': e.error.localizedMessage};
//     } catch (e) {
//       debugPrint('💥 خطأ غير متوقع: $e');
//       return {'success': false, 'message': 'حدث خطأ غير متوقع'};
//     }
//   }

//   // الدفع عند الاستلام
//   static Future<Map<String, dynamic>> processCashOnDelivery({
//     required Map<String, dynamic> orderData,
//   }) async {
//     await Future.delayed(const Duration(seconds: 2));
//     return {'success': true, 'message': 'تم تأكيد الطلب بالدفع عند الاستلام'};
//   }

//   static Future<List<dynamic>?> getPaymentHistory() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');

//       print('🔄 محاولة جلب تاريخ المدفوعات...');
//       print('🔑 التوكن: ${token != null ? 'موجود' : 'غير موجود'}');

//       final response = await http.get(
//         Uri.parse('$baseUrl/payment-history'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       print('📊 حالة جلب التاريخ: ${response.statusCode}');
//       print('📝 محتوى الرد: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print('✅ تم جلب ${data.length} من المدفوعات');
//         return data;
//       } else {
//         print('❌ فشل في جلب تاريخ المدفوعات: ${response.statusCode}');
//         print('📋 محتوى الخطأ: ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('💥 خطأ في جلب تاريخ المدفوعات: $e');
//       return null;
//     }
//   }
// }
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:multivendor_ecommerce_riverpod/glopal_variable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentService {
  // base for payments endpoints
  static const String baseUrl = '$uri/api/payments';
  // config endpoint to fetch publishable key
  static const String configUrl = '$uri/config';

  // تهيئة Stripe: يجلب publishableKey من الباك-إند ثم يهيئ المكتبة
  static Future<void> initStripe() async {
    try {
      // Stripe غير مدعوم (أو لا نريد تهيئته) على الويب بنفس الطريقة
      if (kIsWeb) {
        debugPrint('⚠️ Stripe init skipped on web (kIsWeb == true)');
        return;
      }

      final resp = await http.get(Uri.parse(configUrl));
      if (resp.statusCode != 200) {
        throw Exception(
          'فشل في جلب publishableKey من السيرفر: ${resp.statusCode}',
        );
      }

      final data = jsonDecode(resp.body);
      final publishableKey = (data['publishableKey'] ?? '') as String;

      if (publishableKey.isEmpty) {
        throw Exception(
          'publishableKey فارغ — تأكد من أن الباك-إند يعيد المفتاح في /config',
        );
      }

      Stripe.publishableKey = publishableKey.trim();
      // إذا أردت ضبط إعدادات إضافية ضعها هنا
      await Stripe.instance.applySettings();
      debugPrint('✅ Stripe initialized with publishableKey');
    } catch (e, s) {
      debugPrint('❌ Stripe Init Error: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  // إنشاء دفع جديد على السيرفر (PaymentIntent)
  static Future<Map<String, dynamic>?> createPaymentIntent({
    required double amount,
    required String currency,
    required Map<String, dynamic> orderDetails,
    String paymentMethod = 'card',
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.post(
        Uri.parse('$baseUrl/create-payment-intent'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'amount': amount,
          'currency': currency,
          'orderDetails': orderDetails,
          'paymentMethod': paymentMethod,
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        debugPrint('✅ createPaymentIntent response: $body');
        return body;
      } else {
        debugPrint(
          '❌ createPaymentIntent failed: ${response.statusCode} - ${response.body}',
        );
        return null;
      }
    } catch (e, s) {
      debugPrint('💥 خطأ في createPaymentIntent: $e');
      debugPrintStack(stackTrace: s);
      return null;
    }
  }

  // تأكيد الدفع عبر السيرفر (اختياري - في حال أردت تحقق إضافي)
  static Future<Map<String, dynamic>?> confirmPayment(
    String paymentIntentId,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.post(
        Uri.parse('$baseUrl/confirm-payment'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'paymentIntentId': paymentIntentId}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        debugPrint('✅ confirmPayment response: $body');
        return body;
      } else {
        debugPrint(
          '❌ confirmPayment failed: ${response.statusCode} - ${response.body}',
        );
        return null;
      }
    } catch (e, s) {
      debugPrint('💥 خطأ في confirmPayment: $e');
      debugPrintStack(stackTrace: s);
      return null;
    }
  }

  // معالجة الدفع باستخدام Stripe (Mobile only)
  static Future<Map<String, dynamic>?> processStripePayment({
    required double amount,
    required String currency,
    required Map<String, dynamic> orderDetails,
  }) async {
    try {
      if (kIsWeb) {
        // يمكنك التعامل مع دفع ويب بطريقة أخرى (Stripe Elements أو Checkout)
        debugPrint(
          '⚠️ processStripePayment: Stripe mobile-only flow — running on web.',
        );
        return {
          'success': false,
          'message': 'Stripe غير مدعوم بهذه الطريقة على الويب',
        };
      }

      // 1) Create payment intent on backend
      final paymentIntent = await createPaymentIntent(
        amount: amount,
        currency: currency,
        orderDetails: orderDetails,
      );

      if (paymentIntent == null) {
        return {'success': false, 'message': 'فشل في إنشاء الدفع على السيرفر'};
      }

      final clientSecret = paymentIntent['clientSecret'] as String?;
      final paymentIntentId = paymentIntent['paymentIntentId'] as String?;

      if (clientSecret == null || clientSecret.isEmpty) {
        debugPrint(
          '❌ clientSecret غير موجود في استجابة السيرفر: $paymentIntent',
        );
        return {
          'success': false,
          'message': 'clientSecret غير موجود من السيرفر',
        };
      }

      // 2) Init Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'متجرك الإلكتروني',
          // يمكنك تمكين Google Pay / Apple Pay هنا إذا قمت بإعدادها في Stripe dashboard
          // merchantCountryCode: 'EG', // مثال
        ),
      );

      // 3) Present Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      // 4) (اختياري) Confirm on server side
      if (paymentIntentId != null && paymentIntentId.isNotEmpty) {
        final confirmation = await confirmPayment(paymentIntentId);
        if (confirmation == null) {
          debugPrint('⚠️ تم الدفع محليًا لكن تأكيد السيرفر فشل أو غير متاح');
          // نعتبر النجاح لكن نحذر المستخدم — يمكنك اعتبار هذا فشل حسب سياستك
        }
      }

      return {'success': true, 'message': 'تم الدفع بنجاح'};
    } on StripeException catch (e) {
      debugPrint('StripeException: ${e.error.localizedMessage}');
      return {
        'success': false,
        'message': e.error.localizedMessage ?? 'خطأ من Stripe',
      };
    } catch (e, s) {
      debugPrint('💥 خطأ في processStripePayment: $e');
      debugPrintStack(stackTrace: s);
      return {'success': false, 'message': 'حدث خطأ غير متوقع أثناء الدفع'};
    }
  }

  // الدفع عند الاستلام (COD)
  static Future<Map<String, dynamic>> processCashOnDelivery({
    required Map<String, dynamic> orderData,
  }) async {
    try {
      // هنا يمكنك فعل طلب إنشاء الطلب على السيرفر أو أي منطق آخر
      final response = await http.post(
        Uri.parse('$uri/api/orders'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': 'تم إنشاء الطلب بنجاح (الدفع عند الاستلام)',
        };
      } else {
        debugPrint(
          '❌ processCashOnDelivery failed: ${response.statusCode} - ${response.body}',
        );
        return {'success': false, 'message': 'فشل في إنشاء الطلب (COD)'};
      }
    } catch (e, s) {
      debugPrint('💥 خطأ في processCashOnDelivery: $e');
      debugPrintStack(stackTrace: s);
      return {'success': false, 'message': 'حدث خطأ أثناء إنشاء الطلب (COD)'};
    }
  }

  // جلب تاريخ المدفوعات من السيرفر
  static Future<List<dynamic>?> getPaymentHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      debugPrint(
        '🔄 محاولة جلب تاريخ المدفوعات... token ${token != null ? 'موجود' : 'غير موجود'}',
      );

      final response = await http.get(
        Uri.parse('$baseUrl/payment-history'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('📊 حالة جلب التاريخ: ${response.statusCode}');
      debugPrint('📝 محتوى الرد: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        debugPrint('✅ تم جلب ${data.length} من المدفوعات');
        return data;
      } else {
        debugPrint(
          '❌ فشل في جلب تاريخ المدفوعات: ${response.statusCode} - ${response.body}',
        );
        return null;
      }
    } catch (e, s) {
      debugPrint('💥 خطأ في جلب تاريخ المدفوعات: $e');
      debugPrintStack(stackTrace: s);
      return null;
    }
  }
}
