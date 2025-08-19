import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/category_service.dart';
import '../../data/models/category_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../data/storage_service.dart';

class AdminCategoriesView extends StatefulWidget {
  const AdminCategoriesView({Key? key}) : super(key: key);

  @override
  State<AdminCategoriesView> createState() => _AdminCategoriesViewState();
}

class _AdminCategoriesViewState extends State<AdminCategoriesView> {
  List<CategoryModel> _categories = [];
  bool _loading = true;

  // Persistent controller for category dialog
  final titleController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() => _loading = true);
    _categories = await CategoryService.fetchCategories();
    setState(() => _loading = false);
  }

  void _showCategoryDialog({CategoryModel? initial, int? editIndex}) {
    titleController.text = initial?.title ?? '';
    String? selectedImagePath = initial?.image;
    XFile? pickedImage;
    final ImagePicker _picker = ImagePicker();
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(initial == null ? 'Add Category' : 'Edit Category'),
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
                            child: selectedImagePath!.startsWith('http')
                                ? Image.network(
                                    selectedImagePath!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 120,
                                  )
                                : Image.file(
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
                  controller: titleController,
                  decoration: const InputDecoration(hintText: 'Category Title'),
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
                final title = titleController.text.trim();
                if (title.isNotEmpty) {
                  String imageUrl = selectedImagePath ?? '';
                  if (pickedImage != null) {
                    imageUrl = await StorageService.uploadFile(
                      File(pickedImage!.path),
                      'categories',
                    );
                  }
                  if (initial == null) {
                    await CategoryService.addCategory(CategoryModel(
                      id: '', // Firestore will assign
                      title: title,
                      image: imageUrl,
                    ));
                  } else {
                    await CategoryService.updateCategory(CategoryModel(
                      id: initial.id,
                      title: title,
                      image: imageUrl.isNotEmpty ? imageUrl : initial.image,
                    ));
                  }
                  await _fetchCategories();
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

  void _deleteCategory(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: const Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await CategoryService.deleteCategory(_categories[index].id);
              await _fetchCategories();
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
        title: Text('Manage Categories', style: theme.textTheme.displaySmall),
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
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        final category = _categories[index];
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
                                child: category.image.isNotEmpty
                                    ? Image.network(category.image, width: 32.w, height: 32.w, fit: BoxFit.contain)
                                    : Icon(Icons.image, size: 32.w),
                              ),
                              16.horizontalSpace,
                              Expanded(
                                child: Text(category.title, style: theme.textTheme.titleMedium),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: theme.primaryColor),
                                onPressed: () => _showCategoryDialog(initial: category, editIndex: index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteCategory(index),
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
                      onPressed: () => _showCategoryDialog(),
                      icon: Icon(Icons.add),
                      label: Text('Add Category'),
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