import 'package:get/get.dart';

import '../../../../config/theme/my_theme.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/dummy_helper.dart';
import '../../../data/local/my_shared_pref.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/category_service.dart';
import '../../../data/product_service.dart';

class HomeController extends GetxController {

  // to hold categories & products
  List<CategoryModel> categories = [];
  List<ProductModel> products = [];

  // for app theme
  var isLightTheme = MySharedPref.getThemeIsLight();

  // for home screen cards
  var cards = [Constants.card1, Constants.card2, Constants.card3];

  @override
  void onInit() {
    getCategories();
    getProducts();
    super.onInit();
  }

  /// get categories from Firestore
  Future<void> getCategories() async {
    categories = await CategoryService.fetchCategories();
    update();
  }

  /// get products from Firestore
  Future<void> getProducts() async {
    products = await ProductService.fetchProducts();
    update();
  }

  /// when the user press on change theme icon
  onChangeThemePressed() {
    MyTheme.changeTheme();
    isLightTheme = MySharedPref.getThemeIsLight();
    update(['Theme']);
  }
  
}
