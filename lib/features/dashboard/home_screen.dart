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
import '../auth/lock_screen.dart';
import '../settings/settings_screen.dart';
import '../transactions/add_transaction_sheet.dart';
import '../transactions/transaction_history_screen.dart';
import '../transactions/widgets/recent_transactions_list.dart';
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
      backgroundColor: kNavy,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kMint,
        foregroundColor: kNavy,
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const AddTransactionSheet(),
        ),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
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
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SettingsScreen()),
                      ),
                      icon: const Icon(Icons.settings_outlined,
                          color: kMuted, size: 22),
                      tooltip: 'Settings',
                    ),
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

            // ── Recent Transactions ───────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: Row(
                  children: [
                    Text(
                      'Recent Transactions',
                      style: GoogleFonts.plusJakartaSans(
                        color: kText,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TransactionHistoryScreen(),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: kMint,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                      ),
                      child: Text(
                        'See All',
                        style: GoogleFonts.plusJakartaSans(
                          color: kMint,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 12, 24, 0),
                child: RecentTransactionsList(),
              ),
            ),

            // ── Footer ───────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Center(
                  child: Text(
                    'Finora V2.0',
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
