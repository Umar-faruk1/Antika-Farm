import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/category_model.dart';

class CategoryService {
  static final _collection = FirebaseFirestore.instance.collection('categories');

  static Future<List<CategoryModel>> fetchCategories() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) => CategoryModel.fromMap(doc.data(), doc.id)).toList();
  }

  static Future<void> addCategory(CategoryModel category) async {
    await _collection.add(category.toMap());
  }

  static Future<void> updateCategory(CategoryModel category) async {
    await _collection.doc(category.id).update(category.toMap());
  }

  static Future<void> deleteCategory(String id) async {
    await _collection.doc(id).delete();
  }
} 