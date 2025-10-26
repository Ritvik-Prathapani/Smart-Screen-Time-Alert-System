import 'package:flutter/material.dart';

class LockScreen extends StatefulWidget {
  final String correctPassword;
  final VoidCallback onUnlocked;

  const LockScreen({
    Key? key,
    required this.correctPassword,
    required this.onUnlocked,
  }) : super(key: key);

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final _controller = TextEditingController();
  String? _error;

  void _checkPassword() {
    if (_controller.text == widget.correctPassword) {
      widget.onUnlocked();
    } else {
      setState(() {
        _error = 'Incorrect password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('App Locked', style: TextStyle(fontSize: 24)),
              TextField(
                controller: _controller,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Enter password',
                  errorText: _error,
                ),
                onSubmitted: (_) => _checkPassword(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _checkPassword,
                child: const Text('Unlock'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
