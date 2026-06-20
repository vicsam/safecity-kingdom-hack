import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class ReportSuccessScreen extends StatelessWidget {
  final String reportId;

  const ReportSuccessScreen({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildSuccessCircle(),
                  const SizedBox(height: 24),
                  const Text(
                    'Report Submitted!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your report has been received by\nRedemption City emergency services.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildReportIdCard(),
                  const SizedBox(height: 20),
                  _buildCreateAccountButton(context),
                  const SizedBox(height: 12),
                  _buildMaybeLater(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Success circle ─────────────────────────────────────────────────────────

  Widget _buildSuccessCircle() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.successSurface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.success, width: 2),
      ),
      child: const Center(
        child: Icon(Icons.check, size: 60, color: AppColors.success),
      ),
    );
  }

  // ── Report ID card ─────────────────────────────────────────────────────────

  Widget _buildReportIdCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'REPORT ID',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            reportId.isNotEmpty ? reportId : 'RC-0000',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Save this ID to track your report',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 20),
          Container(height: 1, color: AppColors.divider),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '🔔 Get live updates on your report',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _benefitRow(Icons.track_changes_outlined,
              'Track your report in real time'),
          _benefitRow(Icons.notifications_outlined,
              'Get notified when responders act'),
          _benefitRow(Icons.history_outlined, 'View all your past reports'),
        ],
      ),
    );
  }

  Widget _benefitRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Widget _buildCreateAccountButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Material(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => context.go('/register?reportId=${Uri.encodeComponent(reportId)}'),
          borderRadius: BorderRadius.circular(12),
          child: const Center(
            child: Text(
              'CREATE FREE ACCOUNT',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textInverse,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMaybeLater(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/login'),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Maybe Later',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
