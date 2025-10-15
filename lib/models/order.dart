// class OrderModel {
//   final String id;
//   final String fullName;
//   final String email;
//   final String state;
//   final String city;
//   final String locality;
//   final String productName;
//   final String category;
//   final int quantity;
//   final String productImage;
//   final String productPrice;
//   final String buyerId;
//   final String vendorId;
//   final String status;
//   final DateTime orderDate;

//   OrderModel({
//     required this.id,
//     required this.fullName,
//     required this.email,
//     required this.state,
//     required this.city,
//     required this.locality,
//     required this.productName,
//     required this.category,
//     required this.quantity,
//     required this.productImage,
//     required this.productPrice,
//     required this.buyerId,
//     required this.vendorId,
//     required this.status,
//     required this.orderDate,
//   });

//   factory OrderModel.fromJson(Map<String, dynamic> json) {
//     return OrderModel(
//       id: json['_id'] ?? '',
//       fullName: json['fullName'] ?? '',
//       email: json['email'] ?? '',
//       state: json['state'] ?? '',
//       city: json['city'] ?? '',
//       locality: json['locality'] ?? '',
//       productName: json['productName'] ?? '',
//       category: json['category'] ?? '',
//       quantity:
//           json['quantity'] is int
//               ? json['quantity']
//               : int.tryParse(json['quantity'].toString()) ?? 0,
//       productImage: json['productImage'] ?? '',
//       productPrice: json['productPrice'] ?? '0',
//       buyerId: json['buyerId'] ?? '',
//       vendorId: json['vendorId'] ?? '',
//       status: json['status'] ?? '',
//       orderDate:
//           json['orderDate'] != null
//               ? DateTime.parse(json['orderDate'])
//               : DateTime.now(),
//     );
//   }
// }

class OrderModel {
  final String id;
  final String fullName;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String productName;
  final String productId; // ✅ مضاف من الـ schema
  final String category;
  final int quantity;
  final String productImage;
  final String productPrice;
  final String buyerId;
  final String vendorId;
  final String status;
  final DateTime orderDate;

  OrderModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.state,
    required this.city,
    required this.locality,
    required this.productName,
    required this.productId, // ✅
    required this.category,
    required this.quantity,
    required this.productImage,
    required this.productPrice,
    required this.buyerId,
    required this.vendorId,
    required this.status,
    required this.orderDate,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      locality: json['locality'] ?? '',
      productName: json['productName'] ?? '',
      productId: json['productId'] ?? '', // ✅
      category: json['category'] ?? '',
      quantity:
          json['quantity'] is int
              ? json['quantity']
              : int.tryParse(json['quantity'].toString()) ?? 0,
      productImage: json['productImage'] ?? '',
      productPrice: json['productPrice'] ?? '0',
      buyerId: json['buyerId'] ?? '',
      vendorId: json['vendorId'] ?? '',
      status: json['status'] ?? '',
      orderDate:
          json['orderDate'] != null
              ? DateTime.parse(json['orderDate'])
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
      'state': state,
      'city': city,
      'locality': locality,
      'productName': productName,
      'productId': productId, // ✅
      'category': category,
      'quantity': quantity,
      'productImage': productImage,
      'productPrice': productPrice,
      'buyerId': buyerId,
      'vendorId': vendorId,
      'status': status,
      'orderDate': orderDate.toIso8601String(),
    };
  }
}
