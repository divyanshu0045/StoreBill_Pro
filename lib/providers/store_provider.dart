import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreProvider with ChangeNotifier {
  static const _storeNameKey = 'store_name';
  static const _storeIconKey = 'store_icon';
  static const _storeAddressKey = 'store_address';
  static const _storeTermsKey = 'store_terms';

  String _storeName = 'StoreBill Pro+';
  String? _storeIconPath;
  String _storeAddress = '123 Main St, Anytown, USA';
  String _storeTerms = 'Thanks for your business!';

  String get storeName => _storeName;
  String? get storeIconPath => _storeIconPath;
  String get storeAddress => _storeAddress;
  String get storeTerms => _storeTerms;

  StoreProvider() {
    _loadStoreInfo();
  }

  Future<void> _loadStoreInfo() async {
    final prefs = await SharedPreferences.getInstance();
    _storeName = prefs.getString(_storeNameKey) ?? 'StoreBill Pro+';
    _storeIconPath = prefs.getString(_storeIconKey);
    _storeAddress = prefs.getString(_storeAddressKey) ?? '123 Main St, Anytown, USA';
    _storeTerms = prefs.getString(_storeTermsKey) ?? 'Thanks for your business!';
    notifyListeners();
  }

  Future<void> setStoreName(String name) async {
    _storeName = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storeNameKey, name);
    notifyListeners();
  }

  Future<void> setStoreIcon(String path) async {
    _storeIconPath = path;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storeIconKey, path);
    notifyListeners();
  }

  Future<void> setStoreAddress(String address) async {
    _storeAddress = address;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storeAddressKey, address);
    notifyListeners();
  }

  Future<void> setStoreTerms(String terms) async {
    _storeTerms = terms;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storeTermsKey, terms);
    notifyListeners();
  }
}
