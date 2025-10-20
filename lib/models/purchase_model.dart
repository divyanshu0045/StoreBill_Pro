import 'package:hive/hive.dart';
import 'invoice_item_model.dart';

part 'purchase_model.g.dart';

@HiveType(typeId: 1)
class Purchase extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String supplierName;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  List<InvoiceItem> items;

  @HiveField(4)
  double totalAmount;

  Purchase({
    required this.id,
    required this.supplierName,
    required this.date,
    required this.items,
    required this.totalAmount,
  });
}
