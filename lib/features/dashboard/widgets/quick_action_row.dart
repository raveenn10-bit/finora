// ─────────────────────────────────────────────────────────
//  features/dashboard/widgets/quick_action_row.dart
//  Horizontally scrollable row of action chips.
//  Eliminates the overflow-prone fixed 3-column row.
// ─────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/colors.dart';
import '../../transactions/add_transaction_sheet.dart';

class QuickActionRow extends StatelessWidget {
  const QuickActionRow({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: Icons.add_rounded,
        label: 'Expense',
        comingSoon: false,
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const AddTransactionSheet(),
        ),
      ),
      _QuickAction(
        icon: Icons.arrow_downward_rounded,
        label: 'Income',
        comingSoon: false,
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const AddTransactionSheet(initialType: 'income'),
        ),
      ),
      const _QuickAction(
        icon: Icons.swap_horiz_rounded,
        label: 'Transfer',
        comingSoon: true,
        onTap: null,
      ),
      const _QuickAction(
        icon: Icons.pie_chart_outline_rounded,
        label: 'Budget',
        comingSoon: true,
        onTap: null,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QUICK ACTIONS',
          style: GoogleFonts.plusJakartaSans(
            color: kMuted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: actions.map((a) => _ActionChip(action: a)).toList(),
          ),
        ),
      ],
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final bool comingSoon;
  final VoidCallback? onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.comingSoon,
    required this.onTap,
  });
}

class _ActionChip extends StatelessWidget {
  final _QuickAction action;
  const _ActionChip({required this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: action.comingSoon ? null : action.onTap,
        child: Opacity(
          opacity: action.comingSoon ? 0.55 : 1.0,
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: kNavy2,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: action.comingSoon ? kBorder : kMint.withOpacity(0.4),
                    width: 1.2,
                  ),
                  boxShadow: action.comingSoon
                      ? null
                      : [
                          BoxShadow(
                            color: kMint.withOpacity(0.15),
                            blurRadius: 12,
                          )
                        ],
                ),
                child: Icon(
                  action.icon,
                  color: action.comingSoon ? kMuted : kMint,
                  size: 22,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                action.label,
                style: GoogleFonts.plusJakartaSans(
                  color: action.comingSoon ? kMuted : kText,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
