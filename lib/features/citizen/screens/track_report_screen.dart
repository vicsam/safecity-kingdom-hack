import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

// ── Mock data ─────────────────────────────────────────────────────────────────

const _report = {
  'id': 'RC-4821',
  'title': 'Security Breach at North Gate',
  'location': 'Gate B, Redemption City Main Entrance',
  'status': 'acknowledged',
  'category': 'Security',
  'description':
      'Unauthorized access detected near Gate B. Subject bypassed outer perimeter fence.',
  'reportedAt': '14:30',
  'acknowledgedAt': '14:32',
  'assignedSector': 'Security Unit — North Gate',
  'responderMessage':
      'Your report has been received and acknowledged by the Security unit. '
          'A responder has been notified and is reviewing the situation.',
  'estimatedResponse': '04:30 mins',
  'dispatchStatus': 'PENDING UNIT',
  'priorityLevel': 'HIGH',
};

// ── Screen ────────────────────────────────────────────────────────────────────

class TrackReportScreen extends StatelessWidget {
  const TrackReportScreen({super.key});

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
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 24),
                        _buildTimeline(),
                        const SizedBox(height: 24),
                        _buildIncidentDetailsCard(),
                        const SizedBox(height: 16),
                        _buildResponderUpdateCard(),
                        const SizedBox(height: 32),
                        _buildActionButtons(context),
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

  // ── App bar ────────────────────────────────────────────────────────────────

  Widget _buildAppBar(BuildContext context) {
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
              child: Icon(Icons.arrow_back, size: 20, color: AppColors.textPrimary),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'SafeCity',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.more_vert, size: 20, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header section ─────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Report #${_report['id']}',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.location_on_outlined,
                size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                '${_report['location']} · ${_report['category']}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _statusChip(),
      ],
    );
  }

  Widget _statusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.12),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: const Text(
        'ACKNOWLEDGED',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.info,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  // ── Timeline stepper ───────────────────────────────────────────────────────

  // Steps: 0=Reported(completed), 1=Acknowledged(active),
  //        2=Assigned(pending), 3=Resolved(pending)
  static const _steps = [
    ('Reported', 'completed'),
    ('Acknowledged', 'active'),
    ('Assigned', 'pending'),
    ('Resolved', 'pending'),
  ];

  Widget _buildTimeline() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < _steps.length; i++) ...[
          if (i > 0)
            Expanded(
              child: Container(
                // Center the line with the 28px step nodes
                margin: const EdgeInsets.only(top: 13),
                height: 2,
                // Segment before active step is complete → teal
                color: i <= 1 ? AppColors.primary : AppColors.border,
              ),
            ),
          _buildStep(_steps[i].$1, _steps[i].$2),
        ],
      ],
    );
  }

  Widget _buildStep(String label, String state) {
    final Color labelColor = switch (state) {
      'active' => AppColors.primary,
      'completed' => AppColors.textSecondary,
      _ => AppColors.textTertiary,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildNode(state),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: labelColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNode(String state) {
    return SizedBox(
      width: 28,
      height: 28,
      child: switch (state) {
        'completed' => Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: const Icon(Icons.check, size: 16, color: AppColors.textInverse),
          ),
        'active' => Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 2.5,
                  ),
                ),
              ),
              Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        _ => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceRaised,
              border: Border.all(color: AppColors.border, width: 2),
            ),
          ),
      },
    );
  }

  // ── Incident details card ──────────────────────────────────────────────────

  Widget _buildIncidentDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(Icons.camera_alt_outlined, 'Incident Details'),
          Container(height: 1, color: AppColors.border),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo placeholder
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceRaised,
                    borderRadius: BorderRadius.circular(AppRadius.none),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined,
                          size: 32, color: AppColors.textTertiary),
                      SizedBox(height: 8),
                      Text(
                        'CAM-02-09',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Description
                const Text(
                  'DESCRIPTION',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _report['description']!,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                // Info boxes
                Row(
                  children: [
                    Expanded(child: _infoBox('Time Reported', '14:22:05 UTC', null, null)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _infoBox(
                        'Priority Level',
                        _report['priorityLevel']!,
                        AppColors.warning,
                        Icons.warning_amber_outlined,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBox(String label, String value, Color? valueColor, IconData? icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.none),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              color: AppColors.textSecondary,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: valueColor ?? AppColors.textPrimary),
                const SizedBox(width: 4),
              ],
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Responder update card ──────────────────────────────────────────────────

  Widget _buildResponderUpdateCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(Icons.people_outline, 'Responder Update'),
          Container(height: 1, color: AppColors.border),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Responder avatar + message
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceRaised,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.security_outlined,
                            size: 20, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _report['assignedSector']!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _report['responderMessage']!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(height: 1, color: AppColors.border),
                const SizedBox(height: 16),
                // Info rows
                _infoRow('Assigned Sector', 'North Gate, Redemption City', null),
                const SizedBox(height: 12),
                _infoRow('Est. Response', _report['estimatedResponse']!, AppColors.success),
                const SizedBox(height: 12),
                _infoRow('Dispatch Status', _report['dispatchStatus']!, AppColors.warning),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, Color? valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  // ── Action buttons ─────────────────────────────────────────────────────────

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: Material(
            color: AppColors.primaryDark,
            borderRadius: BorderRadius.circular(AppRadius.none),
            child: InkWell(
              onTap: () => context.push('/citizen/report'),
              borderRadius: BorderRadius.circular(AppRadius.none),
              splashColor: AppColors.primaryDarker,
              child: const Center(
                child: Text(
                  'Report New Incident',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textInverse,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Support not available in demo')),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.border),
              foregroundColor: AppColors.textSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.none),
              ),
            ),
            child: const Text(
              'Contact Support',
              style: TextStyle(fontFamily: 'Inter', fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  // ── Shared helpers ─────────────────────────────────────────────────────────

  Widget _cardHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
