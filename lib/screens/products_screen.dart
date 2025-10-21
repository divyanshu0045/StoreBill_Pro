import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storebill_pro_plus/providers/product_provider.dart';
import 'package:storebill_pro_plus/services/speech_service.dart';
import 'package:storebill_pro_plus/widgets/product_card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  ProductsScreenState createState() => ProductsScreenState();
}

class ProductsScreenState extends State<ProductsScreen> {
  final _speechService = SpeechService();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _speechService.init();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final filteredProducts = productProvider.products
        .where((product) =>
            product.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: Icon(_speechService.isListening ? Icons.mic : Icons.mic_none),
            onPressed: () {
              if (_speechService.isListening) {
                _speechService.stopListening();
              } else {
                _speechService.startListening((text) {
                  setState(() {
                    _searchQuery = text;
                  });
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, child) {
                if (filteredProducts.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }
                return ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return ProductCard(product: product);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/product_form');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
