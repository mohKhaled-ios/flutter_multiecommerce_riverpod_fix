class SubCategoryModel {
  final String id;
  final String categoryId;
  final String categoryName;
  final String subCategoryName;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubCategoryModel({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.subCategoryName,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'],
      categoryId: json['categoryId'],
      categoryName: json['categoryname'],
      subCategoryName: json['subcategoryname'],
      image: json['image'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
