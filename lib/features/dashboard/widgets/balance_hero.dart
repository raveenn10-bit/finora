// ─────────────────────────────────────────────────────────
//  features/dashboard/widgets/balance_hero.dart
//  Large balance display card with gradient glow.
// ─────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/colors.dart';

class BalanceHero extends StatelessWidget {
  const BalanceHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            kMint.withOpacity(0.18),
            kCyan.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: kMint.withOpacity(0.22), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: kMint.withOpacity(0.08),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL BALANCE',
            style: GoogleFonts.plusJakartaSans(
              color: kMint,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '₹',
                style: GoogleFonts.plusJakartaSans(
                  color: kText.withOpacity(0.6),
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '0.00',
                style: GoogleFonts.plusJakartaSans(
                  color: kText,
                  fontSize: 44,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              _Stat(
                  label: 'Income',
                  value: '₹0',
                  icon: Icons.arrow_downward_rounded,
                  iconColor: kMint),
              SizedBox(width: 24),
              _Stat(
                  label: 'Expenses',
                  value: '₹0',
                  icon: Icons.arrow_upward_rounded,
                  iconColor: kError),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color iconColor;

  const _Stat({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconColor.withOpacity(0.15),
          ),
          child: Icon(icon, color: iconColor, size: 14),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: kMuted,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                color: kText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
