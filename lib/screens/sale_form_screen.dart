import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storebill_pro_plus/models/product_model.dart';
import 'package:storebill_pro_plus/models/sales_model.dart';
import 'package:storebill_pro_plus/providers/invoice_provider.dart';
import 'package:storebill_pro_plus/providers/product_provider.dart';
import 'package:storebill_pro_plus/providers/sales_provider.dart';
import 'package:storebill_pro_plus/services/pdf_service.dart';
import 'package:uuid/uuid.dart';

class SaleFormScreen extends StatefulWidget {
  const SaleFormScreen({Key? key}) : super(key: key);

  @override
  SaleFormScreenState createState() => SaleFormScreenState();
}

class SaleFormScreenState extends State<SaleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _customerName = '';
  double _amountPaid = 0.0;
  Sale? _savedSale;

  @override
  Widget build(BuildContext context) {
    final invoiceProvider = Provider.of<InvoiceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Sale'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Customer Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a customer name' : null,
                onSaved: (value) => _customerName = value!,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: invoiceProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = invoiceProvider.items[index];
                    return ListTile(
                      title: Text(item.productName),
                      subtitle: Text('${item.quantity} x \$${item.price.toStringAsFixed(2)}'),
                    );
                  },
                ),
              ),
              Text('Subtotal: \$${invoiceProvider.subtotal.toStringAsFixed(2)}'),
              Text('Total: \$${invoiceProvider.total.toStringAsFixed(2)}'),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Amount Paid'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter an amount' : null,
                onSaved: (value) => _amountPaid = double.parse(value!),
              ),
              ElevatedButton(
                onPressed: () => _showAddProductDialog(),
                child: const Text('Add Item'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _saveForm,
                    child: const Text('Save Sale'),
                  ),
                  ElevatedButton(
                    onPressed: _savedSale == null ? null : _savePdf,
                    child: const Text('Save Invoice as PDF'),
                  ),
                  ElevatedButton(
                    onPressed: _savedSale == null ? null : _sharePdf,
                    child: const Text('Share Invoice'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final invoiceProvider = Provider.of<InvoiceProvider>(context, listen: false);
      final newSale = Sale(
        invoiceId: const Uuid().v4(),
        customerName: _customerName,
        date: DateTime.now(),
        items: invoiceProvider.items,
        discount: invoiceProvider.discount,
        tax: invoiceProvider.tax,
        totalAmount: invoiceProvider.total,
        amountPaid: _amountPaid,
      );
      Provider.of<SalesProvider>(context, listen: false).addSale(sale: newSale);
      setState(() {
        _savedSale = newSale;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sale saved successfully!')),
      );
    }
  }

  void _savePdf() {
    PdfService.saveInvoice(_savedSale!);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invoice saved to Downloads folder.')),
    );
  }

  void _sharePdf() {
    PdfService.shareInvoice(_savedSale!);
  }

  void _showAddProductDialog() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    Product? selectedProduct;
    int quantity = 1;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<Product>(
              hint: const Text('Select a product'),
              items: productProvider.products.map((product) {
                return DropdownMenuItem<Product>(
                  value: product,
                  child: Text(product.name),
                );
              }).toList(),
              onChanged: (product) => selectedProduct = product,
            ),
            TextFormField(
              initialValue: '1',
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              onChanged: (value) => quantity = int.parse(value),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (selectedProduct != null) {
                Provider.of<InvoiceProvider>(context, listen: false).addItem(selectedProduct!, quantity);
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
