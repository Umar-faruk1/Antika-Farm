import '../app/data/models/category_model.dart';
import '../app/data/models/product_model.dart';
import 'constants.dart';

class DummyHelper {
  const DummyHelper._();

  static const _description = 'Ginger is a flowering plant whose rhizome, ginger root or ginger, is widely used as a spice and a folk medicine.';

  static List<Map<String, String>> cards = [
    {'icon': Constants.lotus, 'title': '100%', 'subtitle': 'Organic'},
    {'icon': Constants.calendar, 'title': '1 Year', 'subtitle': 'Expiration'},
    {'icon': Constants.favourites, 'title': '4.8 (256)', 'subtitle': 'Reviews'},
    {'icon': Constants.matches, 'title': '80 kcal', 'subtitle': '100 Gram'},
  ];

  static List<CategoryModel> categories = [
    CategoryModel(id: '1', title: 'Fruits', image: Constants.apple),
    CategoryModel(id: '2', title: 'Vegetables', image: Constants.broccoli),
    CategoryModel(id: '3', title: 'Cheeses', image: Constants.cheese),
    CategoryModel(id: '4', title: 'Meat', image: Constants.meat),
    CategoryModel(id: '5', title: 'Grains', image: Constants.grains),
    CategoryModel(id: '6', title: 'Livestock', image: Constants.livestock),
    CategoryModel(id: '7', title: 'Equipments', image: Constants.equipments),
  ];

  static List<ProductModel> products = [
    ProductModel(
      id: '1',
      categoryId: '2',
      image: Constants.bellPepper,
      name: 'Bell Pepper Red',
      quantity: 0,
      price: 5.99,
      description: _description,
    ),
    ProductModel(
      id: '2',
      categoryId: '4',
      image: Constants.lambMeat,
      name: 'Lamb Meat',
      quantity: 0,
      price: 44.99,
      description: _description,
    ),
    ProductModel(
      id: '3',
      categoryId: '2',
      image: Constants.ginger,
      name: 'Arabic Ginger',
      quantity: 0,
      price: 4.99,
      description: _description,
    ),
    ProductModel(
      id: '4',
      categoryId: '2',
      image: Constants.cabbage,
      name: 'Fresh Lettuce',
      quantity: 0,
      price: 3.99,
      description: _description,
    ),
    ProductModel(
      id: '5',
      categoryId: '2',
      image: Constants.pumpkin,
      name: 'Butternut Squash',
      quantity: 0,
      price: 8.99,
      description: _description,
    ),
    ProductModel(
      id: '6',
      categoryId: '2',
      image: Constants.carrot,
      name: 'Organic Carrots',
      quantity: 0,
      price: 5.99,
      description: _description,
    ),
    ProductModel(
      id: '7',
      categoryId: '2',
      image: Constants.cauliflower,
      name: 'Fresh Broccoli',
      quantity: 0,
      price: 3.99,
      description: _description,
    ),
    ProductModel(
      id: '8',
      categoryId: '2',
      image: Constants.tomatoes,
      name: 'Cherry Tomato',
      quantity: 0,
      price: 5.99,
      description: _description,
    ),
    ProductModel(
      id: '9',
      categoryId: '2',
      image: Constants.spinach,
      name: 'Fresh Spinach',
      quantity: 0,
      price: 2.99,
      description: _description,
    ),
    // Grains
    ProductModel(
      id: '10',
      categoryId: '5',
      image: Constants.grains,
      name: 'Maize',
      quantity: 0,
      price: 1.99,
      description: 'High quality maize grains.',
    ),
    ProductModel(
      id: '11',
      categoryId: '5',
      image: Constants.cornIcon,
      name: 'Rice',
      quantity: 0,
      price: 2.49,
      description: 'Premium long grain rice.',
    ),
    // Livestock
    ProductModel(
      id: '12',
      categoryId: '6',
      image: Constants.lambMeat,
      name: 'Goat',
      quantity: 0,
      price: 120.00,
      description: 'Healthy live goat.',
    ),
    ProductModel(
      id: '13',
      categoryId: '6',
      image: Constants.lambMeat,
      name: 'Cow',
      quantity: 0,
      price: 500.00,
      description: 'Healthy live cow.',
    ),
    // Equipments
    ProductModel(
      id: '14',
      categoryId: '7',
      image: Constants.equipments,
      name: 'Watering Can',
      quantity: 0,
      price: 8.99,
      description: 'Durable plastic watering can.',
    ),
    ProductModel(
      id: '15',
      categoryId: '7',
      image: Constants.basketIcon,
      name: 'Hoe',
      quantity: 0,
      price: 6.50,
      description: 'Steel garden hoe.',
    ),
    // Fruits
    ProductModel(
      id: '16',
      categoryId: '1',
      image: Constants.apple,
      name: 'Red Apple',
      quantity: 0,
      price: 1.20,
      description: 'Fresh and juicy red apples.',
    ),
    ProductModel(
      id: '17',
      categoryId: '1',
      image: Constants.apple,
      name: 'Green Apple',
      quantity: 0,
      price: 1.10,
      description: 'Crisp green apples.',
    ),
    // Cheeses
    ProductModel(
      id: '18',
      categoryId: '3',
      image: Constants.cheese,
      name: 'Cheddar Cheese',
      quantity: 0,
      price: 3.99,
      description: 'Aged cheddar cheese block.',
    ),
    ProductModel(
      id: '19',
      categoryId: '3',
      image: Constants.cheese,
      name: 'Mozzarella Cheese',
      quantity: 0,
      price: 3.99,
      description: 'Soft mozzarella cheese.',
    ),
  ];
}