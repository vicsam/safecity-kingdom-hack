import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

// ── Data class ────────────────────────────────────────────────────────────────

class _Category {
  final String id;
  final String label;
  final IconData icon;
  const _Category(this.id, this.label, this.icon);
}

// ── Screen ────────────────────────────────────────────────────────────────────

class GuestReportScreen extends StatefulWidget {
  const GuestReportScreen({super.key});

  @override
  State<GuestReportScreen> createState() => _GuestReportScreenState();
}

class _GuestReportScreenState extends State<GuestReportScreen> {
  String? _selectedCategory;
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;
  XFile? _selectedImage;
  Uint8List? _selectedImageBytes;

  static const _categories = [
    _Category('fire', 'Fire', Icons.local_fire_department_outlined),
    _Category('security', 'Security', Icons.shield_outlined),
    _Category('medical', 'Medical', Icons.medical_services_outlined),
    _Category('electrical', 'Electrical', Icons.electrical_services_outlined),
    _Category('road', 'Road', Icons.directions_car_outlined),
    _Category('maintenance', 'Maintenance', Icons.build_outlined),
  ];

  @override
  void dispose() {
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _categoryToSector(String cat) => switch (cat) {
        'fire' => 'Fire Service',
        'security' => 'Security Unit',
        'medical' => 'Medical Services',
        'electrical' => 'Electrical Maintenance',
        'road' => 'Roads & Infrastructure',
        _ => 'General Maintenance',
      };

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );
    if (file != null) {
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() {
        _selectedImage = file;
        _selectedImageBytes = bytes;
      });
    }
  }

  Future<void> _submit() async {
    print('[Submit] Button tapped');
    print('[Submit] Category: $_selectedCategory');
    print('[Submit] Location: ${_locationController.text}');

    if (_selectedCategory == null) {
      _showSnack('Please select an incident type.');
      return;
    }
    if (_locationController.text.trim().isEmpty) {
      _showSnack('Please enter a location.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await Future.delayed(const Duration(seconds: 1));
      final ts = DateTime.now().millisecondsSinceEpoch.toString();
      final mockId = 'RC-${ts.substring(ts.length - 4)}';
      print('[Submit] Mock submission ID: $mockId');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_guest_report', true);
      await prefs.setString('guest_report_id', mockId);

      if (mounted) {
        context.go('/report/success?reportId=$mockId');
      }
    } catch (e) {
      print('[Submit] ERROR: ${e.toString()}');
      print('[Submit] ERROR TYPE: ${e.runtimeType}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLogoSection(),
                  const SizedBox(height: 24),
                  _buildIntroCard(),
                  const SizedBox(height: 28),
                  _buildEmergencyBadge(),
                  const SizedBox(height: 24),
                  _buildCategoryGrid(),
                  const SizedBox(height: 24),
                  _buildLocationSection(),
                  const SizedBox(height: 24),
                  _buildPhotoSection(),
                  const SizedBox(height: 24),
                  _buildDescriptionSection(),
                  const SizedBox(height: 36),
                  _buildSubmitSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Logo section ──────────────────────────────────────────────────────────

  Widget _buildLogoSection() {
    return Center(
      child: Column(
        children: const [
          Icon(Icons.shield, size: 52, color: AppColors.primary),
          SizedBox(height: 10),
          Text(
            'SafeCity',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Redemption City's Safety Network",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Intro card ────────────────────────────────────────────────────────────

  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.warningSurface,
              borderRadius: BorderRadius.circular(AppRadius.none),
            ),
            child: const Center(
              child: Icon(Icons.warning_amber,
                  size: 22, color: AppColors.warning),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Report an Emergency',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'No account needed. Report instantly and track with a free account after.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Emergency-only badge ──────────────────────────────────────────────────

  Widget _buildEmergencyBadge() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.dangerSurface,
        border: Border.all(color: AppColors.danger),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_outlined, size: 18, color: AppColors.danger),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Emergency reports only. Sign in to report maintenance issues.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppColors.danger,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Category grid ─────────────────────────────────────────────────────────

  Widget _buildCategoryGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('INCIDENT TYPE'),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 94,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _categories.length,
          itemBuilder: (_, i) => _categoryTile(_categories[i]),
        ),
      ],
    );
  }

  Widget _categoryTile(_Category cat) {
    final selected = _selectedCategory == cat.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = cat.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGlow : AppColors.surface,
          border:
              Border.all(color: selected ? AppColors.primary : AppColors.border),
          borderRadius: BorderRadius.circular(8),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 6,
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(cat.icon,
                size: 24,
                color: selected ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(height: 8),
            Text(
              cat.label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Location ──────────────────────────────────────────────────────────────

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('LOCATION'),
        const SizedBox(height: 8),
        TextField(
          controller: _locationController,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Enter street or landmark in Redemption City',
            hintStyle: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.textTertiary,
            ),
            prefixIcon: const Icon(Icons.location_on_outlined,
                size: 18, color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.fromLTRB(0, 14, 17, 15),
            border: _inputBorder(AppColors.border),
            enabledBorder: _inputBorder(AppColors.border),
            focusedBorder: _inputBorder(AppColors.borderStrong),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showSnack('GPS not available in demo'),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.gps_fixed, size: 14, color: AppColors.primary),
              SizedBox(width: 6),
              Text(
                'Detect my location',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Photo upload ──────────────────────────────────────────────────────────

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _sectionLabel('EVIDENCE'),
            const SizedBox(width: 6),
            const Text(
              '(OPTIONAL)',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textTertiary,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: SizedBox(
            width: double.infinity,
            height: 120,
            child: CustomPaint(
              painter: _DashedBorderPainter(
                color: AppColors.border,
                radius: 8,
              ),
              child: _selectedImageBytes == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt,
                            size: 32, color: AppColors.textTertiary),
                        SizedBox(height: 8),
                        Text(
                          'Tap to upload photo',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Max 5MB',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Image.memory(
                            _selectedImageBytes!,
                            width: double.infinity,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: GestureDetector(
                            onTap: () => setState(() {
                              _selectedImage = null;
                              _selectedImageBytes = null;
                            }),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.border),
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Description ───────────────────────────────────────────────────────────

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('DESCRIBE THE INCIDENT'),
        const SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          minLines: 3,
          maxLines: null,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'What is happening? Be as specific as possible...',
            hintStyle: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.textTertiary,
            ),
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.all(13),
            border: _inputBorder(AppColors.border),
            enabledBorder: _inputBorder(AppColors.border),
            focusedBorder: _inputBorder(AppColors.borderStrong),
          ),
        ),
      ],
    );
  }

  // ── Submit + sign-in link ─────────────────────────────────────────────────

  Widget _buildSubmitSection() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: Material(
            color: AppColors.primaryDark,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: _isSubmitting ? null : _submit,
              borderRadius: BorderRadius.circular(8),
              splashColor: AppColors.primaryDarker,
              child: Center(
                child: _isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.textInverse),
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Report Incident',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textInverse,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.send_outlined,
                              size: 18, color: AppColors.textInverse),
                        ],
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => context.go('/login'),
          child: const Text(
            'Already have an account? Sign in →',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _sectionLabel(String text) => Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
          letterSpacing: 0.65,
        ),
      );

  OutlineInputBorder _inputBorder(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color),
      );
}

// ── Dashed border painter ─────────────────────────────────────────────────────

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  const _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0.5, 0.5, size.width - 1, size.height - 1),
        Radius.circular(radius),
      ));

    const dashLength = 6.0;
    const gapLength = 4.0;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashLength).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}
