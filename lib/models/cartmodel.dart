// class CartItem {
//   final String id;
//   final String name;
//   final String image;
//   final double price;
//   int quantity;

//   CartItem({
//     required this.id,
//     required this.name,
//     required this.image,
//     required this.price,
//     this.quantity = 1,
//   });
// }

// class CartItem {
//   final String id;
//   final String name;
//   final String image; // يجب أن تكون base64
//   final double price;
//   int quantity;

//   CartItem({
//     required this.id,
//     required this.name,
//     required this.image,
//     required this.price,
//     this.quantity = 1,
//   });

//   factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
//     id: json['id'],
//     name: json['name'],
//     image: json['image'],
//     price: (json['price'] as num).toDouble(),
//     quantity: json['quantity'],
//   );

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'name': name,
//     'image': image,
//     'price': price,
//     'quantity': quantity,
//   };
// }
class CartItem {
  final String id;
  final String name;
  final String image; // يجب أن تكون base64
  final double price;
  int quantity;
  final String category; // ✅ مضاف جديد
  final String vendorId; // ✅ مضاف جديد

  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
    required this.category,
    required this.vendorId,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json['id'],
    name: json['name'],
    image: json['image'],
    price: (json['price'] as num).toDouble(),
    quantity: json['quantity'],
    category: json['category'],
    vendorId: json['vendorId'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'price': price,
    'quantity': quantity,
    'category': category,
    'vendorId': vendorId,
  };
}
