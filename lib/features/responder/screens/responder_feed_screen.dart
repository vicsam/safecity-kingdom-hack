import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

// ── Mock data ─────────────────────────────────────────────────────────────────

final _mockIncidents = [
  {
    'id': 'INC-9821',
    'title': 'Structure Fire — Block C Residential',
    'location': 'Block C Zone 3, Redemption City',
    'time': '2 mins ago',
    'channel': 'whatsapp',
    'priority': 'critical',
    'category': 'fire',
    'acknowledged': false,
  },
  {
    'id': 'INC-9818',
    'title': 'Unauthorised Entry — Sector 4',
    'location': 'North Gate, Redemption City',
    'time': '14 mins ago',
    'channel': 'app',
    'priority': 'high',
    'category': 'security',
    'acknowledged': false,
  },
  {
    'id': 'INC-9815',
    'title': 'Medical Emergency — Mall Parking',
    'location': 'Main Boulevard, Redemption City',
    'time': '45 mins ago',
    'channel': 'whatsapp',
    'priority': 'normal',
    'category': 'medical',
    'acknowledged': false,
  },
  {
    'id': 'INC-9812',
    'title': 'Perimeter Breach — North Gate',
    'location': 'North Gate, Redemption City',
    'time': '1 hour ago',
    'channel': 'app',
    'priority': 'high',
    'category': 'security',
    'acknowledged': true,
  },
];

// ── Screen ────────────────────────────────────────────────────────────────────

class ResponderFeedScreen extends StatefulWidget {
  const ResponderFeedScreen({super.key});

  @override
  State<ResponderFeedScreen> createState() => _ResponderFeedScreenState();
}

class _ResponderFeedScreenState extends State<ResponderFeedScreen> {
  late List<Map<String, dynamic>> _incidents;
  int _selectedTab = 0; // 0=All, 1=Emergency, 2=Maintenance

  static const _tabs = ['All', 'Emergency', 'Maintenance'];

  @override
  void initState() {
    super.initState();
    _incidents =
        _mockIncidents.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  List<Map<String, dynamic>> get _filtered {
    return switch (_selectedTab) {
      1 => _incidents.where((e) => e['category'] != 'maintenance').toList(),
      2 => _incidents.where((e) => e['category'] == 'maintenance').toList(),
      _ => _incidents,
    };
  }

  void _acknowledge(String id) {
    setState(() {
      final idx = _incidents.indexWhere((e) => e['id'] == id);
      if (idx != -1) _incidents[idx]['acknowledged'] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Container(height: 1, color: AppColors.divider),
          _buildTabRow(),
          Container(height: 1, color: AppColors.divider),
          Expanded(
            child: _filtered.isEmpty
                ? _emptyState()
                : ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (ctx, i) => GestureDetector(
                      onTap: () => ctx.go(
                          '/responder/incident/${_filtered[i]['id']}'),
                      child: _incidentCard(_filtered[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          const Text(
            'Incident Feed',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'Live',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.success,
            ),
          ),
          const Spacer(),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppRadius.none),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Fire Service',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.close, size: 14, color: AppColors.textTertiary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab row ───────────────────────────────────────────────────────────────

  Widget _buildTabRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          ..._tabs.asMap().entries.map((e) => _tab(e.key, e.value)),
          const Spacer(),
          const Text(
            'SYNCED: 13:44:43 UTC',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              color: AppColors.textTertiary,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(int index, String label) {
    final active = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight:
                active ? FontWeight.w600 : FontWeight.w400,
            color: active
                ? AppColors.primary
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  // ── Incident card ─────────────────────────────────────────────────────────

  Widget _incidentCard(Map<String, dynamic> inc) {
    final acknowledged = inc['acknowledged'] as bool;
    final id = inc['id'] as String;

    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 4px category accent bar
                Container(width: 4, color: _categoryColor(inc['category'])),
                // Card body
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Category icon
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceRaised,
                            borderRadius:
                                BorderRadius.circular(AppRadius.none),
                          ),
                          child: Center(
                            child: Icon(
                              _categoryIcon(inc['category']),
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Title + location + channel
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                inc['title'],
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${inc['location']}  ·  ${inc['time']}',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _channelBadge(inc['channel']),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Priority + ack
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _priorityChip(inc['priority']),
                            const SizedBox(height: 10),
                            acknowledged
                                ? _acknowledgedChip()
                                : _acknowledgeButton(id),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: AppColors.divider),
        ],
      ),
    );
  }

  // ── Channel badge ─────────────────────────────────────────────────────────

  Widget _channelBadge(String channel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        channel == 'whatsapp' ? 'via WhatsApp' : 'via App',
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  // ── Priority chip ─────────────────────────────────────────────────────────

  Widget _priorityChip(String priority) {
    final (Color color, Color surface, String label) = switch (priority) {
      'critical' => (AppColors.danger, AppColors.dangerSurface, 'CRITICAL'),
      'high' => (AppColors.warning, AppColors.warningSurface, 'HIGH'),
      _ => (AppColors.success, AppColors.successSurface, 'NORMAL'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ── Acknowledge button ────────────────────────────────────────────────────

  Widget _acknowledgeButton(String id) {
    return GestureDetector(
      onTap: () => _acknowledge(id),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Center(
          child: Text(
            'ACKNOWLEDGE',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textInverse,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  // ── Acknowledged chip ─────────────────────────────────────────────────────

  Widget _acknowledgedChip() {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.successSurface,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check, size: 14, color: AppColors.success),
          SizedBox(width: 6),
          Text(
            'ACKNOWLEDGED',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty state ───────────────────────────────────────────────────────────

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: AppColors.textTertiary),
          SizedBox(height: 16),
          Text(
            'No incidents in this category',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Color _categoryColor(String cat) => switch (cat) {
        'fire' => AppColors.fire,
        'security' => AppColors.security,
        'medical' => AppColors.medical,
        'electrical' => AppColors.electrical,
        'road' => AppColors.roads,
        _ => AppColors.maintenance,
      };

  IconData _categoryIcon(String cat) => switch (cat) {
        'fire' => Icons.local_fire_department_outlined,
        'security' => Icons.shield_outlined,
        'medical' => Icons.medical_services_outlined,
        'electrical' => Icons.electrical_services_outlined,
        'road' => Icons.directions_car_outlined,
        _ => Icons.build_outlined,
      };
}
