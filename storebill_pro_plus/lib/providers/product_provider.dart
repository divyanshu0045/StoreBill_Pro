import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:storebill_pro_plus/models/product_model.dart';
import 'package:uuid/uuid.dart';

class ProductProvider with ChangeNotifier {
  late Box<Product> _productBox;
  final _uuid = Uuid();

  ProductProvider({Box<Product>? productBox}) {
    _productBox = productBox ?? Hive.box<Product>('products');
  }

  List<Product> get products => _productBox.values.toList();

  void addProduct({
    required String name,
    required String category,
    required double purchasePrice,
    required double salePrice,
    required int stockQty,
    required String unit,
    String? description,
  }) {
    final newProduct = Product(
      id: _uuid.v4(),
      name: name,
      category: category,
      purchasePrice: purchasePrice,
      salePrice: salePrice,
      stockQty: stockQty,
      unit: unit,
      description: description,
    );
    _productBox.put(newProduct.id, newProduct);
    notifyListeners();
  }

  void updateProduct(Product product) {
    _productBox.put(product.id, product);
    notifyListeners();
  }

  void deleteProduct(String id) {
    _productBox.delete(id);
    notifyListeners();
  }

  Product? getProductById(String id) {
    return _productBox.get(id);
  }

  void updateStock(String productId, int quantityChange) {
    final product = getProductById(productId);
    if (product != null) {
      product.stockQty += quantityChange;
      updateProduct(product);
    }
  }
}
