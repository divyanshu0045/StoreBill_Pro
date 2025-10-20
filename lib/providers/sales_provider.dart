import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:storebill_pro_plus/models/sales_model.dart';
import 'package:storebill_pro_plus/providers/customer_provider.dart';
import 'package:storebill_pro_plus/providers/product_provider.dart';

class SalesProvider with ChangeNotifier {
  late Box<Sale> _salesBox;
  final ProductProvider _productProvider;
  final CustomerProvider _customerProvider;

  SalesProvider({
    required ProductProvider productProvider,
    required CustomerProvider customerProvider,
    Box<Sale>? salesBox,
  })  : _productProvider = productProvider,
        _customerProvider = customerProvider {
    _salesBox = salesBox ?? Hive.box<Sale>('sales');
  }

  List<Sale> get sales => _salesBox.values.toList();

  void addSale({required Sale sale}) {
    _salesBox.put(sale.invoiceId, sale);

    for (var item in sale.items) {
      _productProvider.updateStock(item.productId, -item.quantity);
    }

    _customerProvider.updateCustomerDue(sale.customerName, sale.balance);

    notifyListeners();
  }
}
