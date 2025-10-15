import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multivendor_ecommerce_riverpod/provider/order_provider.dart';

class UserOrdersScreen extends ConsumerWidget {
  final int buyerId;

  const UserOrdersScreen({super.key, required this.buyerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(orderProvider);
    final controller = ref.read(orderProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('طلباتي'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder(
        future: controller.fetchUserOrders(buyerId as String),
        builder: (context, snapshot) {
          if (orders.isEmpty) {
            return const Center(child: Text('لا توجد طلبات حتى الآن'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (_, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: Image.memory(
                    base64Decode(order.productImage),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(order.productName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('السعر: ${order.productPrice} × ${order.quantity}'),
                      Text('الحالة: ${order.status}'),
                      Text(
                        'التاريخ: ${order.orderDate.toLocal()}'.split(' ')[0],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
