import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storebill_pro_plus/providers/expense_provider.dart';
import 'package:storebill_pro_plus/providers/purchase_provider.dart';
import 'package:storebill_pro_plus/providers/sales_provider.dart';
import 'package:storebill_pro_plus/providers/store_provider.dart';
import 'package:storebill_pro_plus/services/ai_service.dart';
import 'package:storebill_pro_plus/widgets/summary_tile.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final salesProvider = Provider.of<SalesProvider>(context);
    final purchaseProvider = Provider.of<PurchaseProvider>(context);
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final storeProvider = Provider.of<StoreProvider>(context);

    final totalSales =
        salesProvider.sales.fold(0.0, (sum, sale) => sum + sale.totalAmount);
    final totalPurchases = purchaseProvider.purchases
        .fold(0.0, (sum, purchase) => sum + purchase.totalAmount);
    final totalExpenses =
        expenseProvider.expenses.fold(0.0, (sum, expense) => sum + expense.amount);
    final totalDues =
        salesProvider.sales.fold(0.0, (sum, sale) => sum + sale.balance);

    // This is a simplified profit calculation
    final totalProfit = totalSales - totalPurchases - totalExpenses;

    return Scaffold(
      appBar: AppBar(
        title: Text(storeProvider.storeName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (storeProvider.storeIconPath != null && storeProvider.storeIconPath!.isNotEmpty)
              Image.file(
                File(storeProvider.storeIconPath!),
                height: 100,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.store, size: 100),
              ),
            FutureBuilder<String>(
              future: AIService(const String.fromEnvironment('GEMINI_API_KEY'))
                  .getDashboardInsight(totalSales, totalPurchases),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Card(
                  color: Colors.blue.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(snapshot.data!),
                  ),
                );
              },
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  SummaryTile(
                    title: 'Total Sales',
                    value: '\$${totalSales.toStringAsFixed(2)}',
                    icon: Icons.point_of_sale,
                    color: Colors.green,
                  ),
                  SummaryTile(
                    title: 'Total Purchases',
                    value: '\$${totalPurchases.toStringAsFixed(2)}',
                    icon: Icons.shopping_cart,
                    color: Colors.orange,
                  ),
                  SummaryTile(
                    title: 'Total Expenses',
                    value: '\$${totalExpenses.toStringAsFixed(2)}',
                    icon: Icons.money_off,
                    color: Colors.purple,
                  ),
                  SummaryTile(
                    title: 'Total Profit',
                    value: '\$${totalProfit.toStringAsFixed(2)}',
                    icon: Icons.trending_up,
                    color: Colors.blue,
                  ),
                  SummaryTile(
                    title: 'Total Dues',
                    value: '\$${totalDues.toStringAsFixed(2)}',
                    icon: Icons.receipt,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/sale_form');
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Add Sale'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/purchase_form');
                  },
                  icon: const Icon(Icons.add_business),
                  label: const Text('Add Purchase'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
