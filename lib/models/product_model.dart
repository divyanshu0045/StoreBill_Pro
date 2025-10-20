import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String category;

  @HiveField(3)
  double purchasePrice;

  @HiveField(4)
  double salePrice;

  @HiveField(5)
  int stockQty;

  @HiveField(6)
  String unit;

  @HiveField(7)
  String? description;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.purchasePrice,
    required this.salePrice,
    required this.stockQty,
    required this.unit,
    this.description,
  });
}
