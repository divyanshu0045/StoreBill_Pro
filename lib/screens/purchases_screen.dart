import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storebill_pro_plus/providers/purchase_provider.dart';
import 'package:storebill_pro_plus/screens/purchase_form_screen.dart';

class PurchasesScreen extends StatelessWidget {
  const PurchasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchases'),
      ),
      body: Consumer<PurchaseProvider>(
        builder: (context, provider, child) {
          if (provider.purchases.isEmpty) {
            return const Center(child: Text('No purchases recorded yet.'));
          }
          return ListView.builder(
            itemCount: provider.purchases.length,
            itemBuilder: (context, index) {
              final purchase = provider.purchases[index];
              return ListTile(
                title: Text('Purchase from ${purchase.supplierName}'),
                subtitle: Text('Date: ${purchase.date.toLocal()}'),
                trailing: Text('\$${purchase.totalAmount.toStringAsFixed(2)}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PurchaseFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
