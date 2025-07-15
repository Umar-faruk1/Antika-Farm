import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/product_service.dart';
import '../../data/models/product_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../data/category_service.dart';
import '../../data/models/category_model.dart';

class AdminProductsView extends StatefulWidget {
  const AdminProductsView({Key? key}) : super(key: key);

  @override
  State<AdminProductsView> createState() => _AdminProductsViewState();
}

class _AdminProductsViewState extends State<AdminProductsView> {
  List<ProductModel> _products = [];
  List<CategoryModel> _categories = [];
  bool _loading = true;
  bool _loadingCategories = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _fetchCategories();
  }

  Future<void> _fetchProducts() async {
    setState(() => _loading = true);
    _products = await ProductService.fetchProducts();
    setState(() => _loading = false);
  }

  Future<void> _fetchCategories() async {
    setState(() => _loadingCategories = true);
    _categories = await CategoryService.fetchCategories();
    setState(() => _loadingCategories = false);
  }

  void _showProductDialog({ProductModel? initial, int? editIndex}) {
    final nameController = TextEditingController(text: initial?.name ?? '');
    final priceController = TextEditingController(text: initial?.price.toString() ?? '');
    final descController = TextEditingController(text: initial?.description ?? '');
    String selectedCategoryId = initial?.categoryId ?? (_categories.isNotEmpty ? _categories.first.id : '');
    String? selectedImagePath = initial?.image;
    XFile? pickedImage;
    final ImagePicker _picker = ImagePicker();
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(initial == null ? 'Add Product' : 'Edit Product'),
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
                DropdownButtonFormField<String>(
                  value: selectedCategoryId.isNotEmpty ? selectedCategoryId : null,
                  items: _categories.map((cat) => DropdownMenuItem(
                    value: cat.id,
                    child: Text(cat.title),
                  )).toList(),
                  onChanged: (val) => setDialogState(() => selectedCategoryId = val ?? ''),
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
              onPressed: () async {
                final name = nameController.text.trim();
                final price = double.tryParse(priceController.text.trim()) ?? 0.0;
                final desc = descController.text.trim();
                if (name.isNotEmpty && desc.isNotEmpty) {
                  if (initial == null) {
                    await ProductService.addProduct(ProductModel(
                      id: '', // Firestore will assign
                      categoryId: selectedCategoryId,
                      image: selectedImagePath ?? '',
                      name: name,
                      quantity: 0,
                      price: price,
                      description: desc,
                    ));
                  } else {
                    await ProductService.updateProduct(ProductModel(
                      id: initial.id,
                      categoryId: selectedCategoryId,
                      image: selectedImagePath ?? initial.image,
                      name: name,
                      quantity: initial.quantity,
                      price: price,
                      description: desc,
                    ));
                  }
                  await _fetchProducts();
                  Navigator.pop(context);
                }
              },
              child: Text(initial == null ? 'Add' : 'Save'),
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
            onPressed: () async {
              await ProductService.deleteProduct(_products[index].id);
              await _fetchProducts();
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
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: _products.length,
                      separatorBuilder: (_, __) => SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        final product = _products[index];
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
                                child: product.image.isNotEmpty
                                    ? Image.network(product.image, width: 32.w, height: 32.w, fit: BoxFit.contain)
                                    : Icon(Icons.image, size: 32.w),
                              ),
                              16.horizontalSpace,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product.name, style: theme.textTheme.titleMedium),
                                    4.verticalSpace,
                                    Text('Category: ${product.categoryId}', style: theme.textTheme.bodySmall),
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