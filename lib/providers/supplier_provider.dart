import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:storebill_pro_plus/models/supplier_model.dart';
import 'package:uuid/uuid.dart';

class SupplierProvider with ChangeNotifier {
  final Box<Supplier> _supplierBox = Hive.box<Supplier>('suppliers');
  final _uuid = const Uuid();

  List<Supplier> get suppliers => _supplierBox.values.toList();

  void addSupplier({
    required String name,
    String? phoneNumber,
    String? email,
    String? address,
    double totalPayable = 0.0,
  }) {
    final newSupplier = Supplier(
      id: _uuid.v4(),
      name: name,
      phoneNumber: phoneNumber,
      email: email,
      address: address,
      totalPayable: totalPayable,
    );
    _supplierBox.put(newSupplier.id, newSupplier);
    notifyListeners();
  }

  Supplier? getSupplierByName(String name) {
    try {
      return _supplierBox.values.firstWhere((supplier) => supplier.name == name);
    } catch (e) {
      return null;
    }
  }

  void updateSupplierPayable(String supplierName, double amount) {
    final supplier = getSupplierByName(supplierName);
    if (supplier != null) {
      supplier.totalPayable += amount;
      _supplierBox.put(supplier.id, supplier);
      notifyListeners();
    } else {
      addSupplier(name: supplierName, totalPayable: amount);
    }
  }

  void markPaymentMade(String supplierId, double amount) {
    final supplier = _supplierBox.get(supplierId);
    if (supplier != null) {
      supplier.totalPayable -= amount;
      _supplierBox.put(supplier.id, supplier);
      notifyListeners();
    }
  }
}
