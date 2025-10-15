import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/order_controller.dart';
import 'package:multivendor_ecommerce_riverpod/models/order.dart';

final orderProvider = StateNotifierProvider<OrderController, List<OrderModel>>((
  ref,
) {
  return OrderController();
});

class OrderController extends StateNotifier<List<OrderModel>> {
  OrderController() : super([]);

  Future<void> fetchUserOrders(String buyerId) async {
    try {
      final orders = await OrderService.getOrdersByBuyer(buyerId);
      state = orders;
    } catch (e) {
      state = [];
    }
  }

  Future<void> submitOrder(Map<String, dynamic> data) async {
    final success = await OrderService.createOrder(data);
    if (success) {
      // refresh list again
      await fetchUserOrders(data['buyerId']);
    }
  }

  Future<void> deleteOrder(String orderId, String buyerId) async {
    final success = await OrderService.deleteOrder(orderId);
    if (success) {
      await fetchUserOrders(buyerId);
    }
  }
}
