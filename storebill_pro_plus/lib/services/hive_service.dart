import 'package:hive_flutter/hive_flutter.dart';
import 'package:storebill_pro_plus/models/customer_model.dart';
import 'package:storebill_pro_plus/models/invoice_item_model.dart';
import 'package:storebill_pro_plus/models/product_model.dart';
import 'package:storebill_pro_plus/models/purchase_model.dart';
import 'package:storebill_pro_plus/models/sales_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(PurchaseAdapter());
    Hive.registerAdapter(SaleAdapter());
    Hive.registerAdapter(CustomerAdapter());
    Hive.registerAdapter(InvoiceItemAdapter());

    await Hive.openBox<Product>('products');
    await Hive.openBox<Purchase>('purchases');
    await Hive.openBox<Sale>('sales');
    await Hive.openBox<Customer>('customers');
  }
}
