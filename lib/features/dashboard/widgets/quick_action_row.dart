// ─────────────────────────────────────────────────────────
//  features/dashboard/widgets/quick_action_row.dart
//  Horizontally scrollable row of action chips.
//  Eliminates the overflow-prone fixed 3-column row.
// ─────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/colors.dart';

class QuickActionRow extends StatelessWidget {
  const QuickActionRow({super.key});

  static const _actions = [
    _QuickAction(icon: Icons.add_rounded, label: 'Add', comingSoon: false),
    _QuickAction(
        icon: Icons.bar_chart_rounded, label: 'Track', comingSoon: true),
    _QuickAction(icon: Icons.savings_outlined, label: 'Save', comingSoon: true),
    _QuickAction(
        icon: Icons.trending_up_rounded, label: 'Grow', comingSoon: true),
    _QuickAction(
        icon: Icons.history_rounded, label: 'History', comingSoon: true),
  ];

  @override
  Widget build(BuildContext context) {
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
            children: _actions.map((a) => _ActionChip(action: a)).toList(),
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
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.comingSoon,
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
        onTap: action.comingSoon ? null : () {},
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
