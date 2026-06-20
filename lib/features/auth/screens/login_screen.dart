import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _showPassword = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLoginPressed() async {
    try {
      setState(() => _isLoading = true);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      // GoRouter redirect handles navigation based on user role
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              switch (e.code) {
                'user-not-found' => 'No account found with this email.',
                'wrong-password' => 'Incorrect password.',
                'invalid-email' => 'Please enter a valid email.',
                'invalid-credential' => 'Invalid email or password.',
                _ => e.message ?? 'Login failed.',
              },
            ),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Grid overlay (3% opacity)
          _buildGridOverlay(),

          // Top teal gradient line
          Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0),
                  AppColors.primary,
                  AppColors.primary.withOpacity(0),
                ],
              ),
            ),
          ),

          // Main content
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo section
                  _buildLogoSection(),
                  SizedBox(height: AppSpacing.stackLg * 1.5),

                  // Form card
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.stackLg * 2,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: _buildFormCard(),
                    ),
                  ),

                  const Spacer(),

                  // Responder note
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.stackLg * 2,
                    ),
                    child: const Text(
                      'Responder or staff? Sign in above\nwith your invitation credentials.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.stackMd),

                  // Bottom divider
                  Container(
                    height: 1,
                    color: AppColors.border,
                    margin: EdgeInsets.only(bottom: AppSpacing.stackMd),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridOverlay() {
    return CustomPaint(
      painter: _GridPainter(
        gridColor: AppColors.primary.withOpacity(0.03),
        gridSize: 40,
      ),
      size: Size.infinite,
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        // Shield icon with glow
        Stack(
          alignment: Alignment.center,
          children: [
            // Glow effect
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.15),
                    blurRadius: 40,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
            // Shield icon
            Icon(
              Icons.shield,
              size: 64,
              color: AppColors.primary,
            ),
          ],
        ),
        SizedBox(height: AppSpacing.stackMd),

        // SafeCity text
        Text(
          'SAFECITY',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: -0.6,
          ),
        ),
        SizedBox(height: AppSpacing.stackSm),

        // Tagline
        Text(
          "Redemption City's Safety Network",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(
          color: AppColors.border,
          width: AppSpacing.borderWidth,
        ),
        borderRadius: AppRadius.cardRadius,
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 50,
            offset: const Offset(0, 25),
            spreadRadius: -12,
          ),
        ],
      ),
      padding: EdgeInsets.all(25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email field
          _buildEmailField(),
          SizedBox(height: AppSpacing.stackMd),

          // Password field
          _buildPasswordField(),
          SizedBox(height: AppSpacing.stackXs),

          // Sign in button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: _buildSignInButton(),
          ),
          SizedBox(height: AppSpacing.stackMd),

          // Bottom links
          _buildBottomLinks(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Text(
          'Email',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 0.6,
          ),
        ),
        SizedBox(height: AppSpacing.stackSm),

        // Input field
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'operator@safecity.net',
            hintStyle: TextStyle(
              color: AppColors.textPrimary.withOpacity(0.5),
            ),
            prefixIcon: Icon(
              Icons.email_outlined,
              color: AppColors.primary,
              size: 20,
            ),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: AppRadius.radiusSm,
              borderSide: const BorderSide(
                color: AppColors.border,
                width: AppSpacing.borderWidth,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.radiusSm,
              borderSide: const BorderSide(
                color: AppColors.border,
                width: AppSpacing.borderWidth,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.radiusSm,
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.stackMd,
              vertical: AppSpacing.stackSm,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label with reset link
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Password',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 0.6,
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Implement password reset flow
                debugPrint('Password reset tapped');
              },
              child: Text(
                'reset',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.stackSm),

        // Input field
        TextField(
          controller: _passwordController,
          obscureText: !_showPassword,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: TextStyle(
              color: AppColors.textPrimary.withOpacity(0.5),
            ),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: AppColors.primary,
              size: 20,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() => _showPassword = !_showPassword);
              },
              child: Icon(
                _showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: AppRadius.radiusSm,
              borderSide: const BorderSide(
                color: AppColors.border,
                width: AppSpacing.borderWidth,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.radiusSm,
              borderSide: const BorderSide(
                color: AppColors.border,
                width: AppSpacing.borderWidth,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.radiusSm,
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.stackMd,
              vertical: AppSpacing.stackSm,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleLoginPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        disabledBackgroundColor: AppColors.primaryDark.withValues(alpha: 0.6),
        foregroundColor: AppColors.textInverse,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.radiusSm,
        ),
        elevation: 0,
      ),
      child: _isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.textInverse,
                ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign In',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textInverse,
                  ),
                ),
                SizedBox(width: AppSpacing.stackSm),
                Icon(
                  Icons.arrow_forward,
                  color: AppColors.textInverse,
                  size: 20,
                ),
              ],
            ),
    );
  }

  Widget _buildBottomLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Emergency report button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () => context.go('/'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.radiusSm,
              ),
            ),
            child: const Text(
              '🚨 Report an emergency without an account →',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.stackMd),
        // "or" divider
        Row(
          children: [
            const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.stackMd),
              child: const Text(
                'or',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
            const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
          ],
        ),
        SizedBox(height: AppSpacing.stackMd),
        // Register section
        Column(
          children: [
            const Text(
              'New to SafeCity?',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.stackXs),
            GestureDetector(
              onTap: () => context.go('/register'),
              child: const Text(
                'Create a resident account →',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Custom painter for grid background overlay
class _GridPainter extends CustomPainter {
  final Color gridColor;
  final double gridSize;

  _GridPainter({
    required this.gridColor,
    required this.gridSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;

    // Vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) {
    return oldDelegate.gridColor != gridColor || oldDelegate.gridSize != gridSize;
  }
}
