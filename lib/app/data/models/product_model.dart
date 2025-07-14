class ProductModel {
  int id;
  int categoryId;
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
}