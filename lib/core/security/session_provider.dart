// ─────────────────────────────────────────────────────────
//  core/security/session_provider.dart
//  Riverpod provider that tracks whether the user is
//  currently authenticated within this app session.
//  Automatically locks after 60 s in background.
// ─────────────────────────────────────────────────────────
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── State ──────────────────────────────────────────────────
enum SessionState { locked, unlocked }

class SessionNotifier extends StateNotifier<SessionState>
    with WidgetsBindingObserver {
  SessionNotifier() : super(SessionState.locked) {
    WidgetsBinding.instance.addObserver(this);
  }

  DateTime? _pausedAt;
  static const _lockAfter = Duration(seconds: 60);

  void unlock() => state = SessionState.unlocked;
  void lock() => state = SessionState.locked;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _pausedAt = DateTime.now();
        break;
      case AppLifecycleState.resumed:
        if (_pausedAt != null) {
          final elapsed = DateTime.now().difference(_pausedAt!);
          if (elapsed >= _lockAfter) lock();
        }
        _pausedAt = null;
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

// ── Provider ───────────────────────────────────────────────
final sessionProvider = StateNotifierProvider<SessionNotifier, SessionState>(
  (_) => SessionNotifier(),
);
