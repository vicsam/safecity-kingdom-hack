import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

class ResponderMapScreen extends StatelessWidget {
  const ResponderMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          return Stack(
            children: [
              // ── Map background ─────────────────────────────────────────────
              SizedBox.expand(
                child: CustomPaint(painter: _MapGridPainter()),
              ),

              // ── Incident pins ──────────────────────────────────────────────
              Positioned(
                left: w * 0.44,
                top: h * 0.14,
                child: _pin(AppColors.fire,
                    Icons.local_fire_department_outlined, 'Structure Fire'),
              ),
              Positioned(
                right: w * 0.12,
                top: h * 0.38,
                child: _pin(AppColors.security, Icons.shield_outlined,
                    'Perimeter Breach'),
              ),
              Positioned(
                left: w * 0.40,
                top: h * 0.52,
                child: _pin(AppColors.medical,
                    Icons.medical_services_outlined, 'Medical Emergency'),
              ),
              Positioned(
                left: w * 0.13,
                bottom: h * 0.30,
                child: _pin(AppColors.roads,
                    Icons.directions_car_outlined, 'Road Hazard'),
              ),

              // ── Top-left: search + filters ─────────────────────────────────
              Positioned(
                top: 16,
                left: 16,
                child: _buildSearchOverlay(),
              ),

              // ── Top-right: legend ──────────────────────────────────────────
              Positioned(
                top: 16,
                right: 16,
                child: _buildLegendCard(),
              ),

              // ── Bottom: mini-cards ─────────────────────────────────────────
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: _buildBottomCards(context),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Incident pin ───────────────────────────────────────────────────────────

  Widget _pin(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.45),
                blurRadius: 14,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Icon(icon, size: 22, color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  // ── Top-left overlay ───────────────────────────────────────────────────────

  Widget _buildSearchOverlay() {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search bar
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppRadius.none),
            ),
            child: const Row(
              children: [
                SizedBox(width: 10),
                Icon(Icons.search,
                    size: 18, color: AppColors.textSecondary),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration.collapsed(
                      hintText: 'Search location...',
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip('All', isActive: true),
                const SizedBox(width: 6),
                _filterChip('Fire'),
                const SizedBox(width: 6),
                _filterChip('Security'),
                const SizedBox(width: 6),
                _filterChip('Medical'),
                const SizedBox(width: 6),
                _filterChip('Electrical'),
                const SizedBox(width: 6),
                _filterChip('Road'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surface,
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.border,
        ),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isActive
              ? AppColors.textInverse
              : AppColors.textSecondary,
        ),
      ),
    );
  }

  // ── Legend card ────────────────────────────────────────────────────────────

  Widget _buildLegendCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'LEGEND',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 12),
          _legendItem(AppColors.fire, 'Fire Critical'),
          const SizedBox(height: 8),
          _legendItem(AppColors.security, 'Security Alert'),
          const SizedBox(height: 8),
          _legendItem(AppColors.medical, 'Medical'),
          const SizedBox(height: 8),
          _legendItem(AppColors.roads, 'Road Hazard'),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  // ── Bottom mini-cards ──────────────────────────────────────────────────────

  Widget _buildBottomCards(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _miniCard(
            context,
            icon: Icons.local_fire_department_outlined,
            title: 'Industrial Fire',
            location: 'Block C, Redemption City',
            distance: '1.2km away',
            priority: 'critical',
          ),
          const SizedBox(width: 12),
          _miniCard(
            context,
            icon: Icons.medical_services_outlined,
            title: 'Medical Assist',
            location: 'Main Mall, Redemption City',
            distance: '3.4km away',
            priority: 'normal',
          ),
          const SizedBox(width: 12),
          _miniCard(
            context,
            icon: Icons.directions_car_outlined,
            title: 'Road Obstruction',
            location: 'Main Boulevard, Redemption City',
            distance: '5.8km away',
            priority: 'high',
          ),
        ],
      ),
    );
  }

  Widget _miniCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String location,
    required String distance,
    required String priority,
  }) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceRaised,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Center(
              child: Icon(icon, size: 18, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  location,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  distance,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Priority + VIEW button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              _priorityChip(priority),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () =>
                    context.go('/responder/incident/mock-id'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius:
                        BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Text(
                    'VIEW',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priorityChip(String priority) {
    final (Color color, Color surface, String label) = switch (priority) {
      'critical' =>
        (AppColors.danger, AppColors.dangerSurface, 'CRITICAL'),
      'high' => (AppColors.warning, AppColors.warningSurface, 'HIGH'),
      _ => (AppColors.success, AppColors.successSurface, 'NORMAL'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: surface,
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ── Map background painter ─────────────────────────────────────────────────────

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = AppColors.surfaceRaised,
    );

    final minor = Paint()
      ..color = AppColors.border.withValues(alpha: 0.15)
      ..strokeWidth = 0.5;

    final major = Paint()
      ..color = AppColors.border.withValues(alpha: 0.35)
      ..strokeWidth = 1.0;

    const step = 50.0;
    const block = 150.0;

    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(
          Offset(x, 0), Offset(x, size.height), x % block == 0 ? major : minor);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(
          Offset(0, y), Offset(size.width, y), y % block == 0 ? major : minor);
    }
  }

  @override
  bool shouldRepaint(_MapGridPainter oldDelegate) => false;
}
