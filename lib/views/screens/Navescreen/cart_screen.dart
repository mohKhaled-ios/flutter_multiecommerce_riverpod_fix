// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:multivendor_ecommerce_riverbod/provider/cart_provider.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/checkout_screen.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/shipping_address.dart';

// import 'package:multivendor_ecommerce_riverbod/provider/shipping_address_provider.dart';

// class CartScreen extends ConsumerWidget {
//   const CartScreen({super.key});

//   Uint8List convertToBytes(String base64String) {
//     try {
//       if (base64String.isEmpty) return Uint8List(0);
//       return base64Decode(base64String);
//     } catch (_) {
//       return Uint8List(0);
//     }
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final cartItems = ref.watch(cartProvider);
//     final cartController = ref.read(cartProvider.notifier);
//     final total = cartController.totalPrice;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('سلة المشتريات'),
//         backgroundColor: Colors.green,
//       ),
//       body: cartItems.isEmpty
//           ? const Center(
//               child: Text('السلة فارغة', style: TextStyle(fontSize: 18)),
//             )
//           : Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: cartItems.length,
//                     itemBuilder: (_, index) {
//                       final item = cartItems[index];
//                       final imageBytes = convertToBytes(item.image);

//                       return Card(
//                         margin: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 6,
//                         ),
//                         child: ListTile(
//                           leading: ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: imageBytes.isNotEmpty
//                                 ? Image.memory(
//                                     imageBytes,
//                                     width: 60,
//                                     height: 60,
//                                     fit: BoxFit.cover,
//                                   )
//                                 : const Icon(
//                                     Icons.image_not_supported,
//                                     size: 60,
//                                   ),
//                           ),
//                           title: Text(
//                             item.name,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           subtitle: Text(
//                             'السعر: ${item.price} × ${item.quantity}',
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(
//                                 icon: const Icon(Icons.remove),
//                                 onPressed: () =>
//                                     cartController.decrementQuantity(item.id),
//                               ),
//                               Text('${item.quantity}'),
//                               IconButton(
//                                 icon: const Icon(Icons.add),
//                                 onPressed: () =>
//                                     cartController.incrementQuantity(item.id),
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.delete),
//                                 onPressed: () =>
//                                     cartController.removeFromCart(item.id),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         blurRadius: 8,
//                         color: Colors.black12,
//                         offset: Offset(0, -1),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Text(
//                         'الإجمالي: ${total.toStringAsFixed(2)} ج.م',
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       ElevatedButton(
//                         onPressed: () async {
//                           try {
//                             // فحص إذا كان هناك عنوان
//                             final address =
//                                 ref.read(shippingAddressProvider);

//                             if (address.state.isEmpty ||
//                                 address.city.isEmpty ||
//                                 address.locality.isEmpty) {
//                               // لو مفيش عنوان، نفتح صفحة إضافة عنوان
//                               final result = await Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) =>
//                                       const ShippingAddressDesignPage(),
//                                 ),
//                               );

//                               // لو تم الحفظ بنجاح
//                               if (result == true && context.mounted) {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => const CheckoutScreen(),
//                                   ),
//                                 );
//                               }
//                             } else {
//                               // لو فيه عنوان موجود، روح على صفحة الدفع مباشرة
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => const CheckoutScreen(),
//                                 ),
//                               );
//                             }
//                           } catch (e, s) {
//                             debugPrint('❌ Navigation Error: $e');
//                             debugPrintStack(stackTrace: s);
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.orange,
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                         ),
//                         child: const Text(
//                           'إتمام الشراء',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multivendor_ecommerce_riverpod/provider/cart_provider.dart';
import 'package:multivendor_ecommerce_riverpod/provider/shipping_address_provider.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/checkout_screen.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/shipping_address.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  Uint8List convertToBytes(String base64String) {
    try {
      if (base64String.isEmpty) return Uint8List(0);
      return base64Decode(base64String);
    } catch (_) {
      return Uint8List(0);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartController = ref.read(cartProvider.notifier);
    final total = cartController.totalPrice;
    final shippingAddress = ref.watch(shippingAddressProvider);

    final hasAddress =
        shippingAddress.state.isNotEmpty &&
        shippingAddress.city.isNotEmpty &&
        shippingAddress.locality.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة المشتريات'),
        backgroundColor: Colors.green,
      ),
      body:
          cartItems.isEmpty
              ? const Center(
                child: Text('السلة فارغة', style: TextStyle(fontSize: 18)),
              )
              : Column(
                children: [
                  if (!hasAddress)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ShippingAddressDesignPage(),
                            ),
                          );

                          if (result == true && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تم حفظ العنوان بنجاح'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text('إضافة عنوان الشحن'),
                      ),
                    ),
                  if (hasAddress)
                    Card(
                      margin: const EdgeInsets.all(12),
                      child: ListTile(
                        title: Text('المحافظة: ${shippingAddress.state}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('المدينة: ${shippingAddress.city}'),
                            Text('المنطقة: ${shippingAddress.locality}'),
                          ],
                        ),
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (_, index) {
                        final item = cartItems[index];
                        final imageBytes = convertToBytes(item.image);

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child:
                                  imageBytes.isNotEmpty
                                      ? Image.memory(
                                        imageBytes,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      )
                                      : const Icon(
                                        Icons.image_not_supported,
                                        size: 60,
                                      ),
                            ),
                            title: Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'السعر: ${item.price} × ${item.quantity}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed:
                                      () => cartController.decrementQuantity(
                                        item.id,
                                      ),
                                ),
                                Text('${item.quantity}'),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed:
                                      () => cartController.incrementQuantity(
                                        item.id,
                                      ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed:
                                      () => cartController.removeFromCart(
                                        item.id,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black12,
                          offset: Offset(0, -1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'الإجمالي: ${total.toStringAsFixed(2)} ج.م',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed:
                              hasAddress
                                  ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const CheckoutScreen(),
                                      ),
                                    );
                                  }
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                hasAddress ? Colors.orange : Colors.grey,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'إتمام الشراء',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
