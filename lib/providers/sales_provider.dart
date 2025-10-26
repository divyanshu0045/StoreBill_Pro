import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:storebill_pro_plus/models/sales_model.dart';
import 'package:storebill_pro_plus/providers/customer_provider.dart';
import 'package:storebill_pro_plus/providers/product_provider.dart';

class SalesProvider with ChangeNotifier {
  late Box<Sale> _salesBox;
  final ProductProvider _productProvider;
  final CustomerProvider _customerProvider;
  int _invoiceNumber = 0;

  SalesProvider({
    required ProductProvider productProvider,
    required CustomerProvider customerProvider,
    Box<Sale>? salesBox,
  })  : _productProvider = productProvider,
        _customerProvider = customerProvider {
    _salesBox = salesBox ?? Hive.box<Sale>('sales');
    _loadInvoiceNumber();
  }

  Future<void> _loadInvoiceNumber() async {
    // In a real app, you'd want to persist this value
    _invoiceNumber = _salesBox.length;
  }

  List<Sale> get sales => _salesBox.values.toList();

  void addSale({required Sale sale}) {
    _invoiceNumber++;
    final year = DateTime.now().year;
    sale.invoiceId = 'INV-$year-${_invoiceNumber.toString().padLeft(4, '0')}';
    _salesBox.put(sale.invoiceId, sale);

    for (var item in sale.items) {
      _productProvider.updateStock(item.productId, -item.quantity);
    }

    _customerProvider.updateCustomerDue(sale.customerName, sale.balance);

    notifyListeners();
  }

  void deleteSale(String id) {
    final sale = _salesBox.get(id);
    if (sale != null) {
      for (var item in sale.items) {
        _productProvider.updateStock(item.productId, item.quantity);
      }
      _customerProvider.updateCustomerDue(sale.customerName, -sale.balance);
      _salesBox.delete(id);
      notifyListeners();
    }
  }
}
