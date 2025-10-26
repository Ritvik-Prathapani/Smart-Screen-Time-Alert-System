import 'package:flutter/material.dart';
import '../services/password_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _controller = TextEditingController();
  String? _message;

  void _savePassword() async {
    final password = _controller.text;
    if (password.isEmpty) {
      setState(() => _message = 'Password cannot be empty');
      return;
    }
    await PasswordService().setPassword(password);
    setState(() => _message = 'Password set!');
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Set new password'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _savePassword,
              child: const Text('Save Password'),
            ),
            if (_message != null) ...[
              const SizedBox(height: 16),
              Text(_message!, style: const TextStyle(color: Colors.green)),
            ]
          ],
        ),
      ),
    );
  }
}
