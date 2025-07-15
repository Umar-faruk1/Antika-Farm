import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/product_model.dart';

class ProductService {
  static final _collection = FirebaseFirestore.instance.collection('products');

  static Future<List<ProductModel>> fetchProducts() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) => ProductModel.fromMap(doc.data(), doc.id)).toList();
  }

  static Future<void> addProduct(ProductModel product) async {
    await _collection.add(product.toMap());
  }

  static Future<void> updateProduct(ProductModel product) async {
    await _collection.doc(product.id).update(product.toMap());
  }

  static Future<void> deleteProduct(String id) async {
    await _collection.doc(id).delete();
  }
} 