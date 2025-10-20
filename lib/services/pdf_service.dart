import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:storebill_pro_plus/models/sales_model.dart';

class PdfService {
  static Future<void> shareInvoice(Sale sale) async {
    final pdf = await _generatePdf(sale);
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'invoice_${sale.invoiceId}.pdf');
  }

  static Future<void> saveInvoice(Sale sale) async {
    final pdf = await _generatePdf(sale);
    final directory = await getDownloadsDirectory();
    final path = '${directory!.path}/invoice_${sale.invoiceId}.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());
  }

  static Future<pw.Document> _generatePdf(Sale sale) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('StoreBill Pro+', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24)),
                  pw.Text('Invoice', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24)),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Invoice #: ${sale.invoiceId.length > 8 ? sale.invoiceId.substring(0, 8) : sale.invoiceId}'),
              pw.Text('Date: ${sale.date.toLocal()}'),
              pw.Text('Customer: ${sale.customerName}'),
              pw.SizedBox(height: 20),

              // Items table
              pw.TableHelper.fromTextArray(
                headers: ['Product', 'Quantity', 'Price', 'Total'],
                data: sale.items.map((item) {
                  return [
                    item.productName,
                    item.quantity.toString(),
                    '\$${item.price.toStringAsFixed(2)}',
                    '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                  ];
                }).toList(),
              ),
              pw.SizedBox(height: 20),

              // Totals
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Subtotal: \$${sale.items.fold(0.0, (sum, item) => sum + (item.price * item.quantity)).toStringAsFixed(2)}'),
                      pw.Text('Discount: \$${sale.discount.toStringAsFixed(2)}'),
                      pw.Text('Tax: \$${(sale.items.fold(0.0, (sum, item) => sum + (item.price * item.quantity)) * sale.tax).toStringAsFixed(2)}'),
                      pw.Text('Total: \$${sale.totalAmount.toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Amount Paid: \$${sale.amountPaid.toStringAsFixed(2)}'),
                      pw.Text('Balance Due: \$${sale.balance.toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }
}
