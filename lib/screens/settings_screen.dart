import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storebill_pro_plus/providers/store_provider.dart';
import 'package:storebill_pro_plus/providers/theme_provider.dart';
import 'package:storebill_pro_plus/services/auth_service.dart';
import 'package:storebill_pro_plus/services/backup_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final _authService = AuthService();
  bool _isPinEnabled = false;
  late TextEditingController _storeNameController;
  late TextEditingController _storeIconController;

  @override
  void initState() {
    super.initState();
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    _storeNameController = TextEditingController(text: storeProvider.storeName);
    _storeIconController = TextEditingController(text: storeProvider.storeIconPath);
    _authService.hasPin().then((value) {
      setState(() {
        _isPinEnabled = value;
      });
    });
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeIconController.dispose();
    super.dispose();
  }

  void _togglePin(bool value) {
    if (value) {
      _showSetPinDialog();
    } else {
      _authService.clearPin();
      setState(() {
        _isPinEnabled = false;
      });
    }
  }

  void _showSetPinDialog() {
    final pinController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set PIN'),
        content: TextField(
          controller: pinController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Enter a 4-digit PIN'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (pinController.text.length == 4) {
                _authService.setPin(pinController.text);
                setState(() {
                  _isPinEnabled = true;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  void _saveStoreInfo() {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    storeProvider.setStoreName(_storeNameController.text);
    storeProvider.setStoreIcon(_storeIconController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Store information updated!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextField(
            controller: _storeNameController,
            decoration: const InputDecoration(labelText: 'Store Name'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _storeIconController,
            decoration: const InputDecoration(labelText: 'Store Icon Path'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveStoreInfo,
            child: const Text('Save Store Info'),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Enable Dark Mode'),
            value: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark,
            onChanged: (value) {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
          SwitchListTile(
            title: const Text('Enable PIN Lock'),
            value: _isPinEnabled,
            onChanged: _togglePin,
          ),
          const Divider(),
          ListTile(
            title: const Text('Backup Data'),
            leading: const Icon(Icons.backup),
            onTap: () async {
              final path = await BackupService.createBackup();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Backup created at $path')),
              );
            },
          ),
          ListTile(
            title: const Text('Restore Data'),
            leading: const Icon(Icons.restore),
            onTap: () async {
              final result = await FilePicker.platform.pickFiles();
              if (result != null) {
                await BackupService.restoreBackup(result.files.single.path!);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data restored successfully! Please restart the app.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
