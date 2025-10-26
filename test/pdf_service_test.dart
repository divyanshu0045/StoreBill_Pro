import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:storebill_pro_plus/models/invoice_item_model.dart';
import 'package:storebill_pro_plus/models/sales_model.dart';
import 'package:storebill_pro_plus/providers/store_provider.dart';
import 'package:storebill_pro_plus/services/pdf_service.dart';
import 'package:uuid/uuid.dart';

import 'pdf_service_test.mocks.dart';

@GenerateMocks([StoreProvider])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PdfService', () {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('net.nfet.printing'),
            (MethodCall methodCall) async {
      if (methodCall.method == 'sharePdf') {
        return 1; // Return an int to satisfy the platform channel expectation
      }
      return null;
    });

    test('generateInvoice should run without errors', () async {
      final sale = Sale(
        invoiceId: const Uuid().v4(),
        customerName: 'Test Customer',
        date: DateTime.now(),
        items: [
          InvoiceItem(
            productId: '1',
            productName: 'Test Product',
            quantity: 2,
            price: 10.0,
          ),
        ],
        totalAmount: 20.0,
        amountPaid: 15.0,
      );
      final mockStoreProvider = MockStoreProvider();
      when(mockStoreProvider.storeName).thenReturn('Test Store');
      when(mockStoreProvider.storeAddress).thenReturn('123 Test St');
      when(mockStoreProvider.storeTerms).thenReturn('Test Terms');

      await expectLater(PdfService.shareInvoice(sale, mockStoreProvider), completes);
    });
  });
}
