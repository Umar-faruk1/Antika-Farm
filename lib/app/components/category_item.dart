import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../data/models/category_model.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback? onTap;
  const CategoryItem({
    Key? key,
    required this.category,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 37.r,
            backgroundColor: theme.cardColor,
            child: category.image.isNotEmpty
                ? Image.network(
                    category.image,
                    width: 48.w,
                    height: 48.w,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 32.w),
                  )
                : Image.network(
                    'https://via.placeholder.com/150',
                    width: 48.w,
                    height: 48.w,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 32.w),
                  ),
          ).animate().fade(duration: 200.ms),
          10.verticalSpace,
          Text(category.title, style: theme.textTheme.titleLarge)
            .animate().fade().slideY(
              duration: 200.ms,
              begin: 1,
              curve: Curves.easeInSine,
            ),
        ],
      ),
    );
  }
}