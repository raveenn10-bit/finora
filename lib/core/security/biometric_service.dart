// ─────────────────────────────────────────────────────────
//  core/security/biometric_service.dart
//  Encapsulates all local_auth interactions.
//  Returns typed results; never throws to callers.
// ─────────────────────────────────────────────────────────
import 'package:local_auth/local_auth.dart';

enum BiometricResult { success, failed, unavailable, notEnrolled }

class BiometricService {
  BiometricService._();
  static final BiometricService instance = BiometricService._();

  final LocalAuthentication _auth = LocalAuthentication();

  /// Returns `true` if the device has *any* authentication mechanism
  /// (biometric or device credential such as PIN/pattern/password).
  Future<bool> isAvailable() async {
    try {
      return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  /// Returns `true` if at least one biometric is enrolled.
  Future<bool> hasEnrolledBiometrics() async {
    try {
      final list = await _auth.getAvailableBiometrics();
      return list.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Triggers the OS-level authentication prompt.
  /// [biometricOnly] = false  → allows PIN/pattern/password as fallback.
  Future<BiometricResult> authenticate({bool biometricOnly = false}) async {
    final available = await isAvailable();
    if (!available) return BiometricResult.unavailable;

    final enrolled = await hasEnrolledBiometrics();
    if (enrolled == false && biometricOnly) return BiometricResult.notEnrolled;

    try {
      final ok = await _auth.authenticate(
        localizedReason: 'Unlock Finora to access your financial data',
        options: AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: biometricOnly,
        ),
      );
      return ok ? BiometricResult.success : BiometricResult.failed;
    } catch (_) {
      return BiometricResult.failed;
    }
  }
}
