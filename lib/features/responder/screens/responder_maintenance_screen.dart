import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

// ── Mock data ─────────────────────────────────────────────────────────────────

final _mockReported = [
  {
    'id': 'REQ-8992',
    'title': 'Street Light Out',
    'location': 'Sector 4, Main Blvd Intersection',
    'time': '2h ago',
    'category': 'electrical',
    'assignee': null,
  },
  {
    'id': 'REQ-8991',
    'title': 'Pothole Repair',
    'location': 'Sector 2, 5th Ave North',
    'time': '4h ago',
    'category': 'roads',
    'assignee': 'J. Miller',
  },
  {
    'id': 'REQ-8988',
    'title': 'Fence Damage (Park)',
    'location': 'Sector 7, Centennial Park',
    'time': '1d ago',
    'category': 'maintenance',
    'assignee': null,
  },
];

final _mockInProgress = [
  {
    'id': 'REQ-8985',
    'title': 'Water Main Leak',
    'location': 'Sector 1, Industrial Park W',
    'time': 'Started 1h ago',
    'category': 'maintenance',
    'assignee': 'T. Ramirez',
    'onSite': true,
  },
  {
    'id': 'REQ-8980',
    'title': 'Transformer Hum/Spark',
    'location': 'Sector 3, Residential Alley',
    'time': 'Started 3h ago',
    'category': 'electrical',
    'assignee': 'K. Chen',
    'onSite': false,
  },
];

final _mockResolved = [
  {
    'id': 'REQ-8975',
    'title': 'Traffic Signal Malfunction',
    'location': 'Sector 1, Hwy 9 Offramp',
    'time': 'Resolved 10:42 AM',
    'category': 'roads',
    'assignee': 'J. Miller',
  },
  {
    'id': 'REQ-8960',
    'title': 'Downed Branch',
    'location': 'Sector 5, Suburbia Lane',
    'time': 'Resolved 08:15 AM',
    'category': 'roads',
    'assignee': 'D. Smith',
  },
];

// ── Screen ────────────────────────────────────────────────────────────────────

class ResponderMaintenanceScreen extends StatefulWidget {
  const ResponderMaintenanceScreen({super.key});

  @override
  State<ResponderMaintenanceScreen> createState() =>
      _ResponderMaintenanceScreenState();
}

class _ResponderMaintenanceScreenState
    extends State<ResponderMaintenanceScreen> {
  late List<Map<String, dynamic>> _reported;
  late List<Map<String, dynamic>> _inProgress;
  late List<Map<String, dynamic>> _resolved;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _reported =
        _mockReported.map((e) => Map<String, dynamic>.from(e)).toList();
    _inProgress =
        _mockInProgress.map((e) => Map<String, dynamic>.from(e)).toList();
    _resolved =
        _mockResolved.map((e) => Map<String, dynamic>.from(e)).toList();
    _searchController
        .addListener(() => setState(() => _searchQuery = _searchController.text));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _filter(List<Map<String, dynamic>> items) {
    if (_searchQuery.trim().isEmpty) return items;
    final q = _searchQuery.toLowerCase();
    return items.where((e) {
      return (e['title'] as String).toLowerCase().contains(q) ||
          (e['location'] as String).toLowerCase().contains(q);
    }).toList();
  }

  void _advance(Map<String, dynamic> item, String fromCol) {
    setState(() {
      final updated = Map<String, dynamic>.from(item);
      if (fromCol == 'reported') {
        _reported.removeWhere((e) => e['id'] == item['id']);
        updated['onSite'] = false;
        updated['time'] = 'Started just now';
        updated['assignee'] ??= 'Unassigned';
        _inProgress.add(updated);
      } else if (fromCol == 'inProgress') {
        _inProgress.removeWhere((e) => e['id'] == item['id']);
        updated['time'] = 'Resolved just now';
        _resolved.insert(0, updated);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          Container(height: 1, color: AppColors.divider),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _kanbanColumn(
                    'REPORTED', _reported, AppColors.warning, 'reported'),
                ),
                Container(width: 1, color: AppColors.divider),
                Expanded(
                  child: _kanbanColumn(
                    'IN PROGRESS', _inProgress, AppColors.info, 'inProgress'),
                ),
                Container(width: 1, color: AppColors.divider),
                Expanded(
                  child: _kanbanColumn(
                    'RESOLVED', _resolved, AppColors.success, 'resolved'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    final openCount = _reported.length + _inProgress.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Row(
        children: [
          // Title + subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text(
                    'Maintenance Queue',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _openChip(openCount),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Non-emergency infrastructure issues',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Search field
          SizedBox(
            width: 240,
            height: 40,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(AppRadius.none),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Icon(Icons.search,
                      size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Search requests...',
                        hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Filter button
          GestureDetector(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Filter not available in demo')),
            ),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(AppRadius.none),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.tune_outlined,
                      size: 16, color: AppColors.textSecondary),
                  SizedBox(width: 6),
                  Text(
                    'Filter',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _openChip(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryGlow,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        '$count Open',
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  // ── Kanban column ─────────────────────────────────────────────────────────

  Widget _kanbanColumn(
    String title,
    List<Map<String, dynamic>> items,
    Color color,
    String columnKey,
  ) {
    final filtered = _filter(items);
    return Column(
      children: [
        _columnHeader(title, items.length, color),
        Expanded(
          child: filtered.isEmpty
              ? _emptyColumn()
              : ListView(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                  children: [
                    for (final item in filtered)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: _card(item, columnKey),
                      ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _columnHeader(String title, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              border: Border.all(color: color.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyColumn() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined,
              size: 32, color: AppColors.textTertiary),
          SizedBox(height: 8),
          Text(
            'No requests here',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Card ──────────────────────────────────────────────────────────────────

  Widget _card(Map<String, dynamic> item, String columnKey) {
    final bool isResolved = columnKey == 'resolved';

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 4px category accent bar
            Container(
              width: 4,
              color: _categoryColor(item['category'] as String),
            ),
            // Card body
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ID + time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['id'] as String,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textTertiary,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Text(
                          item['time'] as String,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Title
                    Text(
                      item['title'] as String,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isResolved
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Location
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 12, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            item['location'] as String,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Category badge + assignee
                    Row(
                      children: [
                        _categoryBadge(item['category'] as String),
                        const Spacer(),
                        _assigneeTag(item['assignee'] as String?),
                      ],
                    ),
                    // ON SITE badge (inProgress only)
                    if (columnKey == 'inProgress' &&
                        item['onSite'] == true) ...[
                      const SizedBox(height: 8),
                      _onSiteBadge(),
                    ],
                    // Action button (not for resolved)
                    if (!isResolved) ...[
                      const SizedBox(height: 12),
                      _actionButton(item, columnKey),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryBadge(String cat) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_categoryIcon(cat),
              size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            _categoryLabel(cat),
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _assigneeTag(String? assignee) {
    if (assignee == null) {
      return const Text(
        'Unassigned',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: AppColors.textTertiary,
        ),
      );
    }

    final parts = assignee.trim().split(' ');
    final initials = parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : assignee.substring(0, assignee.length > 1 ? 2 : 1).toUpperCase();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: AppColors.primaryGlow,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              initials,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          assignee,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _onSiteBadge() {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.successSurface,
        border: Border.all(
            color: AppColors.success.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_pin_circle_outlined,
              size: 12, color: AppColors.success),
          SizedBox(width: 4),
          Text(
            'ON SITE',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(Map<String, dynamic> item, String columnKey) {
    final isReported = columnKey == 'reported';
    return GestureDetector(
      onTap: () => _advance(item, columnKey),
      child: Container(
        width: double.infinity,
        height: 34,
        decoration: BoxDecoration(
          color: isReported
              ? AppColors.primaryDark
              : AppColors.successSurface,
          border: Border.all(
            color: isReported
                ? AppColors.primaryDark
                : AppColors.success.withValues(alpha: 0.4),
          ),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Center(
          child: Text(
            isReported ? 'ASSIGN & START' : 'MARK RESOLVED',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isReported
                  ? AppColors.textInverse
                  : AppColors.success,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }

  // ── Category helpers ──────────────────────────────────────────────────────

  Color _categoryColor(String cat) => switch (cat) {
        'fire' => AppColors.fire,
        'security' => AppColors.security,
        'medical' => AppColors.medical,
        'electrical' => AppColors.electrical,
        'roads' => AppColors.roads,
        _ => AppColors.maintenance,
      };

  IconData _categoryIcon(String cat) => switch (cat) {
        'electrical' => Icons.electrical_services_outlined,
        'roads' => Icons.directions_car_outlined,
        'medical' => Icons.medical_services_outlined,
        'security' => Icons.shield_outlined,
        'fire' => Icons.local_fire_department_outlined,
        _ => Icons.build_outlined,
      };

  String _categoryLabel(String cat) => switch (cat) {
        'electrical' => 'Electrical',
        'roads' => 'Roads',
        'medical' => 'Medical',
        'security' => 'Security',
        'fire' => 'Fire',
        _ => 'Maintenance',
      };
}
