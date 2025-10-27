import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storebill_pro_plus/models/product_model.dart';
import 'package:storebill_pro_plus/providers/product_provider.dart';
import 'package:storebill_pro_plus/screens/barcode_scanner_screen.dart';
import 'package:storebill_pro_plus/services/ai_service.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  ProductFormScreenState createState() => ProductFormScreenState();
}

class ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name = '';
  late String _category = '';
  late double _purchasePrice = 0.0;
  late double _salePrice = 0.0;
  late int _stockQty = 0;
  late String _unit = '';
  String? _description;
  String? _barcode;
  final _descriptionController = TextEditingController();
  final _barcodeController = TextEditingController();

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
      _barcode = widget.product!.barcode;
      _descriptionController.text = _description ?? '';
      _barcodeController.text = _barcode ?? '';
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _barcodeController.dispose();
    super.dispose();
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
          barcode: _barcode,
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
          barcode: _barcode,
        );
        provider.updateProduct(updatedProduct);
      }
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  void _suggestDescription() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Use the AIService from the provider context (mocked in tests)
      final aiService = Provider.of<AIService>(context, listen: false);
      final description = await aiService.suggestDescription(_name, _category);
      setState(() {
        _description = description;
        _descriptionController.text = description;
      });
    }
  }

  Future<void> _scanBarcode() async {
    final barcodeValue = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
    );

    if (barcodeValue != null) {
      setState(() {
        _barcode = barcodeValue;
        _barcodeController.text = barcodeValue;
      });
    }
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
                key: const Key('product_name_field'),
                initialValue: widget.product?.name ?? '',
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                key: const Key('product_category_field'),
                initialValue: widget.product?.category ?? '',
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a category' : null,
                onSaved: (value) => _category = value!,
              ),
              TextFormField(
                key: const Key('product_purchase_price_field'),
                initialValue:
                    widget.product?.purchasePrice.toString() ?? '',
                decoration:
                    const InputDecoration(labelText: 'Purchase Price'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a price' : null,
                onSaved: (value) => _purchasePrice = double.parse(value!),
              ),
              TextFormField(
                key: const Key('product_sale_price_field'),
                initialValue: widget.product?.salePrice.toString() ?? '',
                decoration: const InputDecoration(labelText: 'Sale Price'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a price' : null,
                onSaved: (value) => _salePrice = double.parse(value!),
              ),
              TextFormField(
                key: const Key('product_stock_qty_field'),
                initialValue: widget.product?.stockQty.toString() ?? '',
                decoration:
                    const InputDecoration(labelText: 'Stock Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a quantity' : null,
                onSaved: (value) => _stockQty = int.parse(value!),
              ),
              TextFormField(
                key: const Key('product_unit_field'),
                initialValue: widget.product?.unit ?? '',
                decoration: const InputDecoration(
                    labelText: 'Unit (e.g., kg, pcs)'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a unit' : null,
                onSaved: (value) => _unit = value!,
              ),
              TextFormField(
                key: const Key('product_description_field'),
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value,
              ),
              TextFormField(
                key: const Key('product_barcode_field'),
                controller: _barcodeController,
                decoration: const InputDecoration(labelText: 'Barcode'),
                onSaved: (value) => _barcode = value,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                key: const Key('scan_barcode_button'),
                onPressed: _scanBarcode,
                child: const Text('Scan Barcode'),
              ),
              ElevatedButton(
                key: const Key('suggest_description_button'),
                onPressed: _suggestDescription,
                child: const Text('Suggest Description'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                key: const Key('save_product_button'),
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
