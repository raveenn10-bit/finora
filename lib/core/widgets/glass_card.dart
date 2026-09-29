import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

class GlassCard extends StatelessWidget {
  final String title;
  final String text;
  final Widget? trailing;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.title,
    required this.text,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: kNavy2,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: kMint.withOpacity(0.18), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: kMint.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: kMint,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    fontSize: 12,
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 12),
            Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                height: 1.6,
                color: kText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
