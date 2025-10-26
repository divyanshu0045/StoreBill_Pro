import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:storebill_pro_plus/models/product_model.dart';
import 'package:storebill_pro_plus/providers/product_provider.dart';
import 'package:storebill_pro_plus/screens/product_form_screen.dart';
import 'package:storebill_pro_plus/services/ai_service.dart';

import 'product_form_screen_test.mocks.dart';

// Generate mocks for ProductProvider and AIService
@GenerateMocks([ProductProvider, AIService])
void main() {
  // Surface Flutter errors so we can see them in test output
  setUpAll(() {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      // ignore: avoid_print
      print('🔥 Flutter error during test: ${details.exception}');
    };
  });

  group('ProductFormScreen', () {
    late MockProductProvider mockProductProvider;
    late MockAIService mockAIService;

    setUp(() {
      mockProductProvider = MockProductProvider();
      mockAIService = MockAIService();

      // stub AI suggestion to avoid network calls
      when(mockAIService.suggestDescription(any, any))
          .thenAnswer((_) async => 'A great AI-generated description.');
    });

    Future<void> pumpScreen(WidgetTester tester, {Product? product}) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ProductProvider>.value(
              value: mockProductProvider,
            ),
            Provider<AIService>.value(
              value: mockAIService,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              // Constrain size to give ListView a finite viewport in test env
              body: SizedBox(
                height: 800,
                width: 400,
                child: ProductFormScreen(product: product),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('should show validation errors when fields are empty',
        (WidgetTester tester) async {
      await pumpScreen(tester);

      final saveButtonFinder = find.byKey(const Key('save_product_button'));

      // Should be present
      expect(saveButtonFinder, findsOneWidget);

      // Ensure it's visible
      await tester.ensureVisible(saveButtonFinder);

      // Tap save to trigger validation
      await tester.tap(saveButtonFinder);
      await tester.pumpAndSettle();

      // Check validation messages
      expect(find.text('Please enter a name'), findsOneWidget);
      expect(find.text('Please enter a category'), findsOneWidget);
      expect(find.text('Please enter a price'), findsNWidgets(2));
      expect(find.text('Please enter a quantity'), findsOneWidget);
      expect(find.text('Please enter a unit'), findsOneWidget);
    });

    testWidgets('should call addProduct when form is valid',
        (WidgetTester tester) async {
      await pumpScreen(tester);

      // Fill form fields using keys
      await tester.enterText(find.byKey(const Key('product_name_field')), 'Test Product');
      await tester.enterText(find.byKey(const Key('product_category_field')), 'Test Category');
      await tester.enterText(find.byKey(const Key('product_purchase_price_field')), '10.0');
      await tester.enterText(find.byKey(const Key('product_sale_price_field')), '20.0');
      await tester.enterText(find.byKey(const Key('product_stock_qty_field')), '100');
      await tester.enterText(find.byKey(const Key('product_unit_field')), 'pcs');
      await tester.enterText(find.byKey(const Key('product_description_field')), 'A great product');
      await tester.enterText(find.byKey(const Key('product_barcode_field')), '1234567890');

      // Ensure fields updated
      await tester.pumpAndSettle();

      final saveButtonFinder = find.byKey(const Key('save_product_button'));
      expect(saveButtonFinder, findsOneWidget);
      await tester.ensureVisible(saveButtonFinder);

      // Tap save
      await tester.tap(saveButtonFinder);
      await tester.pumpAndSettle();

      // Verify addProduct called with expected named args.
      verify(mockProductProvider.addProduct(
        name: 'Test Product',
        category: 'Test Category',
        purchasePrice: 10.0,
        salePrice: 20.0,
        stockQty: 100,
        unit: 'pcs',
        description: 'A great product',
        barcode: '1234567890',
      )).called(1);
    });
  });
}
