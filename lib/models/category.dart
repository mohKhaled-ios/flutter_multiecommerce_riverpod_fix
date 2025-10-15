class CategoryModel {
  final String id;
  final String name;
  final String image;
  final String banner;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.banner,
    required this.createdAt,
    required this.updatedAt,
  });

  // تحويل من JSON إلى كائن Dart
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      banner: json['banner'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // تحويل من كائن Dart إلى JSON (مثلاً للإرسال إلى السيرفر)
  Map<String, dynamic> toJson() {
    return {'name': name, 'image': image, 'banner': banner};
  }
}
