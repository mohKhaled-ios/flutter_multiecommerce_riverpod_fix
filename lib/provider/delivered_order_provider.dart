import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/order_controller.dart';

/// ✅ Provider لحساب عدد الطلبات المستلمة (Delivered Orders)
final deliveredOrderCountProvider = FutureProvider.family<int, String>((
  ref,
  buyerId,
) async {
  try {
    final count = await OrderService.countDeliveredOrders(buyerId);
    return count;
  } catch (e) {
    throw Exception("فشل في جلب عدد الطلبات المستلمة: $e");
  }
});
