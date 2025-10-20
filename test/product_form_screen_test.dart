import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:storebill_pro_plus/providers/product_provider.dart';
import 'package:storebill_pro_plus/screens/product_form_screen.dart';

class MockProductProvider extends Mock implements ProductProvider {}

void main() {
  group('ProductFormScreen', () {
    late MockProductProvider mockProductProvider;

    setUp(() {
      mockProductProvider = MockProductProvider();
    });

    testWidgets('should show validation errors when fields are empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ProductProvider>.value(
          value: mockProductProvider,
          child: MaterialApp(
            home: ProductFormScreen(),
          ),
        ),
      );

      await tester.tap(find.text('Save Product'));
      await tester.pump();

      expect(find.text('Please enter a name'), findsOneWidget);
      expect(find.text('Please enter a category'), findsOneWidget);
      expect(find.text('Please enter a price'), findsNWidgets(2));
      expect(find.text('Please enter a quantity'), findsOneWidget);
      expect(find.text('Please enter a unit'), findsOneWidget);
    });

    testWidgets('should call addProduct when form is valid',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ProductProvider>.value(
          value: mockProductProvider,
          child: MaterialApp(
            home: ProductFormScreen(),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'Test Product');
      await tester.enterText(find.byType(TextFormField).at(1), 'Test Category');
      await tester.enterText(find.byType(TextFormField).at(2), '10.0');
      await tester.enterText(find.byType(TextFormField).at(3), '20.0');
      await tester.enterText(find.byType(TextFormField).at(4), '100');
      await tester.enterText(find.byType(TextFormField).at(5), 'pcs');

      await tester.tap(find.text('Save Product'));
      await tester.pump();

      verify(mockProductProvider.addProduct(
        name: 'Test Product',
        category: 'Test Category',
        purchasePrice: 10.0,
        salePrice: 20.0,
        stockQty: 100,
        unit: 'pcs',
        description: anyNamed('description'),
      ));
    });
  });
}
