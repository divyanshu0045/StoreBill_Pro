import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:storebill_pro_plus/models/purchase_model.dart';
import 'package:storebill_pro_plus/models/invoice_item_model.dart';
import 'package:storebill_pro_plus/providers/product_provider.dart';
import 'package:uuid/uuid.dart';

class PurchaseProvider with ChangeNotifier {
  final Box<Purchase> _purchaseBox = Hive.box<Purchase>('purchases');
  final ProductProvider _productProvider;
  final _uuid = const Uuid();

  PurchaseProvider(this._productProvider);

  List<Purchase> get purchases => _purchaseBox.values.toList();

  void addPurchase({
    required String supplierName,
    required DateTime date,
    required List<InvoiceItem> items,
    required double totalAmount,
  }) {
    final newPurchase = Purchase(
      id: _uuid.v4(),
      supplierName: supplierName,
      date: date,
      items: items,
      totalAmount: totalAmount,
    );
    _purchaseBox.put(newPurchase.id, newPurchase);

    for (var item in items) {
      _productProvider.updateStock(item.productId, item.quantity);
    }

    notifyListeners();
  }

  void deletePurchase(String id) {
    final purchase = _purchaseBox.get(id);
    if (purchase != null) {
      for (var item in purchase.items) {
        _productProvider.updateStock(item.productId, -item.quantity);
      }
      _purchaseBox.delete(id);
      notifyListeners();
    }
  }
}
