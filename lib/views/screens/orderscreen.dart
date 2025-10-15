// lib/views/screens/orders_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multivendor_ecommerce_riverpod/provider/order_provider.dart';
import 'package:multivendor_ecommerce_riverpod/provider/user_provider.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/orderdetails_screen.dart';

import '../../models/order.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final user = ref.read(userProvider);
    if (user == null || user.id.isEmpty) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await ref.read(orderProvider.notifier).fetchUserOrders(user.id);
    } catch (e) {
      _error = 'فشل في جلب الطلبات';
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _confirmDelete(OrderModel order) async {
    final user = ref.read(userProvider);
    if (user == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('تأكيد الحذف'),
            content: const Text('هل أنت متأكد أنك تريد حذف هذا الطلب؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('حذف'),
              ),
            ],
          ),
    );
    if (confirmed == true) {
      await ref.read(orderProvider.notifier).deleteOrder(order.id, user.id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم حذف الطلب بنجاح')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderProvider);
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('طلباتي'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadOrders),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text(_error!))
              : orders.isEmpty
              ? const Center(child: Text('لا توجد طلبات'))
              : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemBuilder: (_, index) {
                  final order = orders[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderDetailsScreen(order: order),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header: product + status + delete
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    order.productName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Tooltip(
                                  message: 'حذف الطلب',
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () => _confirmDelete(order),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'الكمية: ${order.quantity} • الفئة: ${order.category}',
                            ),
                            const SizedBox(height: 4),
                            Text('السعر لكل وحدة: ${order.productPrice} ج.م'),
                            const SizedBox(height: 4),
                            Text(
                              'المجموع: ${(double.tryParse(order.productPrice) ?? 0) * order.quantity} ج.م',
                            ),
                            const SizedBox(height: 6),
                            Text('الاسم: ${order.fullName}'),
                            Text('البريد: ${order.email}'),
                            Text(
                              'العنوان: ${order.state} - ${order.city}, ${order.locality}',
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'الحالة: ${order.status}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: _statusColor(order.status),
                                  ),
                                ),
                                Text(
                                  DateFormat.yMMMd(
                                    'en_US',
                                  ).add_jm().format(order.orderDate),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: orders.length,
              ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
