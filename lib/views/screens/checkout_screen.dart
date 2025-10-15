import 'package:flutter/foundation.dart'; // لإضافة شرط kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/order_controller.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/payment_controller.dart';
import 'package:multivendor_ecommerce_riverpod/provider/cart_provider.dart';
import 'package:multivendor_ecommerce_riverpod/provider/shipping_address_provider.dart';
import 'package:multivendor_ecommerce_riverpod/provider/user_provider.dart'
    show userProvider;
import 'package:multivendor_ecommerce_riverpod/views/screens/shipping_address.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool _isProcessing = false;
  String _selectedPaymentMethod = 'cod';
  bool _hasShippingAddress = false;

  @override
  void initState() {
    super.initState();
    _initializeStripe();
    _checkShippingAddress();
  }

  Future<void> _initializeStripe() async {
    try {
      // Stripe لا يعمل على الويب، لذلك نتحقق أولاً
      if (!kIsWeb) {
        await PaymentService.initStripe();
      }
    } catch (e) {
      debugPrint('❌ Stripe Initialization Error: $e');
    }
  }

  Future<void> _checkShippingAddress() async {
    try {
      final address = ref.read(shippingAddressProvider);
      setState(() {
        _hasShippingAddress =
            address.state.isNotEmpty &&
            address.city.isNotEmpty &&
            address.locality.isNotEmpty;
      });
    } catch (e) {
      debugPrint('❌ Error checking shipping address: $e');
    }
  }

  Future<void> _processPayment() async {
    try {
      setState(() => _isProcessing = true);

      final user = ref.read(userProvider);
      final cartItems = ref.read(cartProvider);
      final cartController = ref.read(cartProvider.notifier);
      final shippingAddress = ref.read(shippingAddressProvider);

      // التحقق من تسجيل الدخول
      if (user == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('يجب تسجيل الدخول أولاً')));
        setState(() => _isProcessing = false);
        return;
      }

      // التحقق من وجود عنوان الشحن
      if (!_hasShippingAddress) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يجب إضافة عنوان الشحن أولاً')),
        );
        setState(() => _isProcessing = false);
        return;
      }

      // التحقق من أن السلة ليست فارغة
      if (cartItems.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('السلة فارغة، أضف منتجات أولاً')),
        );
        setState(() => _isProcessing = false);
        return;
      }

      final total = cartController.totalPrice;
      final tax = total * 0.14;
      final grandTotal = total + tax;

      // تحضير بيانات الطلب
      final orderData = {
        'fullName': user.fullname,
        'email': user.email,
        'state': shippingAddress.state,
        'city': shippingAddress.city,
        'locality': shippingAddress.locality,
        'productName': cartItems.first.name,
        'category': cartItems.first.category,
        'quantity': cartItems.fold(0, (sum, item) => sum + item.quantity),
        'productImage': cartItems.first.image,
        'productPrice': total.toStringAsFixed(2),
        'productId': cartItems.first.id,
        'buyerId': user.id,
        'vendorId': cartItems.first.vendorId,
        'paymentMethod': _selectedPaymentMethod,
        'subtotal': total.toStringAsFixed(2),
        'tax': tax.toStringAsFixed(2),
        'grandTotal': grandTotal.toStringAsFixed(2),
      };

      Map<String, dynamic>? result;

      if (_selectedPaymentMethod == 'card') {
        // Stripe فقط للموبايل
        if (!kIsWeb) {
          result = await PaymentService.processStripePayment(
            amount: grandTotal,
            currency: 'usd',
            orderDetails: {
              'orderId': 'ORD-${DateTime.now().millisecondsSinceEpoch}',
              ...orderData,
            },
          );
        } else {
          throw Exception('Stripe غير مدعوم على الويب');
        }
      } else {
        result = await PaymentService.processCashOnDelivery(
          orderData: orderData,
        );
      }

      if (!mounted) return;

      setState(() => _isProcessing = false);

      if (result!['success'] == true) {
        final orderSuccess = await OrderService.createOrder(orderData);

        if (orderSuccess) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result!['message'] ?? 'تم تأكيد الطلب بنجاح'),
            ),
          );
          ref.read(cartProvider.notifier).clearCart();
          if (mounted) Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('فشل في إنشاء الطلب')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result!['message'] ?? 'فشل في عملية الدفع')),
        );
      }
    } catch (e, s) {
      debugPrint('❌ Checkout Error: $e');
      debugPrintStack(stackTrace: s);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء إتمام الطلب: $e')));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _navigateToShippingAddress() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ShippingAddressDesignPage()),
    ).then((_) => _checkShippingAddress());
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final cartController = ref.read(cartProvider.notifier);
    final shippingAddress = ref.watch(shippingAddressProvider);
    final total = cartController.totalPrice;
    final tax = total * 0.14;
    final grandTotal = total + tax;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إتمام الشراء'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        // ✅ لف الصفحة لحل مشكلة RenderFlex overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // عنوان الشحن
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'عنوان التوصيل',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: _navigateToShippingAddress,
                            child: const Text('تغيير'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (_hasShippingAddress)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('المحافظة: ${shippingAddress.state}'),
                            Text('المدينة: ${shippingAddress.city}'),
                            Text('المنطقة: ${shippingAddress.locality}'),
                          ],
                        )
                      else
                        Column(
                          children: [
                            const Text(
                              'لم يتم إضافة عنوان الشحن بعد',
                              style: TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _navigateToShippingAddress,
                              child: const Text('إضافة عنوان الشحن'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // تفاصيل الطلب
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'ملخص الطلب',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('المجموع الفرعي'),
                          Text('${total.toStringAsFixed(2)} ج.م'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('الضريبة (14%)'),
                          Text('${tax.toStringAsFixed(2)} ج.م'),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'الإجمالي',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${grandTotal.toStringAsFixed(2)} ج.م',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // طرق الدفع
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'طريقة الدفع',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      RadioListTile(
                        title: const Text('الدفع عند الاستلام'),
                        value: 'cod',
                        groupValue: _selectedPaymentMethod,
                        onChanged:
                            (value) =>
                                setState(() => _selectedPaymentMethod = value!),
                      ),
                      RadioListTile(
                        title: const Text('بطاقة ائتمان'),
                        value: 'card',
                        groupValue: _selectedPaymentMethod,
                        onChanged:
                            (value) =>
                                setState(() => _selectedPaymentMethod = value!),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // زر التأكيد
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      (_isProcessing || !_hasShippingAddress)
                          ? null
                          : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _hasShippingAddress ? Colors.orange : Colors.grey,
                  ),
                  child:
                      _isProcessing
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                            _hasShippingAddress
                                ? 'تأكيد الطلب'
                                : 'أضف عنوان الشحن أولاً',
                            style: const TextStyle(fontSize: 18),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
