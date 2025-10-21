import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storebill_pro_plus/providers/theme_provider.dart';
import 'package:storebill_pro_plus/services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final _authService = AuthService();
  bool _isPinEnabled = false;

  @override
  void initState() {
    super.initState();
    _authService.hasPin().then((value) {
      setState(() {
        _isPinEnabled = value;
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
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
          ListTile(
            title: const Text('Backup & Restore'),
            subtitle: const Text('Coming soon'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('This feature is coming soon!')),
              );
            },
          ),
        ],
      ),
    );
  }
}
