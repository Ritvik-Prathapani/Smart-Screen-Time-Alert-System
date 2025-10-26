import 'dart:async';
import 'package:flutter/material.dart';
import '../services/password_service.dart';
import 'lock_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;
  int _remainingSeconds = 0;
  Timer? _timer;
  bool _lockScreenShown = false;
  late final PasswordService _passwordService;

  @override
  void initState() {
    super.initState();
    _passwordService = PasswordService();
  }

  void _startTimer() {
    final totalSeconds = _hours * 3600 + _minutes * 60 + _seconds;
    if (totalSeconds <= 0) return;
    setState(() {
      _remainingSeconds = totalSeconds;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
        if (_remainingSeconds == 0) {
          _onTimerEnd();
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = 0;
    });
  }

  void _onTimerEnd() async {
    _timer?.cancel();
    if (!mounted || _lockScreenShown) return;
    setState(() {
      _lockScreenShown = true;
    });

    final password = await _passwordService.getPassword();
    if (password == null || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No password set! Please set one in settings.')),
      );
      setState(() {
        _lockScreenShown = false;
      });
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LockScreen(
          correctPassword: password,
          onUnlocked: () {
            Navigator.of(context).pop();
            setState(() {
              _lockScreenShown = false;
            });
          },
        ),
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    final hours = (totalSeconds ~/ 3600);
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:'
           '${minutes.toString().padLeft(2, '0')}:'
           '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _numberField(String label, int value, void Function(int) onChanged, {int max = 59}) {
    return Column(
      children: [
        Text(label),
        SizedBox(
          width: 60,
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [],
            decoration: InputDecoration(
              hintText: '00',
            ),
            onChanged: (val) {
              int v = int.tryParse(val) ?? 0;
              if (v < 0) v = 0;
              if (label == 'Hours' && v > 23) v = 23;
              if ((label == 'Minutes' || label == 'Seconds') && v > 59) v = 59;
              onChanged(v);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer Lock App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Set Timer:', style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _numberField('Hours', _hours, (v) => setState(() => _hours = v), max: 23),
                const SizedBox(width: 16),
                _numberField('Minutes', _minutes, (v) => setState(() => _minutes = v)),
                const SizedBox(width: 16),
                _numberField('Seconds', _seconds, (v) => setState(() => _seconds = v)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startTimer,
                  child: const Text('Start'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _stopTimer,
                  child: const Text('Stop'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              _remainingSeconds > 0
                  ? 'Time left: ${_formatTime(_remainingSeconds)}'
                  : 'Timer not running',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
