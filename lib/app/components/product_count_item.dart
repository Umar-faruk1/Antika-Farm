import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';
import '../data/models/product_model.dart';
import '../modules/base/controllers/base_controller.dart';
import '../modules/cart/controllers/cart_controller.dart';
import 'custom_icon_button.dart';

class ProductCountItem extends StatelessWidget {
  final ProductModel product;
  const ProductCountItem({
    Key? key,
    required this.product
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final CartController cartController = Get.find<CartController>();
    return Row(
      children: [
        CustomIconButton(
          width: 36.w,
          height: 36.h,
          onPressed: () => cartController.decrementQuantity(product.id),
          icon: SvgPicture.asset(
            Constants.removeIcon,
            fit: BoxFit.none,
          ),
          backgroundColor: theme.cardColor,
        ),
        16.horizontalSpace,
        GetBuilder<CartController>(
          id: 'ProductQuantity_${product.id}',
          builder: (cartController) => Text(
            cartController.getQuantity(product.id).toString(),
            style: theme.textTheme.headlineMedium,
          ),
        ),
        16.horizontalSpace,
        CustomIconButton(
          width: 36.w,
          height: 36.h,
          onPressed: () => cartController.incrementQuantity(product.id),
          icon: SvgPicture.asset(
            Constants.addIcon,
            fit: BoxFit.none,
          ),
          backgroundColor: theme.primaryColor,
        ),
      ],
    );
  }
}