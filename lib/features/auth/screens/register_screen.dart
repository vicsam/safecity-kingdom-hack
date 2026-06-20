import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

class RegisterScreen extends StatefulWidget {
  final String? guestReportId;

  const RegisterScreen({super.key, this.guestReportId});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirm = false;
  bool _isLoading = false;

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // ── Validation ────────────────────────────────────────────────────────────

  bool _validate() {
    String? nameErr, emailErr, passwordErr, confirmErr;

    if (_nameController.text.trim().isEmpty) {
      nameErr = 'Full name is required.';
    }

    final email = _emailController.text.trim();
    if (email.isEmpty) {
      emailErr = 'Email is required.';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      emailErr = 'Enter a valid email address.';
    }

    final password = _passwordController.text;
    if (password.isEmpty) {
      passwordErr = 'Password is required.';
    } else if (password.length < 8) {
      passwordErr = 'Password must be at least 8 characters.';
    }

    if (_confirmController.text.isEmpty) {
      confirmErr = 'Please confirm your password.';
    } else if (_confirmController.text != password) {
      confirmErr = 'Passwords do not match.';
    }

    setState(() {
      _nameError = nameErr;
      _emailError = emailErr;
      _passwordError = passwordErr;
      _confirmError = confirmErr;
    });

    return nameErr == null &&
        emailErr == null &&
        passwordErr == null &&
        confirmErr == null;
  }

  // ── Submit ────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!_validate()) return;

    setState(() => _isLoading = true);

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final user = credential.user!;
      final fullName = _nameController.text.trim();

      await user.updateDisplayName(fullName);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'name': fullName,
        'email': _emailController.text.trim(),
        'role': 'citizen',
        'sector': null,
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Link guest report if provided
      if (widget.guestReportId != null &&
          widget.guestReportId!.isNotEmpty) {
        final query = await FirebaseFirestore.instance
            .collection('incidents')
            .where('reportId', isEqualTo: widget.guestReportId)
            .limit(1)
            .get();

        if (query.docs.isNotEmpty) {
          await query.docs.first.reference.update({
            'reportedBy': {
              'uid': user.uid,
              'name': fullName,
              'channel': 'app',
            },
            'isGuest': false,
          });
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('has_guest_report');
        await prefs.remove('guest_report_id');
      }

      if (!mounted) return;
      context.go('/citizen/home');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      final message = switch (e.code) {
        'email-already-in-use' =>
          'An account with this email already exists. Sign in instead.',
        'weak-password' => 'Password is too weak.',
        'invalid-email' => 'Please enter a valid email address.',
        _ => 'Registration failed. Please try again.',
      };

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Something went wrong. Please try again.')),
      );
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Grid overlay
          CustomPaint(
            painter: _GridPainter(
              gridColor: AppColors.primary.withValues(alpha: 0.03),
              gridSize: 40,
            ),
            size: Size.infinite,
          ),
          // Top teal accent line
          Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0),
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0),
                ],
              ),
            ),
          ),
          // Scrollable content
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.stackLg * 2,
                    vertical: AppSpacing.stackLg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildLogoSection(),
                      SizedBox(height: AppSpacing.stackLg),
                      _buildFormCard(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Logo section ──────────────────────────────────────────────────────────

  Widget _buildLogoSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 40,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
            const Icon(Icons.shield, size: 52, color: AppColors.primary),
          ],
        ),
        SizedBox(height: AppSpacing.stackMd),
        const Text(
          'SAFECITY',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: AppSpacing.stackSm),
        const Text(
          'Create your SafeCity account',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        // Guest report link badge
        if (widget.guestReportId != null &&
            widget.guestReportId!.isNotEmpty) ...[
          SizedBox(height: AppSpacing.stackMd),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryGlow,
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.link,
                    size: 13, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  'Links report ${widget.guestReportId}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ── Form card ─────────────────────────────────────────────────────────────

  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(
          color: AppColors.border,
          width: AppSpacing.borderWidth,
        ),
        borderRadius: AppRadius.cardRadius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 50,
            offset: Offset(0, 25),
            spreadRadius: -12,
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _field(
            label: 'FULL NAME',
            controller: _nameController,
            icon: Icons.person_outline,
            hint: 'Adewale Oyede',
            error: _nameError,
          ),
          SizedBox(height: AppSpacing.stackMd),
          _field(
            label: 'EMAIL ADDRESS',
            controller: _emailController,
            icon: Icons.email_outlined,
            hint: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
            error: _emailError,
          ),
          SizedBox(height: AppSpacing.stackMd),
          _passwordField(
            label: 'PASSWORD',
            controller: _passwordController,
            hint: 'Min. 8 characters',
            show: _showPassword,
            onToggle: () =>
                setState(() => _showPassword = !_showPassword),
            error: _passwordError,
          ),
          SizedBox(height: AppSpacing.stackMd),
          _passwordField(
            label: 'CONFIRM PASSWORD',
            controller: _confirmController,
            hint: 'Repeat your password',
            show: _showConfirm,
            onToggle: () =>
                setState(() => _showConfirm = !_showConfirm),
            error: _confirmError,
          ),
          SizedBox(height: AppSpacing.stackLg),
          _buildSubmitButton(),
          SizedBox(height: AppSpacing.stackMd),
          _buildSignInLink(),
        ],
      ),
    );
  }

  // ── Text field ────────────────────────────────────────────────────────────

  Widget _field({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType? keyboardType,
    String? error,
  }) {
    final hasError = error != null;
    final borderColor =
        hasError ? AppColors.danger : AppColors.border;
    final focusBorderColor =
        hasError ? AppColors.danger : AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label(label),
        SizedBox(height: AppSpacing.stackSm),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.textTertiary,
            ),
            prefixIcon:
                Icon(icon, size: 18, color: AppColors.primary),
            filled: true,
            fillColor: AppColors.background,
            border: _inputBorder(borderColor),
            enabledBorder: _inputBorder(borderColor),
            focusedBorder:
                _inputBorder(focusBorderColor, width: 2),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.stackMd,
              vertical: AppSpacing.stackSm,
            ),
          ),
        ),
        if (hasError) ...[
          SizedBox(height: AppSpacing.stackXs),
          Text(
            error,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: AppColors.danger,
            ),
          ),
        ],
      ],
    );
  }

  // ── Password field ────────────────────────────────────────────────────────

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required bool show,
    required VoidCallback onToggle,
    String? error,
  }) {
    final hasError = error != null;
    final borderColor =
        hasError ? AppColors.danger : AppColors.border;
    final focusBorderColor =
        hasError ? AppColors.danger : AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _label(label),
        SizedBox(height: AppSpacing.stackSm),
        TextField(
          controller: controller,
          obscureText: !show,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.textTertiary,
            ),
            prefixIcon: const Icon(Icons.lock_outline,
                size: 18, color: AppColors.primary),
            suffixIcon: GestureDetector(
              onTap: onToggle,
              child: Icon(
                show
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ),
            filled: true,
            fillColor: AppColors.background,
            border: _inputBorder(borderColor),
            enabledBorder: _inputBorder(borderColor),
            focusedBorder:
                _inputBorder(focusBorderColor, width: 2),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.stackMd,
              vertical: AppSpacing.stackSm,
            ),
          ),
        ),
        if (hasError) ...[
          SizedBox(height: AppSpacing.stackXs),
          Text(
            error,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: AppColors.danger,
            ),
          ),
        ],
      ],
    );
  }

  // ── Submit button ─────────────────────────────────────────────────────────

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          disabledBackgroundColor:
              AppColors.primaryDark.withValues(alpha: 0.6),
          foregroundColor: AppColors.textInverse,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.radiusSm,
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.textInverse),
                ),
              )
            : const Text(
                'CREATE ACCOUNT',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textInverse,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  // ── Sign in link ──────────────────────────────────────────────────────────

  Widget _buildSignInLink() {
    return Center(
      child: GestureDetector(
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
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
          letterSpacing: 0.6,
        ),
      );

  OutlineInputBorder _inputBorder(Color color,
          {double width = AppSpacing.borderWidth}) =>
      OutlineInputBorder(
        borderRadius: AppRadius.radiusSm,
        borderSide: BorderSide(color: color, width: width),
      );
}

// ── Grid painter (matches login screen) ───────────────────────────────────────

class _GridPainter extends CustomPainter {
  final Color gridColor;
  final double gridSize;

  const _GridPainter(
      {required this.gridColor, required this.gridSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;

    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
          Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) =>
      gridColor != old.gridColor || gridSize != old.gridSize;
}
