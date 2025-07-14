import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/dummy_helper.dart';
import '../../data/models/product_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AdminProductsView extends StatefulWidget {
  const AdminProductsView({Key? key}) : super(key: key);

  @override
  State<AdminProductsView> createState() => _AdminProductsViewState();
}

class _AdminProductsViewState extends State<AdminProductsView> {
  List<ProductModel> _products = List<ProductModel>.from(DummyHelper.products);
  
  List<ProductModel> get products => _products;

  void _showProductDialog({ProductModel? initial, int? editIndex}) {
    final nameController = TextEditingController(text: initial?.name ?? '');
    final priceController = TextEditingController(text: initial?.price.toString() ?? '');
    final descController = TextEditingController(text: initial?.description ?? '');
    int selectedCategoryId = initial?.categoryId ?? DummyHelper.categories.first.id;
    String? selectedImagePath = initial?.image;
    XFile? pickedImage;
    final ImagePicker _picker = ImagePicker();
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(editIndex == null ? 'Add Product' : 'Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image picker section
                GestureDetector(
                  onTap: () async {
                    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setDialogState(() {
                        pickedImage = image;
                        selectedImagePath = image.path;
                      });
                    }
                  },
                  child: Container(
                    width: 300,
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: selectedImagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(selectedImagePath!),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 120,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image, size: 40, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Tap to select image', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                  ),
                ),
                16.verticalSpace,
                // Removed the TextField for image asset path
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Product Name'),
                ),
                16.verticalSpace,
                DropdownButtonFormField<int>(
                  value: selectedCategoryId,
                  items: DummyHelper.categories.map((cat) => DropdownMenuItem(
                    value: cat.id,
                    child: Text(cat.title),
                  )).toList(),
                  onChanged: (val) => setDialogState(() => selectedCategoryId = val ?? selectedCategoryId),
                  decoration: const InputDecoration(hintText: 'Category'),
                ),
                16.verticalSpace,
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(hintText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                16.verticalSpace,
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(hintText: 'Description'),
                  minLines: 1,
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final price = double.tryParse(priceController.text.trim()) ?? 0.0;
                final desc = descController.text.trim();
                if (name.isNotEmpty && desc.isNotEmpty) {
                  setState(() {
                    if (editIndex == null) {
                      _products.add(ProductModel(
                        id: _products.length + 1,
                        categoryId: selectedCategoryId,
                        image: selectedImagePath ?? DummyHelper.categories.firstWhere((c) => c.id == selectedCategoryId).image,
                        name: name,
                        quantity: 0,
                        price: price,
                        description: desc,
                      ));
                    } else {
                      _products[editIndex!] = ProductModel(
                        id: _products[editIndex!].id,
                        categoryId: selectedCategoryId,
                        image: selectedImagePath ?? DummyHelper.categories.firstWhere((c) => c.id == selectedCategoryId).image,
                        name: name,
                        quantity: _products[editIndex!].quantity,
                        price: price,
                        description: desc,
                      );
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(editIndex == null ? 'Add' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteProduct(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _products.removeAt(index);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products', style: theme.textTheme.displaySmall),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: _products.length,
                separatorBuilder: (_, __) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final product = _products[index];
                  final category = DummyHelper.categories.firstWhere((c) => c.id == product.categoryId);
                  return Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: theme.primaryColor.withOpacity(0.1),
                          child: Image.asset(product.image, width: 32.w, height: 32.w, fit: BoxFit.contain),
                        ),
                        16.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.name, style: theme.textTheme.titleMedium),
                              4.verticalSpace,
                              Text('Category: ${category.title}', style: theme.textTheme.bodySmall),
                              4.verticalSpace,
                              Text('Price: \$${product.price.toStringAsFixed(2)}', style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: theme.primaryColor),
                          onPressed: () => _showProductDialog(initial: product, editIndex: index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteProduct(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            24.verticalSpace,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showProductDialog(),
                icon: Icon(Icons.add),
                label: Text('Add Product'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 