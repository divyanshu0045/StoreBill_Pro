import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:storebill_pro_plus/models/expense_model.dart';
import 'package:uuid/uuid.dart';

class ExpenseProvider with ChangeNotifier {
  late Box<Expense> _expenseBox;
  final _uuid = const Uuid();

  ExpenseProvider({Box<Expense>? expenseBox}) {
    _expenseBox = expenseBox ?? Hive.box<Expense>('expenses');
  }

  List<Expense> get expenses => _expenseBox.values.toList();

  void addExpense({
    required String category,
    required double amount,
    required DateTime date,
    String? note,
  }) {
    final newExpense = Expense(
      id: _uuid.v4(),
      category: category,
      amount: amount,
      date: date,
      note: note,
    );
    _expenseBox.put(newExpense.id, newExpense);
    notifyListeners();
  }

  void updateExpense(Expense expense) {
    _expenseBox.put(expense.id, expense);
    notifyListeners();
  }

  void deleteExpense(String id) {
    _expenseBox.delete(id);
    notifyListeners();
  }
}
