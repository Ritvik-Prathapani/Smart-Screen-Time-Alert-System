import 'dart:async';

class TimerService {
  Timer? _timer;
  int _seconds = 0;

  void start(int seconds, Function onEnd, {Function(int)? onTick}) {
    _seconds = seconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds--;
      if (onTick != null) onTick(_seconds);
      if (_seconds <= 0) {
        timer.cancel();
        onEnd();
      }
    });
  }

  void cancel() {
    _timer?.cancel();
  }
}
