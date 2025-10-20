import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storebill_pro_plus/models/product_model.dart';
import 'package:storebill_pro_plus/providers/product_provider.dart';
import 'package:storebill_pro_plus/services/ai_service.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _category;
  late double _purchasePrice;
  late double _salePrice;
  late int _stockQty;
  late String _unit;
  String? _description;
  final _descriptionController = TextEditingController();

  // API key should be loaded from a secure location, e.g., environment variables
  final _aiService = AIService(const String.fromEnvironment('GEMINI_API_KEY'));

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _name = widget.product!.name;
      _category = widget.product!.category;
      _purchasePrice = widget.product!.purchasePrice;
      _salePrice = widget.product!.salePrice;
      _stockQty = widget.product!.stockQty;
      _unit = widget.product!.unit;
      _description = widget.product!.description;
      _descriptionController.text = _description ?? '';
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final provider = Provider.of<ProductProvider>(context, listen: false);
      if (widget.product == null) {
        provider.addProduct(
          name: _name,
          category: _category,
          purchasePrice: _purchasePrice,
          salePrice: _salePrice,
          stockQty: _stockQty,
          unit: _unit,
          description: _description,
        );
      } else {
        final updatedProduct = Product(
          id: widget.product!.id,
          name: _name,
          category: _category,
          purchasePrice: _purchasePrice,
          salePrice: _salePrice,
          stockQty: _stockQty,
          unit: _unit,
          description: _description,
        );
        provider.updateProduct(updatedProduct);
      }
      Navigator.pop(context);
    }
  }

  void _suggestDescription() async {
    _formKey.currentState!.save();
    final description = await _aiService.suggestDescription(_name, _category);
    setState(() {
      _description = description;
      _descriptionController.text = description;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: widget.product?.name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: widget.product?.category,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) => value!.isEmpty ? 'Please enter a category' : null,
                onSaved: (value) => _category = value!,
              ),
              TextFormField(
                initialValue: widget.product?.purchasePrice.toString(),
                decoration: const InputDecoration(labelText: 'Purchase Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter a price' : null,
                onSaved: (value) => _purchasePrice = double.parse(value!),
              ),
              TextFormField(
                initialValue: widget.product?.salePrice.toString(),
                decoration: const InputDecoration(labelText: 'Sale Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter a price' : null,
                onSaved: (value) => _salePrice = double.parse(value!),
              ),
              TextFormField(
                initialValue: widget.product?.stockQty.toString(),
                decoration: const InputDecoration(labelText: 'Stock Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter a quantity' : null,
                onSaved: (value) => _stockQty = int.parse(value!),
              ),
              TextFormField(
                initialValue: widget.product?.unit,
                decoration: const InputDecoration(labelText: 'Unit (e.g., kg, pcs)'),
                validator: (value) => value!.isEmpty ? 'Please enter a unit' : null,
                onSaved: (value) => _unit = value!,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value,
              ),
              ElevatedButton(
                onPressed: _suggestDescription,
                child: const Text('Suggest Description'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Save Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
