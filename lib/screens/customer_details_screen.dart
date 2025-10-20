import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storebill_pro_plus/models/customer_model.dart';
import 'package:storebill_pro_plus/providers/customer_provider.dart';
import 'package:storebill_pro_plus/providers/sales_provider.dart';
import 'package:storebill_pro_plus/widgets/transaction_card.dart';

class CustomerDetailsScreen extends StatelessWidget {
  final Customer customer;

  const CustomerDetailsScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final salesProvider = Provider.of<SalesProvider>(context);
    final customerSales = salesProvider.sales
        .where((sale) => sale.customerName == customer.name)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(customer.name),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Due: \$${customer.totalDue.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: customerSales.length,
              itemBuilder: (context, index) {
                final sale = customerSales[index];
                return TransactionCard(
                  title: 'Invoice #${sale.invoiceId.substring(0, 8)}',
                  subtitle: 'Items: ${sale.items.length}',
                  amount: sale.totalAmount,
                  date: sale.date,
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => _showMarkPaymentDialog(context),
            child: const Text('Mark Payment Received'),
          ),
        ],
      ),
    );
  }

  void _showMarkPaymentDialog(BuildContext context) {
    final amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark Payment Received'),
        content: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Amount'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final amount = double.parse(amountController.text);
              Provider.of<CustomerProvider>(context, listen: false)
                  .markPaymentReceived(customer.id, amount);
              Navigator.pop(context);
            },
            child: const Text('Mark'),
          ),
        ],
      ),
    );
  }
}
