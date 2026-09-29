import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

class BrandLogo extends StatelessWidget {
  final double size;
  const BrandLogo({super.key, this.size = 96});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [kMint, kCyan, Colors.transparent],
              stops: [0.0, 0.55, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: kMint.withOpacity(0.30),
                blurRadius: 48,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              'F',
              style: GoogleFonts.plusJakartaSans(
                fontSize: size * 0.68,
                fontWeight: FontWeight.w200,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'FINORA',
          style: GoogleFonts.plusJakartaSans(
            letterSpacing: 8,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: kText,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Track. Save. Grow.',
          style: GoogleFonts.plusJakartaSans(
            color: kMuted,
            letterSpacing: 1.6,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
