import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storebill_pro_plus/models/customer_model.dart';
import 'package:storebill_pro_plus/models/product_model.dart';
import 'package:storebill_pro_plus/providers/customer_provider.dart';
import 'package:storebill_pro_plus/providers/invoice_provider.dart';
import 'package:storebill_pro_plus/providers/product_provider.dart';
import 'package:storebill_pro_plus/providers/purchase_provider.dart';
import 'package:storebill_pro_plus/providers/sales_provider.dart';
import 'package:storebill_pro_plus/providers/theme_provider.dart';
import 'package:storebill_pro_plus/screens/customer_details_screen.dart';
import 'package:storebill_pro_plus/screens/login_screen.dart';
import 'package:storebill_pro_plus/screens/main_screen.dart';
import 'package:storebill_pro_plus/screens/product_form_screen.dart';
import 'package:storebill_pro_plus/screens/purchase_form_screen.dart';
import 'package:storebill_pro_plus/screens/sale_form_screen.dart';
import 'package:storebill_pro_plus/screens/settings_screen.dart';
import 'package:storebill_pro_plus/services/auth_service.dart';
import 'package:storebill_pro_plus/services/hive_service.dart';
import 'package:storebill_pro_plus/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProxyProvider<ProductProvider, PurchaseProvider>(
          create: (context) => PurchaseProvider(context.read<ProductProvider>()),
          update: (_, productProvider, __) => PurchaseProvider(productProvider),
        ),
        ChangeNotifierProxyProvider2<ProductProvider, CustomerProvider, SalesProvider>(
          create: (context) => SalesProvider(
            productProvider: context.read<ProductProvider>(),
            customerProvider: context.read<CustomerProvider>(),
          ),
          update: (_, productProvider, customerProvider, __) => SalesProvider(
            productProvider: productProvider,
            customerProvider: customerProvider,
          ),
        ),
        ChangeNotifierProvider(create: (_) => InvoiceProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'StoreBill Pro+',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.themeMode,
            home: FutureBuilder<bool>(
              future: AuthService().hasPin(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }
                if (snapshot.data == true) {
                  return const LoginScreen();
                }
                return const MainScreen();
              },
            ),
            onGenerateRoute: (settings) {
              if (settings.name == '/product_form') {
                final product = settings.arguments as Product?;
                return MaterialPageRoute(
                  builder: (context) => ProductFormScreen(product: product),
                );
              }
              if (settings.name == '/customer_details') {
                final customer = settings.arguments as Customer;
                return MaterialPageRoute(
                  builder: (context) => CustomerDetailsScreen(customer: customer),
                );
              }
              return null;
            },
            routes: {
              '/main': (context) => const MainScreen(),
              '/login': (context) => const LoginScreen(),
              '/purchase_form': (context) => PurchaseFormScreen(),
              '/sale_form': (context) => SaleFormScreen(),
              '/settings': (context) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}
