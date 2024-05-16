import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 1)
class Product {
  Product(
      {required this.name,
      required this.category,
      required this.price,
      required this.quantity});
  @HiveField(0)
  String name;
  @HiveField(1)
  String category;
  @HiveField(2)
  int price;
  @HiveField(3)
  int quantity;

  // @HiveField(2)
  // List<Person> friends;
}
