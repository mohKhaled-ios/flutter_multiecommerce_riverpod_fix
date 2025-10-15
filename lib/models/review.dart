// lib/models/review_model.dart
class ReviewModel {
  final String id;
  final String buyerId;
  final String email;
  final String fullName;
  final String productId;
  final double rating;
  final String review;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.buyerId,
    required this.email,
    required this.fullName,
    required this.productId,
    required this.rating,
    required this.review,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id'],
      buyerId: json['buryId'],
      email: json['email'],
      fullName: json['fullName'],
      productId: json['productId'],
      rating: (json['rating'] as num).toDouble(),
      review: json['review'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
