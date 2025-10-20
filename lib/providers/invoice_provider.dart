import 'package:flutter/material.dart';
import 'package:storebill_pro_plus/models/invoice_item_model.dart';
import 'package:storebill_pro_plus/models/product_model.dart';

class InvoiceProvider with ChangeNotifier {
  List<InvoiceItem> _items = [];
  double _discount = 0.0;
  double _tax = 0.0;

  List<InvoiceItem> get items => _items;
  double get discount => _discount;
  double get tax => _tax;

  double get subtotal =>
      _items.fold(0, (total, item) => total + (item.price * item.quantity));

  double get total => (subtotal - _discount) * (1 + _tax);

  void addItem(Product product, int quantity) {
    final existingItemIndex =
        _items.indexWhere((item) => item.productId == product.id);
    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity += quantity;
    } else {
      _items.add(InvoiceItem(
        productId: product.id,
        productName: product.name,
        quantity: quantity,
        price: product.salePrice,
      ));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  void setDiscount(double discount) {
    _discount = discount;
    notifyListeners();
  }

  void setTax(double tax) {
    _tax = tax;
    notifyListeners();
  }

  void clear() {
    _items = [];
    _discount = 0.0;
    _tax = 0.0;
    notifyListeners();
  }
}
