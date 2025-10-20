import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:storebill_pro_plus/models/invoice_item_model.dart';
import 'package:storebill_pro_plus/models/sales_model.dart';
import 'package:storebill_pro_plus/providers/customer_provider.dart';
import 'package:storebill_pro_plus/providers/product_provider.dart';
import 'package:storebill_pro_plus/providers/sales_provider.dart';
import 'package:hive/hive.dart';

import 'sales_provider_test.mocks.dart';

@GenerateMocks([Box, ProductProvider, CustomerProvider])
void main() {
  group('SalesProvider', () {
    late SalesProvider salesProvider;
    late MockBox<Sale> mockSalesBox;
    late MockProductProvider mockProductProvider;
    late MockCustomerProvider mockCustomerProvider;

    setUp(() {
      mockSalesBox = MockBox<Sale>();
      mockProductProvider = MockProductProvider();
      mockCustomerProvider = MockCustomerProvider();
      salesProvider = SalesProvider(
        salesBox: mockSalesBox,
        productProvider: mockProductProvider,
        customerProvider: mockCustomerProvider,
      );
    });

    test('addSale adds a sale to the box and updates stock and customer due',
        () {
      final sale = Sale(
        invoiceId: '1',
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

      salesProvider.addSale(sale: sale);

      verify(mockSalesBox.put(sale.invoiceId, sale));
      verify(mockProductProvider.updateStock('1', -2));
      verify(mockCustomerProvider.updateCustomerDue('Test Customer', 5.0));
    });
  });
}
