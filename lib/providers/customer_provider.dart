import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:storebill_pro_plus/models/customer_model.dart';
import 'package:uuid/uuid.dart';

class CustomerProvider with ChangeNotifier {
  final Box<Customer> _customerBox = Hive.box<Customer>('customers');
  final _uuid = const Uuid();

  List<Customer> get customers => _customerBox.values.toList();

  void addCustomer({
    required String name,
    String? phoneNumber,
    String? email,
    double totalDue = 0.0,
  }) {
    final newCustomer = Customer(
      id: _uuid.v4(),
      name: name,
      phoneNumber: phoneNumber,
      email: email,
      totalDue: totalDue,
    );
    _customerBox.put(newCustomer.id, newCustomer);
    notifyListeners();
  }

  Customer? getCustomerByName(String name) {
    try {
      return _customerBox.values.firstWhere((customer) => customer.name == name);
    } catch (e) {
      return null;
    }
  }

  void updateCustomerDue(String customerName, double amount) {
    final customer = getCustomerByName(customerName);
    if (customer != null) {
      customer.totalDue += amount;
      _customerBox.put(customer.id, customer);
      notifyListeners();
    } else {
      addCustomer(name: customerName, totalDue: amount);
    }
  }

  void markPaymentReceived(String customerId, double amount) {
    final customer = _customerBox.get(customerId);
    if (customer != null) {
      customer.totalDue -= amount;
      _customerBox.put(customer.id, customer);
      notifyListeners();
    }
  }
}
