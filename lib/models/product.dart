class ProductModel {
  final String id;
  final String productName;
  final double productPrice;
  final int quantity;
  final String description;
  final String category;
  final String subcategory;
  final List<String> images;
  final bool popular;
  final bool recommend;
  final String vendorId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.vendorId,
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.description,
    required this.category,
    required this.subcategory,
    required this.images,
    required this.popular,
    required this.recommend,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      productName: json['productName'] ?? '',
      productPrice: (json['productPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 0,
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      subcategory: json['subcategory'] ?? '',
      images:
          json['images'] != null
              ? List<String>.from(json['images'])
              : <String>[],
      popular: json['popular'] ?? false,
      recommend: json['recommend'] ?? false,
      vendorId: json['vendorId'] ?? '',
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'])
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'description': description,
      'category': category,
      'subcategory': subcategory,
      'images': images,
      'popular': popular,
      'recommend': recommend,
      'vendorId': vendorId,
    };
  }
}
