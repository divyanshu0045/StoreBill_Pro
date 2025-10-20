import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storebill_pro_plus/providers/sales_provider.dart';
import 'package:storebill_pro_plus/screens/sale_form_screen.dart';
import 'package:storebill_pro_plus/widgets/transaction_card.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
      ),
      body: Consumer<SalesProvider>(
        builder: (context, provider, child) {
          if (provider.sales.isEmpty) {
            return const Center(child: Text('No sales recorded yet.'));
          }
          return ListView.builder(
            itemCount: provider.sales.length,
            itemBuilder: (context, index) {
              final sale = provider.sales[index];
              return TransactionCard(
                title: 'Invoice #${sale.invoiceId.substring(0, 8)}',
                subtitle: 'Customer: ${sale.customerName}',
                amount: sale.totalAmount,
                date: sale.date,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SaleFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
