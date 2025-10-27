import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:storebill_pro_plus/models/expense_model.dart';
import 'package:storebill_pro_plus/providers/expense_provider.dart';
import 'package:hive/hive.dart';

import 'expense_provider_test.mocks.dart';

@GenerateMocks([Box])
void main() {
  group('ExpenseProvider', () {
    late ExpenseProvider expenseProvider;
    late MockBox<Expense> mockExpenseBox;

    setUp(() {
      mockExpenseBox = MockBox<Expense>();
      expenseProvider = ExpenseProvider(expenseBox: mockExpenseBox);
    });

    test('addExpense adds an expense to the box', () {
      expenseProvider.addExpense(
        category: 'Test Category',
        amount: 10.0,
        date: DateTime.now(),
      );

      verify(mockExpenseBox.put(any, any));
    });

    test('updateExpense updates an expense in the box', () {
      final expense = Expense(
        id: '1',
        category: 'Test Category',
        amount: 10.0,
        date: DateTime.now(),
      );

      expenseProvider.updateExpense(expense);

      verify(mockExpenseBox.put(expense.id, expense));
    });

    test('deleteExpense deletes an expense from the box', () {
      const expenseId = '1';
      expenseProvider.deleteExpense(expenseId);

      verify(mockExpenseBox.delete(expenseId));
    });
  });
}
