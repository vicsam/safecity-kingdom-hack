# SafeCity Login Screen

## Overview
Mission-control inspired login interface for the SafeCity incident management platform. Built from exact Figma design specifications with Stitch design tokens.

## File Location
```
lib/features/auth/screens/login_screen.dart
```

## Features

### Visual Design
- ✅ Dark background with subtle teal grid overlay (3% opacity)
- ✅ Teal gradient line at top of screen
- ✅ Thin divider at bottom
- ✅ Shield icon with soft teal glow effect
- ✅ "SAFECITY" branding text (Inter SemiBold 24px)
- ✅ Tagline: "Redemption City's Safety Network"

### Form Card
- ✅ Background: #112322 (AppColors.surface)
- ✅ 1px border: #3C4A46 (AppColors.outlineVariant)
- ✅ Border radius: 12px (AppRadius.cardRadius)
- ✅ Padding: 25px all sides
- ✅ Box shadow: 0px 25px 50px -12px rgba(0,0,0,0.25)

### Email Field
- ✅ Label: "Email" (Inter Bold 12px, letterSpacing 0.6)
- ✅ Input background: #051615 (AppColors.background)
- ✅ Border: 1px #3C4A46 (AppColors.outlineVariant)
- ✅ Left icon: email envelope (teal)
- ✅ Placeholder: "operator@safecity.net" (50% opacity)
- ✅ Focus state: border changes to #44DDC1 (AppColors.primary)

### Password Field
- ✅ Label: "Password" (same style as email)
- ✅ "reset" link on label row (Inter Medium 13px, teal)
- ✅ Input same style as email field
- ✅ Left icon: lock (teal)
- ✅ Right icon: visibility toggle (eye icon)
- ✅ Placeholder: "••••••••" (50% opacity)
- ✅ Show/hide password functionality

### Sign In Button
- ✅ Background: #00BFA5 (AppColors.primaryButton)
- ✅ Full width, 52px height
- ✅ Border radius: 4px (AppRadius.radiusSm)
- ✅ Text: "Sign In" (Inter SemiBold 20px)
- ✅ Right icon: arrow_forward
- ✅ Loading state: shows CircularProgressIndicator
- ✅ Disabled state during loading

### Register Link
- ✅ "New resident? " (Inter Regular 14px, secondary color)
- ✅ "Register here →" (Inter Regular 14px, primary teal with underline)
- ✅ Clickable tap handler

## Component Structure

```dart
LoginScreen (StatefulWidget)
├── Grid Overlay Background
├── Top Teal Gradient Line
├── Main Content (SingleChildScrollView)
│   ├── Logo Section
│   │   ├── Shield Icon + Glow
│   │   ├── "SAFECITY" Title
│   │   └── Tagline
│   └── Form Card
│       ├── Email Field
│       ├── Password Field
│       ├── Sign In Button
│       └── Register Link
└── Bottom Divider
```

## Color Tokens Used

All colors use AppColors constants (never hardcoded hex):

```dart
AppColors.background      // #051615
AppColors.surface         // #112322
AppColors.primary         // #44DDC1
AppColors.primaryButton   // #00BFA5
AppColors.textPrimary     // #DDE4E0
AppColors.textSecondary   // #BBCAC4
AppColors.outlineVariant  // #3C4A46
AppColors.onPrimary       // #00201A
AppColors.scrim           // 0x4D000000
```

## Spacing & Radius

Uses design system constants:

```dart
AppSpacing.stackXs    // 4px
AppSpacing.stackSm    // 8px
AppSpacing.stackMd    // 16px
AppSpacing.stackLg    // 24px
AppSpacing.borderWidth // 1px

AppRadius.radiusSm    // 4px (inputs, buttons)
AppRadius.cardRadius  // 12px (form card)
```

## State Management

The LoginScreen is a StatefulWidget that manages:

```dart
_emailController        // TextEditingController for email input
_passwordController     // TextEditingController for password input
_showPassword           // bool for password visibility toggle
_isLoading              // bool for button loading state
```

## User Interactions

### Email Field
- Type email address
- Auto-focus support
- Keyboard type: emailAddress

### Password Field
- Type password (masked by default)
- Tap eye icon to toggle visibility
- Tap "reset" link for password reset flow (TODO)

### Sign In Button
- Tap to initiate login
- Shows loading spinner during request
- Button is disabled while loading
- 2-second simulated delay (placeholder logic)

### Register Link
- Tap to navigate to registration screen (TODO)

## Placeholder TODOs

These need implementation:

```dart
// 1. Password reset flow
void _handlePasswordReset() {
  // TODO: Navigate to password reset screen
}

// 2. Sign in authentication
void _handleLoginPressed() {
  // TODO: Implement Firebase authentication
  // TODO: Navigate to home screen based on user role
}

// 3. Register navigation
void _handleRegisterTapped() {
  // TODO: Navigate to registration screen
}
```

## Testing Checklist

- [ ] Run on Flutter Web: `flutter run -d chrome`
- [ ] Check responsive layout on various screen widths
- [ ] Email field accepts input
- [ ] Password field masks input
- [ ] Password visibility toggle works
- [ ] Sign In button shows loading state
- [ ] Loading spinner displays correctly
- [ ] Colors match Figma exactly
- [ ] Typography matches Figma (Inter font)
- [ ] Spacing matches design (4px unit)
- [ ] Grid overlay is subtle (3% opacity)
- [ ] Glow effect on shield icon
- [ ] Focus states on inputs (teal border)
- [ ] Form card shadow is present
- [ ] Register link is clickable
- [ ] Reset link is clickable

## Browser Compatibility

✅ Flutter Web optimized:
- Responsive layout scales to viewport
- SingleChildScrollView prevents overflow on small screens
- Keyboard input fully supported
- Loading spinner renders smoothly
- SVG-ready for custom icons

## Performance Notes

- Grid painting is optimized with CustomPainter
- No unnecessary rebuilds (proper setState scope)
- TextEditingControllers properly disposed
- Shadow calculations use efficient Material approach

## Next Steps

1. Create RegisterScreen following same design pattern
2. Implement Firebase Authentication
3. Add role-based routing after login
4. Create password reset flow
5. Add form validation with error messages
6. Implement remember me checkbox
7. Add biometric login option (future)

---

**Design Source**: Figma SafeCity Project (node-id: 2-336)  
**Implementation Date**: 2026-06-19  
**Design System**: Stitch v1.0.0
