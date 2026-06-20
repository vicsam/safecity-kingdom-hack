import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

class ReportIncidentScreen extends StatefulWidget {
  const ReportIncidentScreen({super.key});

  @override
  State<ReportIncidentScreen> createState() => _ReportIncidentScreenState();
}

class _ReportIncidentScreenState extends State<ReportIncidentScreen> {
  String _selectedType = 'emergency';
  String? _selectedCategory;
  final _locationController = TextEditingController();
  final _detailsController = TextEditingController();
  Uint8List? _imageBytes;
  bool _isSubmitting = false;
  final _picker = ImagePicker();

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
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final file = await _picker.pickImage(source: source);
    if (file == null || !mounted) return;
    final bytes = await file.readAsBytes();
    setState(() => _imageBytes = bytes);
  }

  void _showImagePicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceOverlay,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: AppColors.textPrimary),
              title: const Text('Take a photo',
                  style: TextStyle(color: AppColors.textPrimary, fontFamily: 'Inter')),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: AppColors.textPrimary),
              title: const Text('Choose from gallery',
                  style: TextStyle(color: AppColors.textPrimary, fontFamily: 'Inter')),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_selectedCategory == null) {
      _showSnack('Please select an incident type.');
      return;
    }
    if (_locationController.text.trim().isEmpty) {
      _showSnack('Please enter a location.');
      return;
    }
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    context.go('/citizen/home');
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSegmentedToggle(),
                        const SizedBox(height: 24),
                        _buildCategoryGrid(),
                        const SizedBox(height: 24),
                        _buildLocationSection(),
                        const SizedBox(height: 24),
                        _buildEvidenceSection(),
                        const SizedBox(height: 24),
                        _buildDetailsSection(),
                        const SizedBox(height: 40),
                        _buildSubmitSection(),
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

  // ── App bar ──────────────────────────────────────────────────────────────

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 9),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.canPop() ? context.pop() : context.go('/citizen/home'),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 8, 8, 14),
              child: Icon(Icons.arrow_back, size: 16, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Report Incident',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primaryGlow,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: const Text(
              'SECURE',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Segmented toggle ─────────────────────────────────────────────────────

  Widget _buildSegmentedToggle() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _toggleOption('emergency', Icons.warning_amber_outlined, 'Emergency'),
          const SizedBox(width: 4),
          _toggleOption('maintenance', Icons.build_outlined, 'Maintenance'),
        ],
      ),
    );
  }

  Widget _toggleOption(String type, IconData icon, String label) {
    final active = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? AppColors.primaryDark : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            boxShadow: active
                ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 6)]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16,
                  color: active ? AppColors.textInverse : AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: active ? AppColors.textInverse : AppColors.textSecondary,
                  letterSpacing: 0.13,
                ),
              ),
            ],
          ),
        ),
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
          border: Border.all(color: selected ? AppColors.primary : AppColors.border),
          borderRadius: BorderRadius.circular(8),
          boxShadow: selected
              ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 6)]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(cat.icon, size: 24,
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

  // ── Location section ──────────────────────────────────────────────────────

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
            hintText: 'Enter street address or landmark',
            hintStyle: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.textTertiary,
            ),
            prefixIcon: const Icon(
              Icons.location_on_outlined,
              size: 18,
              color: AppColors.textSecondary,
            ),
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.fromLTRB(0, 14, 17, 15),
            border: _inputBorder(AppColors.border),
            enabledBorder: _inputBorder(AppColors.border),
            focusedBorder: _inputBorder(AppColors.borderStrong),
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => _showSnack('GPS not available in demo'),
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.gps_fixed, size: 14, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'Detect my location',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                    letterSpacing: 0.13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Evidence section ──────────────────────────────────────────────────────

  Widget _buildEvidenceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('EVIDENCE',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.65,
                )),
            Text('(OPTIONAL)',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textTertiary,
                  letterSpacing: 0.65,
                )),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _showImagePicker,
          child: CustomPaint(
            foregroundPainter: _DashedBorder(color: AppColors.border, radius: 8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 2),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: _imageBytes != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.memory(_imageBytes!,
                          height: 120, width: double.infinity, fit: BoxFit.cover),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.camera_alt_outlined,
                            size: 48, color: AppColors.textSecondary),
                        SizedBox(height: 12),
                        Text('Tap to capture or upload photos',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            )),
                        SizedBox(height: 4),
                        Text('Max 5MB per file',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                              letterSpacing: 0.13,
                            )),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Additional details section ────────────────────────────────────────────

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('ADDITIONAL DETAILS'),
        const SizedBox(height: 8),
        TextField(
          controller: _detailsController,
          minLines: 4,
          maxLines: null,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText:
                'Describe the incident, specific hazards, or people involved...',
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

  // ── Submit section ────────────────────────────────────────────────────────

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
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.textInverse),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Submit Report',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textInverse,
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.send_outlined,
                              size: 16, color: AppColors.textInverse),
                        ],
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.info_outline, size: 12, color: AppColors.textTertiary),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'Submitting this report will share your current location with Redemption City emergency services.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textTertiary,
                  letterSpacing: 0.13,
                ),
              ),
            ),
          ],
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

// ── Data class ────────────────────────────────────────────────────────────────

class _Category {
  final String id;
  final String label;
  final IconData icon;

  const _Category(this.id, this.label, this.icon);
}

// ── Dashed border painter ─────────────────────────────────────────────────────

class _DashedBorder extends CustomPainter {
  final Color color;
  final double radius;

  const _DashedBorder({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashLen = 6.0;
    const gapLen = 4.0;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));

    for (final metric in path.computeMetrics()) {
      double d = 0;
      bool draw = true;
      while (d < metric.length) {
        final len = draw ? dashLen : gapLen;
        if (draw) canvas.drawPath(metric.extractPath(d, d + len), paint);
        d += len;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorder old) =>
      color != old.color || radius != old.radius;
}
