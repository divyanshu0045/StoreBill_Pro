import 'package:hive/hive.dart';
import 'invoice_item_model.dart';

part 'sales_model.g.dart';

@HiveType(typeId: 2)
class Sale extends HiveObject {
  @HiveField(0)
  String invoiceId;

  @HiveField(1)
  String customerName;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  List<InvoiceItem> items;

  @HiveField(4)
  double discount;

  @HiveField(5)
  double tax;

  @HiveField(6)
  double totalAmount;

  @HiveField(7)
  double amountPaid;

  @HiveField(8)
  double get balance => totalAmount - amountPaid;

  Sale({
    required this.invoiceId,
    required this.customerName,
    required this.date,
    required this.items,
    this.discount = 0.0,
    this.tax = 0.0,
    required this.totalAmount,
    required this.amountPaid,
  });
}
