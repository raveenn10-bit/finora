// ─────────────────────────────────────────────────────────
//  features/auth/pin_screen.dart
//  6-digit PIN entry — biometric fallback.
//  Uses flutter_secure_storage via PinService.
// ─────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/security/pin_service.dart';
import '../../core/security/session_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/widgets/brand_logo.dart';
import '../dashboard/home_screen.dart';

class PinScreen extends ConsumerStatefulWidget {
  const PinScreen({super.key});

  @override
  ConsumerState<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<PinScreen> {
  final List<int> _digits = [];
  bool _error = false;
  bool _isSetupMode = false;
  List<int>? _firstEntry; // for confirm step during setup

  @override
  void initState() {
    super.initState();
    PinService.instance.hasPin().then((has) {
      if (mounted) setState(() => _isSetupMode = !has);
    });
  }

  void _onDigit(int d) {
    if (_digits.length >= 6) return;
    setState(() {
      _digits.add(d);
      _error = false;
    });
    if (_digits.length == 6) _submit();
  }

  void _onDelete() {
    if (_digits.isEmpty) return;
    setState(() => _digits.removeLast());
  }

  Future<void> _submit() async {
    final pin = _digits.join();

    if (_isSetupMode) {
      if (_firstEntry == null) {
        // First entry — store temporarily and ask to confirm.
        setState(() {
          _firstEntry = List.from(_digits);
          _digits.clear();
        });
        return;
      }
      // Confirm step.
      if (_digits.join() == _firstEntry!.join()) {
        await PinService.instance.savePin(pin);
        if (!mounted) return;
        ref.read(sessionProvider.notifier).unlock();
        _navigateHome();
      } else {
        setState(() {
          _digits.clear();
          _firstEntry = null;
          _error = true;
        });
      }
      return;
    }

    // Verify existing PIN.
    final ok = await PinService.instance.verifyPin(pin);
    if (!mounted) return;
    if (ok) {
      ref.read(sessionProvider.notifier).unlock();
      _navigateHome();
    } else {
      setState(() {
        _digits.clear();
        _error = true;
      });
    }
  }

  void _navigateHome() {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (_, a, __) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
      (_) => false,
    );
  }

  String get _headline {
    if (_isSetupMode) {
      return _firstEntry == null ? 'Create a PIN' : 'Confirm your PIN';
    }
    return 'Enter your PIN';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const BrandLogo(size: 72),
              const SizedBox(height: 36),
              Text(
                _headline,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: kText,
                ),
              ),
              const SizedBox(height: 8),
              AnimatedOpacity(
                opacity: _error ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  'Incorrect PIN. Try again.',
                  style: GoogleFonts.plusJakartaSans(
                    color: kError,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // ── Dot indicators ──────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (i) {
                  final filled = i < _digits.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _error
                          ? kError
                          : filled
                              ? kMint
                              : kBorder,
                      boxShadow: filled && !_error
                          ? [
                              BoxShadow(
                                color: kMint.withOpacity(0.45),
                                blurRadius: 8,
                              )
                            ]
                          : null,
                    ),
                  );
                }),
              ),
              const Spacer(),
              // ── Keypad ──────────────────────────────────
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                childAspectRatio: 1.5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  ...List.generate(
                      9,
                      (i) => _PinKey(
                          label: '${i + 1}', onTap: () => _onDigit(i + 1))),
                  _PinKey(label: '', onTap: () {}),
                  _PinKey(label: '0', onTap: () => _onDigit(0)),
                  _PinKey(
                    label: '⌫',
                    onTap: _onDelete,
                    labelColor: kMuted,
                  ),
                ],
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class _PinKey extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? labelColor;

  const _PinKey({
    required this.label,
    required this.onTap,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: label.isEmpty ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: kNavy2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kBorder),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: labelColor ?? kText,
            ),
          ),
        ),
      ),
    );
  }
}
