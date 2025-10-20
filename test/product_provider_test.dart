import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:storebill_pro_plus/models/product_model.dart';
import 'package:storebill_pro_plus/providers/product_provider.dart';
import 'package:hive/hive.dart';

import 'product_provider_test.mocks.dart';

@GenerateMocks([Box])
void main() {
  group('ProductProvider', () {
    late ProductProvider productProvider;
    late MockBox<Product> mockProductBox;

    setUp(() {
      mockProductBox = MockBox<Product>();
      productProvider = ProductProvider(productBox: mockProductBox);
    });

    test('addProduct adds a product to the box', () {
      productProvider.addProduct(
        name: 'Test Product',
        category: 'Test Category',
        purchasePrice: 10.0,
        salePrice: 20.0,
        stockQty: 100,
        unit: 'pcs',
      );

      verify(mockProductBox.put(any, any));
    });

    test('updateProduct updates a product in the box', () {
      final product = Product(
        id: '1',
        name: 'Test Product',
        category: 'Test Category',
        purchasePrice: 10.0,
        salePrice: 20.0,
        stockQty: 100,
        unit: 'pcs',
      );

      productProvider.updateProduct(product);

      verify(mockProductBox.put(product.id, product));
    });

    test('deleteProduct deletes a product from the box', () {
      const productId = '1';
      productProvider.deleteProduct(productId);

      verify(mockProductBox.delete(productId));
    });

    test('updateStock updates the stock of a product', () {
      final product = Product(
        id: '1',
        name: 'Test Product',
        category: 'Test Category',
        purchasePrice: 10.0,
        salePrice: 20.0,
        stockQty: 100,
        unit: 'pcs',
      );
      when(mockProductBox.get('1')).thenReturn(product);

      productProvider.updateStock('1', -10);

      expect(product.stockQty, 90);
      verify(mockProductBox.put('1', product));
    });
  });
}
