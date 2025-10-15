import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';

import 'package:multivendor_ecommerce_riverpod/controllers/payment_controller.dart';

class PaymentHistoryScreen extends ConsumerStatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  ConsumerState<PaymentHistoryScreen> createState() =>
      _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends ConsumerState<PaymentHistoryScreen> {
  List<dynamic> _payments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPaymentHistory();
  }

  Future<void> _loadPaymentHistory() async {
    final payments = await PaymentService.getPaymentHistory();
    setState(() {
      _payments = payments ?? [];
      _isLoading = false;
    });
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'succeeded':
        return 'ناجح';
      case 'pending':
        return 'قيد المعالجة';
      case 'failed':
        return 'فاشل';
      case 'refunded':
        return 'تم الاسترداد';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'succeeded':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      case 'refunded':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تاريخ المدفوعات'),
        backgroundColor: Colors.green,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _payments.isEmpty
              ? Center(child: Text('لا توجد مدفوعات سابقة'))
              : RefreshIndicator(
                onRefresh: _loadPaymentHistory,
                child: ListView.builder(
                  itemCount: _payments.length,
                  itemBuilder: (context, index) {
                    final payment = _payments[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        leading: Icon(
                          Icons.payment,
                          color: _getStatusColor(payment['status']),
                        ),
                        title: Text(
                          '${payment['amount']} ${payment['currency']?.toUpperCase()}',
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الحالة: ${_getStatusText(payment['status'])}',
                            ),
                            Text(
                              'التاريخ: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(payment['createdAt']))}',
                            ),
                            if (payment['orderDetails'] != null)
                              Text(
                                'رقم الطلب: ${payment['orderDetails']['orderId']}',
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.receipt),
                          onPressed: () {
                            // عرض تفاصيل الفاتورة
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
