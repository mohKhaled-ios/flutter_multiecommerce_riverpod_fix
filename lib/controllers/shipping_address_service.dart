// // lib/services/shipping_address_service.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// const String baseUrl = 'http://192.168.1.3:5000'; // غيّرها حسب البيئة

// class ShippingAddressService {
  

//   Future<Map<String, dynamic>?> fetchAddress({required String token}) async {
//     final uri = Uri.parse('$baseUrl/api/user/address');

//     print("📡 Fetching from: $uri");
//     print("🔑 Token: $token");

//     final res = await http.get(
//       uri,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );

//     print("📡 Status Code: ${res.statusCode}");
//     print("📦 Body: ${res.body}");

//     if (res.statusCode == 200) {
//       final body = jsonDecode(res.body);

//       // لو البيانات في الـ root
//       if (body['state'] != null) {
//         return {
//           'state': body['state'] ?? '',
//           'city': body['city'] ?? '',
//           'locality': body['locality'] ?? '',
//         };
//       }

//       // لو البيانات داخل key اسمه data
//       if (body['data'] != null) {
//         return {
//           'state': body['data']['state'] ?? '',
//           'city': body['data']['city'] ?? '',
//           'locality': body['data']['locality'] ?? '',
//         };
//       }

//       print("⚠️ شكل البيانات غير متوقع");
//       return null;
//     } else {
//       print("❌ فشل في جلب العنوان: ${res.statusCode}");
//       return null;
//     }
//   }

//   Future<bool> updateAddress({
//     required String token,
//     required String state,
//     required String city,
//     required String locality,
//   }) async {
//     final uri = Uri.parse('$baseUrl/api/user/address');
//     final res = await http.put(
//       uri,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//       body: jsonEncode({'state': state, 'city': city, 'locality': locality}),
//     );
//     return res.statusCode == 200;
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://192.168.1.3:5000';

class ShippingAddressService {
  Future<Map<String, dynamic>?> fetchAddress({required String token}) async {
    final uri = Uri.parse('$baseUrl/api/user/address');

    print("📡 Fetching from: $uri");
    print("🔑 Token: $token");

    final res = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("📡 Status Code: ${res.statusCode}");
    print("📦 Body: ${res.body}");

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);

      if (body['state'] != null) {
        return {
          'state': body['state'] ?? '',
          'city': body['city'] ?? '',
          'locality': body['locality'] ?? '',
        };
      }

      if (body['data'] != null) {
        return {
          'state': body['data']['state'] ?? '',
          'city': body['data']['city'] ?? '',
          'locality': body['data']['locality'] ?? '',
        };
      }

      print("⚠️ شكل البيانات غير متوقع");
      return null;
    } else {
      print("❌ فشل في جلب العنوان: ${res.statusCode}");
      return null;
    }
  }

  Future<bool> updateAddress({
    required String token,
    required String state,
    required String city,
    required String locality,
  }) async {
    final uri = Uri.parse('$baseUrl/api/user/address');
    final res = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'state': state, 'city': city, 'locality': locality}),
    );
    
    print("📡 Update Address Status: ${res.statusCode}");
    print("📦 Update Address Body: ${res.body}");
    
    return res.statusCode == 200;
  }
}