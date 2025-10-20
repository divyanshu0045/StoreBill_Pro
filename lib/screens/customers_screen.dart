import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storebill_pro_plus/providers/customer_provider.dart';
import 'package:storebill_pro_plus/screens/customer_details_screen.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
      ),
      body: Consumer<CustomerProvider>(
        builder: (context, provider, child) {
          if (provider.customers.isEmpty) {
            return const Center(child: Text('No customers found.'));
          }
          return ListView.builder(
            itemCount: provider.customers.length,
            itemBuilder: (context, index) {
              final customer = provider.customers[index];
              return ListTile(
                title: Text(customer.name),
                trailing: Text('Due: \$${customer.totalDue.toStringAsFixed(2)}'),
                onTap: () {
                  Navigator.pushNamed(context, '/customer_details',
                      arguments: customer);
                },
              );
            },
          );
        },
      ),
    );
  }
}
