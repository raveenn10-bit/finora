// ─────────────────────────────────────────────────────────
//  core/security/pin_service.dart
//  Securely stores a 6-digit PIN hash using
//  flutter_secure_storage.  Used as biometric fallback.
// ─────────────────────────────────────────────────────────
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinService {
  PinService._();
  static final PinService instance = PinService._();

  static const _storage = FlutterSecureStorage();
  static const _key = 'finora_pin_hash';

  String _hash(String pin) =>
      sha256.convert(utf8.encode('finora_salt_$pin')).toString();

  Future<bool> hasPin() async => (await _storage.read(key: _key)) != null;

  Future<void> savePin(String pin) =>
      _storage.write(key: _key, value: _hash(pin));

  Future<bool> verifyPin(String pin) async {
    final stored = await _storage.read(key: _key);
    if (stored == null) return false;
    return stored == _hash(pin);
  }

  Future<void> clearPin() => _storage.delete(key: _key);
}
