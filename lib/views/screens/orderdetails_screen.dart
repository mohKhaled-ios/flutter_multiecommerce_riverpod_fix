import 'dart:convert';
import 'dart:typed_data';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:multivendor_ecommerce_riverpod/provider/order_provider.dart';
import 'package:multivendor_ecommerce_riverpod/provider/review_provider.dart';

import '../../models/order.dart';
import '../../controllers/order_controller.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final OrderModel order;
  const OrderDetailsScreen({super.key, required this.order});

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  bool _isProcessing = false;

  Uint8List? _decodeImage(String src) {
    try {
      if (src.startsWith('http') || src.startsWith('https')) {
        return null; // سنتعامل كـ network image
      }
      return base64Decode(src);
    } catch (_) {
      return null;
    }
  }

  Future<void> _cancelOrder() async {
    if (widget.order.status != 'pending') return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('إلغاء الطلب'),
            content: const Text('هل ترغب فعلاً في إلغاء هذا الطلب؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('تأكيد الإلغاء'),
              ),
            ],
          ),
    );
    if (confirmed != true) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      await ref
          .read(orderProvider.notifier)
          .deleteOrder(widget.order.id, widget.order.buyerId);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم إلغاء الطلب بنجاح')));
        Navigator.pop(context); // رجوع للقائمة
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('فشل في إلغاء الطلب')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _changeStatus(String newStatus) async {
    setState(() {
      _isProcessing = true;
    });
    try {
      final success = await OrderService.updateStatus(
        orderId: widget.order.id,
        status: newStatus,
      );
      if (success) {
        await ref
            .read(orderProvider.notifier)
            .fetchUserOrders(widget.order.buyerId);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('تم تحديث حالة الطلب')));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('فشل في تحديث الحالة')));
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('فشل في تحديث الحالة')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showAddReviewDialog() {
    double ratingValue = 3;
    final reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('إضافة تقييم'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RatingBar(
                  filledIcon: Icons.star,
                  emptyIcon: Icons.star_border,
                  onRatingChanged: (value) {
                    ratingValue = value;
                  },
                  initialRating: 3,
                  maxRating: 5,
                  size: 32,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: reviewController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'أكتب رأيك هنا...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                // final prefs = await SharedPreferences.getInstance();
                // final productId = prefs.getString('productIds');
                final success = await ref
                    .read(reviewProvider.notifier)
                    .addReview(
                      fullName: widget.order.fullName,
                      productId:
                          widget.order.productId, // لازم يكون موجود في order
                      rating: ratingValue,
                      email: widget.order.email,
                      review: reviewController.text,
                      buyerId: widget.order.buyerId,
                    );

                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إضافة التقييم بنجاح')),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('إرسال'),
            ),
          ],
        );
      },
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

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final imageData = _decodeImage(order.productImage);
    final formattedDate = DateFormat.yMMMd(
      'en_US',
    ).add_jm().format(order.orderDate);
    final unitPrice = double.tryParse(order.productPrice) ?? 0;
    final totalPrice = unitPrice * order.quantity;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الطلب'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // حالة الطلب + التاريخ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  backgroundColor: _statusColor(order.status).withOpacity(0.15),
                  label: Text(
                    order.status.toUpperCase(),
                    style: TextStyle(
                      color: _statusColor(order.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  formattedDate,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // المنتج
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade100,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:
                            imageData != null
                                ? Image.memory(
                                  imageData,
                                  fit: BoxFit.cover,
                                  width: 80,
                                  height: 80,
                                )
                                : (order.productImage.startsWith('http')
                                    ? Image.network(
                                      order.productImage,
                                      fit: BoxFit.cover,
                                      width: 80,
                                      height: 80,
                                    )
                                    : const Icon(
                                      Icons.image_not_supported,
                                      size: 48,
                                      color: Colors.grey,
                                    )),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.productName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text('الفئة: ${order.category}'),
                          Text('الكمية: ${order.quantity}'),
                          Text(
                            'سعر الوحدة: ${unitPrice.toStringAsFixed(2)} ج.م',
                          ),
                          Text(
                            'الإجمالي: ${totalPrice.toStringAsFixed(2)} ج.م',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // معلومات التوصيل
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'معلومات التوصيل',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('الاسم: ${order.fullName}'),
                    Text('البريد: ${order.email}'),
                    Text(
                      'العنوان: ${order.state} - ${order.city}, ${order.locality}',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // أزرار الإجراء
            if (_isProcessing)
              const Center(child: CircularProgressIndicator())
            else
              Column(
                children: [
                  Row(
                    children: [
                      if (order.status == 'pending')
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _cancelOrder,
                            icon: const Icon(Icons.cancel_outlined),
                            label: const Text('إلغاء الطلب'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _showAddReviewDialog,
                          icon: const Icon(Icons.rate_review),
                          label: const Text('إضافة تقييم'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      // مشاركة الطلب
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('مشاركة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 16),
            const Text(
              'يمكنك تتبع حالة طلبك، وإذا كان الطلب في انتظار يمكنك إلغاؤه. التغييرات لا يمكن التراجع عنها.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
