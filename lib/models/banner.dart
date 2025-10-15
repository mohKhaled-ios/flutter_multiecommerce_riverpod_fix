class BannerModel {
  final String id;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;

  BannerModel({
    required this.id,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  // ✅ Factory لتحويل JSON إلى BannerModel
  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['_id'],
      image: json['image'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // ✅ لتحويل BannerModel إلى JSON (مثلاً للإرسال إلى السيرفر)
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      // لا ترسل _id أو timestamps عند الإنشاء عادة، إلا إذا كنت تعمل تحديث
    };
  }
}
