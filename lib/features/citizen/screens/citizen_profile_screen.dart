import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

class CitizenProfileScreen extends StatelessWidget {
  const CitizenProfileScreen({super.key});

  static const _name = 'Adewale Oyede';
  static const _initials = 'AO';
  static const _residentId = 'RC-2024-08821';
  static const _reportsTotal = 12;
  static const _reportsResolved = 9;
  static const _reportsPending = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                _appBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 28, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _avatarSection(),
                        const SizedBox(height: 28),
                        _statsRow(),
                        const SizedBox(height: 28),
                        _section(context, 'ACCOUNT', [
                          _item(context, Icons.person_outline,
                              'Personal Information'),
                          _item(context, Icons.notifications_outlined,
                              'Notification Preferences'),
                          _item(context, Icons.lock_outlined, 'Change Password'),
                          _item(context, Icons.chat_bubble_outline,
                              'Linked WhatsApp',
                              badge: 'Connected', isLast: true),
                        ]),
                        const SizedBox(height: 24),
                        _section(context, 'ABOUT', [
                          _item(context, Icons.help_outline, 'Help & Support'),
                          _item(context, Icons.description_outlined,
                              'Terms of Service'),
                          _item(context, Icons.shield_outlined, 'Privacy Policy'),
                          _item(context, Icons.info_outlined, 'App Version',
                              trailingText: 'v1.0.0',
                              showChevron: false,
                              isLast: true),
                        ]),
                        const SizedBox(height: 32),
                        _signOutButton(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── App bar ───────────────────────────────────────────────────────────────

  Widget _appBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 9),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () =>
                context.canPop() ? context.pop() : context.go('/citizen/home'),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child:
                  Icon(Icons.arrow_back, size: 20, color: AppColors.textPrimary),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.settings_outlined,
                  size: 20, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  // ── Avatar section ────────────────────────────────────────────────────────

  Widget _avatarSection() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryGlow,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: const Center(
              child: Text(
                _initials,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            _name,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            _residentId,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          _verifiedChip(),
        ],
      ),
    );
  }

  Widget _verifiedChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, size: 12, color: AppColors.success),
          SizedBox(width: 6),
          Text(
            'Verified Resident',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats row ─────────────────────────────────────────────────────────────

  Widget _statsRow() {
    return Row(
      children: [
        Expanded(child: _statCard('$_reportsTotal', 'Reports Filed')),
        const SizedBox(width: 12),
        Expanded(child: _statCard('$_reportsResolved', 'Resolved')),
        const SizedBox(width: 12),
        Expanded(child: _statCard('$_reportsPending', 'Pending')),
      ],
    );
  }

  Widget _statCard(String number, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── Section (header + card) ───────────────────────────────────────────────

  Widget _section(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              letterSpacing: 0.6,
            ),
          ),
        ),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  // ── List item ─────────────────────────────────────────────────────────────

  Widget _item(
    BuildContext context,
    IconData icon,
    String label, {
    String? badge,
    String? trailingText,
    bool showChevron = true,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coming soon')),
      ),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: isLast
            ? null
            : const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: AppColors.divider)),
              ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (badge != null) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: const Text(
                  'Connected',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            if (trailingText != null)
              Text(
                trailingText,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            if (showChevron)
              const Icon(Icons.chevron_right,
                  size: 20, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }

  // ── Sign out button ───────────────────────────────────────────────────────

  Widget _signOutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () => context.go('/login'),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.danger.withValues(alpha: 0.5)),
          foregroundColor: AppColors.danger,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        child: const Text(
          'Sign Out',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.danger,
          ),
        ),
      ),
    );
  }
}
