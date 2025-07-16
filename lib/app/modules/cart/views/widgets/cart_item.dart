import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../components/product_count_item.dart';
import '../../../../data/models/product_model.dart';
import '../../controllers/cart_controller.dart' as cart;

class CartItem extends StatelessWidget {
  final cart.CartItem cartItem;
  const CartItem({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final product = cartItem.product;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            product.image.isNotEmpty ? product.image : 'https://via.placeholder.com/150',
            width: 50.w,
            height: 40.h,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 40.w),
          ),
          16.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name, style: theme.textTheme.headlineSmall),
              5.verticalSpace,
              Text(
                '1kg, 24${product.price}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          ProductCountItem(product: product),
        ],
      ),
    );
  }
}