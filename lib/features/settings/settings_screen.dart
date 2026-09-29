// ─────────────────────────────────────────────────────────
//  features/settings/settings_screen.dart
//  Simple settings screen with app info and security options.
// ─────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/security/session_provider.dart';
import '../../core/theme/colors.dart';
import '../auth/lock_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: kNavy,
      appBar: AppBar(
        backgroundColor: kNavy2,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: kText, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.plusJakartaSans(
            color: kText,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // ── Security ──────────────────────────────────
          const _SectionHeader(title: 'SECURITY'),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.lock_outline_rounded,
            iconColor: kMint,
            title: 'Lock App',
            subtitle: 'Return to biometric/PIN lock screen',
            onTap: () {
              ref.read(sessionProvider.notifier).lock();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LockScreen()),
                (_) => false,
              );
            },
          ),
          const SizedBox(height: 8),
          const _SettingsTile(
            icon: Icons.fingerprint_rounded,
            iconColor: kCyan,
            title: 'Biometric Authentication',
            subtitle: 'Face ID / Fingerprint protection enabled',
            onTap: null,
            trailing: Icon(Icons.check_circle_outline_rounded,
                color: kMint, size: 20),
          ),

          const SizedBox(height: 28),

          // ── App Info ──────────────────────────────────
          const _SectionHeader(title: 'APP'),
          const SizedBox(height: 12),
          const _SettingsTile(
            icon: Icons.info_outline_rounded,
            iconColor: kMuted,
            title: 'Version',
            subtitle: 'Finora v2.0.0',
            onTap: null,
          ),
          const SizedBox(height: 8),
          const _SettingsTile(
            icon: Icons.storage_rounded,
            iconColor: kMuted,
            title: 'Data Storage',
            subtitle: 'All data stored locally on this device',
            onTap: null,
          ),
          const SizedBox(height: 8),
          const _SettingsTile(
            icon: Icons.shield_outlined,
            iconColor: kMuted,
            title: 'Privacy',
            subtitle: 'No data is collected or sent to any server',
            onTap: null,
          ),

          const SizedBox(height: 40),

          // ── Brand footer ──────────────────────────────
          Center(
            child: Column(
              children: [
                Text(
                  'FINORA',
                  style: GoogleFonts.plusJakartaSans(
                    color: kMint,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Track. Save. Grow.',
                  style: GoogleFonts.plusJakartaSans(
                    color: kMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        color: kMuted,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.8,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: kNavy2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withOpacity(0.12),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      color: kText,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      color: kMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
            if (trailing == null && onTap != null)
              const Icon(Icons.chevron_right_rounded, color: kMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
