import 'package:hive/hive.dart';

part 'invoice_item_model.g.dart';

@HiveType(typeId: 4)
class InvoiceItem extends HiveObject {
  @HiveField(0)
  String productId;

  @HiveField(1)
  String productName;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  double price;

  InvoiceItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });
}
