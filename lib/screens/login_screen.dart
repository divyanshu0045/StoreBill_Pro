import 'package:flutter/material.dart';
import 'package:storebill_pro_plus/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  String _pin = '';

  void _onNumberPressed(String number) {
    setState(() {
      if (_pin.length < 4) {
        _pin += number;
      }
    });
  }

  void _onDeletePressed() {
    setState(() {
      if (_pin.isNotEmpty) {
        _pin = _pin.substring(0, _pin.length - 1);
      }
    });
  }

  void _verifyPin() async {
    final isValid = await _authService.verifyPin(_pin);
    if (isValid) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      setState(() {
        _pin = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid PIN')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter PIN'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _pin,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              children: List.generate(12, (index) {
                if (index == 9) {
                  return Container();
                }
                if (index == 10) {
                  return TextButton(
                    onPressed: () => _onNumberPressed('0'),
                    child: const Text('0'),
                  );
                }
                if (index == 11) {
                  return IconButton(
                    icon: const Icon(Icons.backspace),
                    onPressed: _onDeletePressed,
                  );
                }
                return TextButton(
                  onPressed: () => _onNumberPressed('${index + 1}'),
                  child: Text('${index + 1}'),
                );
              }),
            ),
          ),
          ElevatedButton(
            onPressed: _verifyPin,
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
