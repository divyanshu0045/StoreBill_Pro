import 'package:flutter/material.dart';
import 'package:storebill_pro_plus/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(product.name),
        subtitle: Text(
            'Stock: ${product.stockQty} ${product.unit} - Price: \$${product.salePrice.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.pushNamed(context, '/product_form', arguments: product);
          },
        ),
      ),
    );
  }
}
