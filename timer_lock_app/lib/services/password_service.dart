import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PasswordService {
  static const _key = 'app_password';
  final _storage = const FlutterSecureStorage();

  Future<void> setPassword(String password) async {
    await _storage.write(key: _key, value: password);
  }

  Future<String?> getPassword() async {
    return await _storage.read(key: _key);
  }
}
