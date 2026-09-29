// ─────────────────────────────────────────────────────────
//  features/dashboard/home_screen.dart
//  Main dashboard — responsive, scrollable, session-aware.
// ─────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/security/session_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/widgets/brand_logo.dart';
import '../../core/widgets/glass_card.dart';
import '../auth/lock_screen.dart';
import 'widgets/balance_hero.dart';
import 'widgets/quick_action_row.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Re-route to Lock if session is invalidated by background timer.
    ref.listen<SessionState>(sessionProvider, (_, state) {
      if (state == SessionState.locked) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LockScreen()),
          (_) => false,
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── App Bar ──────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Row(
                  children: [
                    const BrandLogo(size: 36),
                    const Spacer(),
                    IconButton(
                      onPressed: () =>
                          ref.read(sessionProvider.notifier).lock(),
                      icon: const Icon(Icons.lock_outline_rounded,
                          color: kMuted, size: 22),
                      tooltip: 'Lock app',
                    ),
                  ],
                ),
              ),
            ),

            // ── Greeting ─────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello there 👋',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: kMint,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Welcome to Finora',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: kText,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Balance Hero Card ─────────────────────────
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: BalanceHero(),
              ),
            ),

            // ── Quick Actions ─────────────────────────────
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: QuickActionRow(),
              ),
            ),

            // ── Feature Cards ─────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              sliver: SliverList.separated(
                itemCount: _features.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (_, i) => GlassCard(
                  title: _features[i].title,
                  text: _features[i].description,
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: kMint.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Soon',
                      style: GoogleFonts.plusJakartaSans(
                        color: kMint,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Footer ───────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Center(
                  child: Text(
                    'Finora V1.0 • Private Beta',
                    style: GoogleFonts.plusJakartaSans(
                      color: kMuted,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Feature {
  final String title, description;
  const _Feature(this.title, this.description);
}

const _features = [
  _Feature('TRACK',
      'Log daily income and expenses with instant categorisation. Build a clear picture of your financial habits.'),
  _Feature('SAVE',
      'Set savings goals and watch your progress with real-time charts and milestone celebrations.'),
  _Feature('GROW',
      'Smart insights powered by your data. See where your money can work harder for you.'),
];
