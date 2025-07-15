class ProductModel {
  String id;
  String categoryId;
  String image;
  String name;
  String description;
  int quantity;
  double price;
  ProductModel({
    required this.id,
    required this.categoryId,
    required this.image,
    required this.name,
    required this.quantity,
    required this.price,
    required this.description
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProductModel(
      id: docId,
      categoryId: map['categoryId'] ?? '',
      image: map['image'] ?? '',
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'image': image,
      'name': name,
      'quantity': quantity,
      'price': price,
      'description': description,
    };
  }
}