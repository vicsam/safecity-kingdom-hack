import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

class CitizenHomeScreen extends StatefulWidget {
  const CitizenHomeScreen({super.key});

  @override
  State<CitizenHomeScreen> createState() => _CitizenHomeScreenState();
}

class _CitizenHomeScreenState extends State<CitizenHomeScreen> {
  static const List<_Report> _reports = [
    _Report(
      title: 'Security Breach at North Gate',
      time: 'Reported 10m ago',
      status: 'acknowledged',
      category: 'security',
    ),
    _Report(
      title: 'Water Leakage - Zone 4',
      time: 'Reported 2h ago',
      status: 'assigned',
      category: 'maintenance',
      showCategoryTag: true,
    ),
    _Report(
      title: 'Street Light Out - Main Ave',
      time: 'Reported 1d ago',
      status: 'resolved',
      category: 'electrical',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildReportButton(),
                  const SizedBox(height: 24),
                  _buildMyReportsSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.shield, size: 20, color: AppColors.primary),
            SizedBox(width: 12),
            Text(
              'Good morning, Alex',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppRadius.none),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Redemption City — All systems operational',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReportButton() {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(AppRadius.none),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 6,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/citizen/report'),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 14, color: AppColors.textInverse),
                SizedBox(width: 8),
                Text(
                  'Report an Incident',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textInverse,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMyReportsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: 5),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: const Text(
            'My Reports',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        for (int i = 0; i < _reports.length; i++) ...[
          if (i > 0) const SizedBox(height: 16),
          _buildReportCard(_reports[i]),
        ],
      ],
    );
  }

  Widget _buildReportCard(_Report report) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.none),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 4px left accent bar
            Container(width: 4, color: _categoryColor(report.category)),
            // Card body
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Container(
                    color: AppColors.surface,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 17),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: AppColors.surfaceRaised,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              _categoryIcon(report.category),
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              report.title,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              report.time,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                                letterSpacing: 0.13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Divider
                  Container(height: 1, color: AppColors.border),
                  // Status row
                  Container(
                    color: AppColors.background,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'STATUS',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.13,
                          ),
                        ),
                        Row(
                          children: [
                            if (report.showCategoryTag) ...[
                              _buildCategoryTag(report.category),
                              const SizedBox(width: 8),
                            ],
                            _buildStatusChip(report.status),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTag(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.none),
      ),
      child: Text(
        category.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final (Color color, String label) = switch (status) {
      'acknowledged' => (AppColors.info, 'Acknowledged'),
      'assigned' => (AppColors.warning, 'Assigned'),
      'resolved' => (AppColors.success, 'Resolved'),
      _ => (AppColors.textSecondary, status),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Color _categoryColor(String category) => switch (category) {
        'security' => AppColors.security,
        'maintenance' => AppColors.maintenance,
        'electrical' => AppColors.electrical,
        'fire' => AppColors.fire,
        'medical' => AppColors.medical,
        'roads' => AppColors.roads,
        _ => AppColors.border,
      };

  IconData _categoryIcon(String category) => switch (category) {
        'security' => Icons.shield_outlined,
        'maintenance' => Icons.plumbing_outlined,
        'electrical' => Icons.electrical_services_outlined,
        'fire' => Icons.local_fire_department_outlined,
        'medical' => Icons.medical_services_outlined,
        'roads' => Icons.directions_car_outlined,
        _ => Icons.info_outline,
      };
}

class _Report {
  final String title;
  final String time;
  final String status;
  final String category;
  final bool showCategoryTag;

  const _Report({
    required this.title,
    required this.time,
    required this.status,
    required this.category,
    this.showCategoryTag = false,
  });
}
