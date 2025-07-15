class CategoryModel {
  String id;
  String title;
  String image;

  CategoryModel({
    required this.id,
    required this.title,
    required this.image,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map, String docId) {
    return CategoryModel(
      id: docId,
      title: map['title'] ?? '',
      image: map['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
    };
  }
}