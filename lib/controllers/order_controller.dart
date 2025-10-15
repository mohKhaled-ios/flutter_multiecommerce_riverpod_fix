import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:multivendor_ecommerce_riverpod/models/order.dart';

class OrderService {
  static const String baseUrl = 'http://192.168.1.3:5000/api/orders';

  // ✅ إنشاء طلب
  static Future<bool> createOrder(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return response.statusCode == 201;
  }

  // ✅ جلب الطلبات للمستخدم
  static Future<List<OrderModel>> getOrdersByBuyer(String buyerId) async {
    final response = await http.get(Uri.parse('$baseUrl/buyer/$buyerId'));

    if (response.statusCode == 200) {
      final List decoded = jsonDecode(response.body);
      return decoded.map((e) => OrderModel.fromJson(e)).toList();
    } else {
      throw Exception('فشل في جلب الطلبات');
    }
  }

  static Future<bool> deleteOrder(String orderId) async {
    final response = await http.delete(Uri.parse('$baseUrl/$orderId'));
    return response.statusCode == 200;
  }

  static Future<bool> updateStatus({
    required String orderId,
    required String status,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$orderId/status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );
    return response.statusCode == 200;
  }

  // ✅ حساب عدد الطلبات الخاصة بالتوصيل (delivered)
  static Future<int> countDeliveredOrders(String buyerId) async {
    final response = await http.get(Uri.parse('$baseUrl/buyer/$buyerId'));

    if (response.statusCode == 200) {
      final List decoded = jsonDecode(response.body);
      final orders = decoded.map((e) => OrderModel.fromJson(e)).toList();

      // ✅ عدّ الطلبات اللي حالتها delivered
      final deliveredOrders =
          orders
              .where((order) => order.status.toLowerCase() == 'delivered')
              .toList();

      return deliveredOrders.length;
    } else {
      throw Exception('فشل في جلب الطلبات لحساب التوصيل');
    }
  }
}
