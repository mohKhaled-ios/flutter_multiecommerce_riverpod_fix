// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../provider/shipping_address_provider.dart';

// const Map<String, List<String>> statesToCities = {
//   'القاهرة': ['مدينة نصر', 'المعادي', 'الزمالك', 'مصر الجديدة'],
//   'الجيزة': ['الهرم', 'الشيخ زايد', 'الدقي'],
//   'الإسكندرية': ['سيدي جابر', 'محرم بك', 'ميامي'],
// };

// class ShippingAddressDesignPage extends ConsumerStatefulWidget {
//   const ShippingAddressDesignPage({super.key});

//   @override
//   ConsumerState<ShippingAddressDesignPage> createState() =>
//       _ShippingAddressDesignPageState();
// }

// class _ShippingAddressDesignPageState
//     extends ConsumerState<ShippingAddressDesignPage> {
//   String? _selectedState;
//   String? _selectedCity;
//   final TextEditingController _localityController = TextEditingController();

//   List<String> get _citiesForState {
//     if (_selectedState != null && statesToCities.containsKey(_selectedState)) {
//       return statesToCities[_selectedState]!;
//     }
//     return [];
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(shippingAddressProvider.notifier).load().then((_) {
//         final addr = ref.read(shippingAddressProvider);
//         setState(() {
//           _selectedState = addr.state.isNotEmpty ? addr.state : null;
//           _selectedCity = addr.city.isNotEmpty ? addr.city : null;
//           _localityController.text = addr.locality;
//         });
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _localityController.dispose();
//     super.dispose();
//   }

//   void _onSavePressed() async {
//   debugPrint('📌 Selected State: $_selectedState');
//   debugPrint('📌 Selected City: $_selectedCity');
//   debugPrint('📌 Locality: ${_localityController.text.trim()}');

//   if (_selectedState == null ||
//       _selectedCity == null ||
//       _localityController.text.trim().isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('رجاءً أكمل جميع الحقول')),
//     );
//     return;
//   }

//   final notifier = ref.read(shippingAddressProvider.notifier);
//   final success = await notifier.save(
//     stateStr: _selectedState!.trim(),
//     cityStr: _selectedCity!.trim(),
//     localityStr: _localityController.text.trim(),
//   );

//   if (success) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('تم حفظ عنوان الشحن بنجاح')),
//       );
//       Navigator.of(context).pop(true);
//     }
//   } else {
//     final error = ref.read(shippingAddressProvider).error;
//     debugPrint('❌ Backend Error: $error'); // ✅ أضف هذه السطر
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(error ?? 'فشل في حفظ العنوان')),
//       );
//     }
//   }
// }

//   /// حفظ العنوان
//   // void _onSavePressed() async {
//   //   if (_selectedState == null ||
//   //       _selectedCity == null ||
//   //       _localityController.text.trim().isEmpty) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(content: Text('رجاءً أكمل جميع الحقول')),
//   //     );
//   //     return;
//   //   }

//   //   final notifier = ref.read(shippingAddressProvider.notifier);
//   //   final success = await notifier.save(
//   //     stateStr: _selectedState!.trim(),
//   //     cityStr: _selectedCity!.trim(),
//   //     localityStr: _localityController.text.trim(),
//   //   );

//   //   if (success) {
//   //     if (mounted) {
//   //       // ✅ عرض رسالة نجاح
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         const SnackBar(content: Text('تم حفظ عنوان الشحن بنجاح')),
//   //       );

//   //       // ✅ إغلاق الصفحة وإرجاع true
//   //       Navigator.of(context).pop(true);
//   //     }
//   //   } else {
//   //     final error = ref.read(shippingAddressProvider).error;
//   //     if (mounted) {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(content: Text(error ?? 'فشل في حفظ العنوان')),
//   //       );
//   //     }
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final stateObj = ref.watch(shippingAddressProvider);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('عنوان التوصيل'),
//         backgroundColor: Colors.green,
//         elevation: 0,
//       ),
//       body: Container(
//         color: Colors.green.shade50,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//           child: Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             elevation: 4,
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'أضف عنوان التوصيل',
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 16),

//                   // State
//                   const Text(
//                     'المحافظة / الولاية',
//                     style: TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                   const SizedBox(height: 6),
//                   DropdownButtonFormField<String>(
//                     value: _selectedState,
//                     decoration: InputDecoration(
//                       hintText: 'اختر المحافظة',
//                       filled: true,
//                       fillColor: Colors.grey.shade100,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 14,
//                       ),
//                     ),
//                     items: statesToCities.keys
//                         .map(
//                           (s) => DropdownMenuItem(value: s, child: Text(s)),
//                         )
//                         .toList(),
//                     onChanged: (val) {
//                       setState(() {
//                         _selectedState = val;
//                         _selectedCity = null;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 16),

//                   // City
//                   const Text(
//                     'المدينة',
//                     style: TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                   const SizedBox(height: 6),
//                   DropdownButtonFormField<String>(
//                     value: _selectedCity,
//                     decoration: InputDecoration(
//                       hintText: 'اختر المدينة',
//                       filled: true,
//                       fillColor: Colors.grey.shade100,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 14,
//                       ),
//                     ),
//                     items: _citiesForState
//                         .map(
//                           (c) => DropdownMenuItem(value: c, child: Text(c)),
//                         )
//                         .toList(),
//                     onChanged: (val) {
//                       setState(() {
//                         _selectedCity = val;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 16),

//                   // Locality
//                   const Text(
//                     'المنطقة / الحي',
//                     style: TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                   const SizedBox(height: 6),
//                   TextField(
//                     controller: _localityController,
//                     decoration: InputDecoration(
//                       hintText: 'اكتب المنطقة أو الحي',
//                       filled: true,
//                       fillColor: Colors.grey.shade100,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 14,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 32),

//                   if (stateObj.isLoading)
//                     const Center(child: CircularProgressIndicator()),
//                   if (stateObj.error != null)
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 12),
//                       child: Text(
//                         stateObj.error!,
//                         style: const TextStyle(color: Colors.red),
//                       ),
//                     ),

//                   // زر الحفظ
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: stateObj.isLoading ? null : _onSavePressed,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.orange,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         textStyle: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       child: const Text('حفظ العنوان'),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'العنوان يتم حفظه في الباك إند وسيُحدّث بيانات المستخدم تلقائياً.',
//                     style: TextStyle(fontSize: 12, color: Colors.black54),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/shipping_address_provider.dart';

const Map<String, List<String>> statesToCities = {
  'القاهرة': ['مدينة نصر', 'المعادي', 'الزمالك', 'مصر الجديدة'],
  'الجيزة': ['الهرم', 'الشيخ زايد', 'الدقي'],
  'الإسكندرية': ['سيدي جابر', 'محرم بك', 'ميامي'],
};

class ShippingAddressDesignPage extends ConsumerStatefulWidget {
  const ShippingAddressDesignPage({super.key});

  @override
  ConsumerState<ShippingAddressDesignPage> createState() =>
      _ShippingAddressDesignPageState();
}

class _ShippingAddressDesignPageState
    extends ConsumerState<ShippingAddressDesignPage> {
  String? _selectedState;
  String? _selectedCity;
  final TextEditingController _localityController = TextEditingController();

  List<String> get _citiesForState {
    if (_selectedState != null && statesToCities.containsKey(_selectedState)) {
      return statesToCities[_selectedState]!;
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(shippingAddressProvider.notifier).load().then((_) {
        final addr = ref.read(shippingAddressProvider);
        setState(() {
          _selectedState = addr.state.isNotEmpty ? addr.state : null;
          _selectedCity = addr.city.isNotEmpty ? addr.city : null;
          _localityController.text = addr.locality;
        });
      });
    });
  }

  @override
  void dispose() {
    _localityController.dispose();
    super.dispose();
  }

  /// حفظ العنوان
  void _onSavePressed() async {
    if (_selectedState == null ||
        _selectedCity == null ||
        _localityController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('رجاءً أكمل جميع الحقول')));
      return;
    }

    final notifier = ref.read(shippingAddressProvider.notifier);
    final success = await notifier.save(
      stateStr: _selectedState!.trim(),
      cityStr: _selectedCity!.trim(),
      localityStr: _localityController.text.trim(),
    );

    if (success) {
      if (mounted) {
        // ✅ عرض رسالة نجاح
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ عنوان الشحن بنجاح')),
        );

        // ✅ إغلاق الصفحة وإرجاع true
        Navigator.of(context).pop(true);
      }
    } else {
      final error = ref.read(shippingAddressProvider).error;
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error ?? 'فشل في حفظ العنوان')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final stateObj = ref.watch(shippingAddressProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('عنوان التوصيل'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Container(
        color: Colors.green.shade50,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'أضف عنوان التوصيل',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // State
                  const Text(
                    'المحافظة / الولاية',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedState,
                    decoration: InputDecoration(
                      hintText: 'اختر المحافظة',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    items:
                        statesToCities.keys
                            .map(
                              (s) => DropdownMenuItem(value: s, child: Text(s)),
                            )
                            .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedState = val;
                        _selectedCity = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // City
                  const Text(
                    'المدينة',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCity,
                    decoration: InputDecoration(
                      hintText: 'اختر المدينة',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    items:
                        _citiesForState
                            .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)),
                            )
                            .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedCity = val;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Locality
                  const Text(
                    'المنطقة / الحي',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _localityController,
                    decoration: InputDecoration(
                      hintText: 'اكتب المنطقة أو الحي',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  if (stateObj.isLoading)
                    const Center(child: CircularProgressIndicator()),

                  if (stateObj.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        stateObj.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  // زر الحفظ
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: stateObj.isLoading ? null : _onSavePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('حفظ العنوان'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'العنوان يتم حفظه في الباك إند وسيُحدّث بيانات المستخدم تلقائياً.',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
