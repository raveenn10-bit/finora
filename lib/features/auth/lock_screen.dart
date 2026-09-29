// ─────────────────────────────────────────────────────────
//  features/auth/lock_screen.dart
//  Biometric gate with PIN fallback.
//  Unlocks session via Riverpod SessionNotifier.
// ─────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/security/biometric_service.dart';
import '../../core/security/session_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/widgets/brand_logo.dart';
import '../dashboard/home_screen.dart';
import 'pin_screen.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Auto-trigger biometrics after first frame renders.
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryBiometric());
  }

  Future<void> _tryBiometric() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await BiometricService.instance.authenticate();

    if (!mounted) return;

    switch (result) {
      case BiometricResult.success:
        ref.read(sessionProvider.notifier).unlock();
        _navigateHome();

      case BiometricResult.unavailable:
        setState(() {
          _error = 'Biometric authentication not available on this device.';
          _loading = false;
        });

      case BiometricResult.notEnrolled:
        setState(() {
          _error = 'No biometrics enrolled. Please use your PIN.';
          _loading = false;
        });

      case BiometricResult.failed:
        setState(() {
          _error = 'Authentication failed. Try again or use your PIN.';
          _loading = false;
        });
    }
  }

  void _navigateHome() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, a, __) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _openPin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PinScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 52),
              const BrandLogo(),
              const Spacer(),
              Text(
                'Welcome Back',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: kText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Authenticate to access Finora',
                style: GoogleFonts.plusJakartaSans(
                  color: kMuted,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: kError.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kError.withOpacity(0.35)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: kError, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _error!,
                          style: GoogleFonts.plusJakartaSans(
                            color: kError,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _tryBiometric,
                  icon: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: kNavy,
                          ),
                        )
                      : const Icon(Icons.fingerprint_rounded, size: 24),
                  label:
                      Text(_loading ? 'Verifying…' : 'Unlock with Biometrics'),
                ),
              ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: _openPin,
                child: Text(
                  'Use PIN instead',
                  style: GoogleFonts.plusJakartaSans(
                    color: kMuted,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    decorationColor: kMuted,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
