import 'dart:io';

import 'package:csv/csv.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:storebill_pro_plus/providers/purchase_provider.dart';
import 'package:storebill_pro_plus/providers/sales_provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final salesProvider = Provider.of<SalesProvider>(context);
    final purchaseProvider = Provider.of<PurchaseProvider>(context);

    final totalSales =
        salesProvider.sales.fold(0.0, (sum, sale) => sum + sale.totalAmount);
    final totalPurchases = purchaseProvider.purchases
        .fold(0.0, (sum, purchase) => sum + purchase.totalAmount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Sales vs. Purchases',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (totalSales > totalPurchases ? totalSales : totalPurchases) * 1.2,
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: totalSales,
                          color: Colors.green,
                          width: 40,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: totalPurchases,
                          color: Colors.orange,
                          width: 40,
                        ),
                      ],
                    ),
                  ],
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('Sales');
                            case 1:
                              return const Text('Purchases');
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final sales = salesProvider.sales;
                final purchases = purchaseProvider.purchases;
                final List<List<dynamic>> rows = [];
                rows.add(['Type', 'Date', 'Amount']);
                for (final sale in sales) {
                  rows.add(['Sale', sale.date, sale.totalAmount]);
                }
                for (final purchase in purchases) {
                  rows.add(['Purchase', purchase.date, purchase.totalAmount]);
                }
                final csv = const ListToCsvConverter().convert(rows);
                final directory = await getApplicationDocumentsDirectory();
                final path = '${directory.path}/report.csv';
                final file = File(path);
                await file.writeAsString(csv);
                await Printing.sharePdf(bytes: await file.readAsBytes(), filename: 'report.csv');
              },
              child: const Text('Export Report'),
            ),
          ],
        ),
      ),
    );
  }
}
