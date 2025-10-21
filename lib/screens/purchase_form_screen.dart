import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:storebill_pro_plus/models/invoice_item_model.dart';
import 'package:storebill_pro_plus/models/product_model.dart';
import 'package:storebill_pro_plus/providers/product_provider.dart';
import 'package:storebill_pro_plus/providers/purchase_provider.dart';

class PurchaseFormScreen extends StatefulWidget {
  const PurchaseFormScreen({Key? key}) : super(key: key);

  @override
  PurchaseFormScreenState createState() => PurchaseFormScreenState();
}

class PurchaseFormScreenState extends State<PurchaseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _supplierName = '';
  DateTime _date = DateTime.now();
  final List<InvoiceItem> _items = [];

  void _addItem(Product product, int quantity) {
    setState(() {
      _items.add(InvoiceItem(
        productId: product.id,
        productName: product.name,
        quantity: quantity,
        price: product.purchasePrice,
      ));
    });
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final totalAmount = _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
      Provider.of<PurchaseProvider>(context, listen: false).addPurchase(
        supplierName: _supplierName,
        date: _date,
        items: _items,
        totalAmount: totalAmount,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Purchase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Supplier Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a supplier name' : null,
                onSaved: (value) => _supplierName = value!,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text('Date: ${DateFormat.yMMMd().format(_date)}'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _date = pickedDate;
                        });
                      }
                    },
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return ListTile(
                      title: Text(item.productName),
                      subtitle: Text('${item.quantity} x \$${item.price.toStringAsFixed(2)}'),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _showAddProductDialog();
                },
                child: const Text('Add Item'),
              ),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Save Purchase'),
              ),
            ],
          ),
        ),
      ),
    );
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
                _addItem(selectedProduct!, quantity);
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
