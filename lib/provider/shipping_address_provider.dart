// // lib/provider/shipping_address_provider.dart
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:multivendor_ecommerce_riverbod/controllers/shipping_address_service.dart';
// import 'package:multivendor_ecommerce_riverbod/provider/user_provider.dart';

// class ShippingAddressState {
//   final String state;
//   final String city;
//   final String locality;
//   final bool isLoading;
//   final String? error;

//   ShippingAddressState({
//     required this.state,
//     required this.city,
//     required this.locality,
//     this.isLoading = false,
//     this.error,
//   });

//   ShippingAddressState copyWith({
//     String? state,
//     String? city,
//     String? locality,
//     bool? isLoading,
//     String? error,
//   }) {
//     return ShippingAddressState(
//       state: state ?? this.state,
//       city: city ?? this.city,
//       locality: locality ?? this.locality,
//       isLoading: isLoading ?? this.isLoading,
//       error: error,
//     );
//   }
// }

// final shippingAddressProvider =
//     StateNotifierProvider<ShippingAddressNotifier, ShippingAddressState>(
//       (ref) => ShippingAddressNotifier(ref),
//     );

// class ShippingAddressNotifier extends StateNotifier<ShippingAddressState> {
//   final Ref ref;
//   final _service = ShippingAddressService();

//   ShippingAddressNotifier(this.ref)
//     : super(ShippingAddressState(state: '', city: '', locality: ''));

//   Future<void> load() async {
//     final user = ref.read(userProvider);
//     if (user == null || user.token.isEmpty) return;
//     state = state.copyWith(isLoading: true, error: null);
//     try {
//       final addr = await _service.fetchAddress(token: user.token);
//       if (addr != null) {
//         state = ShippingAddressState(
//           state: addr['state']!,
//           city: addr['city']!,
//           locality: addr['locality']!,
//           isLoading: false,
//         );
//         // عكس في userProvider
//         _updateUserProviderWithAddress(
//           addr['state']!,
//           addr['city']!,
//           addr['locality']!,
//         );
//       } else {
//         state = state.copyWith(isLoading: false, error: 'فشل في جلب العنوان');
//       }
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }

//   Future<bool> save({
//     required String stateStr,
//     required String cityStr,
//     required String localityStr,
//   }) async {
//     final user = ref.read(userProvider);
//     if (user == null || user.token.isEmpty) return false;
//     state = state.copyWith(isLoading: true, error: null);
//     try {
//       final ok = await _service.updateAddress(
//         token: user.token,
//         state: stateStr,
//         city: cityStr,
//         locality: localityStr,
//       );
//       if (ok) {
//         state = ShippingAddressState(
//           state: stateStr,
//           city: cityStr,
//           locality: localityStr,
//           isLoading: false,
//         );
//         _updateUserProviderWithAddress(stateStr, cityStr, localityStr);
//         return true;
//       } else {
//         state = state.copyWith(isLoading: false, error: 'فشل تحديث العنوان');
//         return false;
//       }
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//       return false;
//     }
//   }

//   void _updateUserProviderWithAddress(
//     String stateStr,
//     String cityStr,
//     String localityStr,
//   ) {
//     final current = ref.read(userProvider);
//     if (current != null) {
//       final updatedMap = {
//         'token': current.token,
//         '_id': current.id,
//         'fullname': current.fullname,
//         'email': current.email,
//         'state': stateStr,
//         'city': cityStr,
//         'locality': localityStr,
//         'password': '',
//       };
//       ref.read(userProvider.notifier).setUser(updatedMap);
//     }
//   }
// }
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/shipping_address_service.dart';

import '../provider/user_provider.dart';

class ShippingAddressState {
  final String state;
  final String city;
  final String locality;
  final bool isLoading;
  final String? error;

  ShippingAddressState({
    this.state = '',
    this.city = '',
    this.locality = '',
    this.isLoading = false,
    this.error,
  });

  ShippingAddressState copyWith({
    String? state,
    String? city,
    String? locality,
    bool? isLoading,
    String? error,
  }) {
    return ShippingAddressState(
      state: state ?? this.state,
      city: city ?? this.city,
      locality: locality ?? this.locality,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ShippingAddressNotifier extends StateNotifier<ShippingAddressState> {
  final Ref ref;
  final ShippingAddressService _service = ShippingAddressService();

  ShippingAddressNotifier(this.ref) : super(ShippingAddressState());

  Future<void> load() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final user = ref.read(userProvider);
      if (user == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'يجب تسجيل الدخول أولاً',
        );
        return;
      }

      final address = await _service.fetchAddress(token: user.token);
      if (address != null) {
        state = state.copyWith(
          state: address['state'] ?? '',
          city: address['city'] ?? '',
          locality: address['locality'] ?? '',
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false, error: 'فشل في جلب العنوان');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'حدث خطأ أثناء جلب العنوان',
      );
    }
  }

  Future<bool> save({
    required String stateStr,
    required String cityStr,
    required String localityStr,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final user = ref.read(userProvider);
      if (user == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'يجب تسجيل الدخول أولاً',
        );
        return false;
      }

      final success = await _service.updateAddress(
        token: user.token,
        state: stateStr,
        city: cityStr,
        locality: localityStr,
      );

      if (success) {
        state = state.copyWith(
          state: stateStr,
          city: cityStr,
          locality: localityStr,
          isLoading: false,
        );
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: 'فشل في حفظ العنوان');
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'حدث خطأ أثناء حفظ العنوان',
      );
      return false;
    }
  }
}

final shippingAddressProvider =
    StateNotifierProvider<ShippingAddressNotifier, ShippingAddressState>((ref) {
      return ShippingAddressNotifier(ref);
    });
