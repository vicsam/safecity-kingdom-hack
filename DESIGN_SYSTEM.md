# SafeCity Mission Control Design System

## Overview
Complete implementation of the SafeCity design system from official Stitch design tokens. Optimized for long-term incident monitoring with a deep "obsidian teal" foundation.

## Color Palette
All colors derived from Stitch DESIGN.md, organized by Material 3 semantic categories.

### Primary Colors (Teal Accents)
- **Primary Bright**: `#68FADD` - High-importance data visualizations, active states
- **Primary**: `#44DDC1` - Primary container & button backgrounds  
- **Primary Dark**: `#006B5B` - Darker variant for contrast
- **Button Primary**: `#00BFA5` - Primary button fill (slightly more saturated)

### Surface & Backgrounds
- **Background**: `#0E1513` - Master canvas (deepest)
- **Surface**: `#0E1513` - Primary content containers
- **Surface Dim**: `#0E1513` - Darkest surface variant
- **Surface Container Lowest**: `#09100E` - Inputs, lowest elevation
- **Surface Container Low**: `#161D1B` - Low elevation elements
- **Surface Container**: `#1A211F` - Standard container
- **Surface Container High**: `#242B29` - Elevated containers
- **Surface Container Highest**: `#2F3634` - Highest elevation

### Text Colors
- **On Surface**: `#DDE4E0` - Primary text color
- **On Surface Variant**: `#BBCAC4` - Secondary text color
- **Text Tertiary**: `#85948F` - Disabled/hint text

### Borders & Outlines
- **Outline**: `#85948F` - Primary outline/borders
- **Outline Variant**: `#3C4A46` - Muted borders (card borders, dividers)

### Semantic Colors
- **Error**: `#FFB4AB` - Error/alert states
- **Error Container**: `#93000A` - Error background
- **Tertiary**: `#FFDDB9` - Secondary accent (orange/amber)
- **Tertiary Container**: `#FFEB3B` - Tertiary background

### Status Indicators
- **Active**: Primary teal - Online/active status
- **Warning**: Tertiary orange - Warning/attention
- **Error**: Error red - Critical alerts
- **Success**: `#43A047` - Resolved/success

## Typography System

All typography uses **Inter** font family exclusively.

### Scale Definitions
```
Display Large  | 48px, 700, line-height 56px, -0.02em
Headline Large | 32px, 600, line-height 40px, -0.01em
Headline Mobile| 24px, 600, line-height 32px
Title Medium   | 20px, 600, line-height 28px
Body Large     | 16px, 400, line-height 24px
Body Small     | 14px, 400, line-height 20px
Label Caps     | 12px, 700, line-height 16px, 0.05em
Mono Data      | 13px, 500, line-height 16px, 0.01em
```

### Usage
- **Display Large**: Page titles, hero content
- **Headline Large**: Section headers, dashboard titles
- **Title Medium**: Card titles, button labels
- **Body Large/Small**: Standard text content, descriptions
- **Label Caps**: Metadata, category tags, small UI markers
- **Mono Data**: Real-time counters, coordinates, technical data

## Layout & Spacing

### Base Unit: 4px
Tight spacing rhythm supports high-density mission-control layouts.

### Spacing Scale
- **XS**: 4px (1 unit)
- **SM**: 8px (2 units)
- **MD**: 16px (4 units) - Standard gutter
- **LG**: 24px (6 units) - Standard margin

### Responsive Breakpoints
- **Mobile**: < 768px - Single column, 16px margins
- **Tablet**: 768px - 1024px - 6-column layout, nav collapses
- **Desktop**: > 1024px - Full 12-column, persistent sidebars

### Container
- **Max Width**: 1440px
- **Gutter Width**: 16px
- **Card Padding**: 24px

## Border Radius

Shape language is precise and varied for functional recognition.

```
Small       | 4px   | Small components
Default     | 8px   | Buttons, inputs (tooled appearance)
Medium      | 12px  | Cards (softened appearance)
Large       | 16px  | Dialogs, modals
Extra Large | 24px  | Large containers
Pill        | 20px  | Chips, status indicators (immediate distinction)
```

## Elevation & Depth

**No traditional drop shadows.** Depth conveyed through:

### Tonal Layering
- **Layer 0**: Background (`#0E1513`) - Master canvas
- **Layer 1**: Surface (`#0E1513`) - Primary containers, 1px border
- **Layer 2**: Elevated (`#1B2D2C`) - Popovers, tooltips, modals

### Glow Effects
- **Subtle**: `rgba(68, 221, 193, 0.09)` - Understated glow
- **Active**: `rgba(68, 221, 193, 0.15)` - Critical/active status
- **Pulsing**: Network status indicators (4-8px circles)

## Components

### Buttons
- **Primary**: `#00BFA5` fill, dark text
- **Ghost**: `#44DDC1` border & text (no fill)
- **Radius**: 8px (tooled appearance)
- **Padding**: 24px horizontal × 12px vertical

### Input Fields
- **Background**: `#09100E` (surface container lowest)
- **Border**: 1px `#3C4A46` (outline variant)
- **Focus**: Primary teal border with subtle glow
- **Radius**: 8px
- **Padding**: 16px × 12px

### Cards
- **Background**: `#1A211F` (surface container)
- **Border**: 1px `#3C4A46` (outline variant)
- **Radius**: 12px (softened)
- **Header**: 1px bottom border to separate content
- **Padding**: 24px

### Chips
- **Shape**: Pill (20px radius)
- **Font**: Label Caps (12px, 700)
- **Background**: `#242B29` (surface container high)
- **Border**: 1px `#3C4A46`
- **Padding**: 12px × 6px

### Data Lists
- **Rows**: Alternating subtle background tints
- **High-Priority**: Vertical accent bar on left edge (primary color)
- **Dividers**: 1px `#3C4A46` strokes

### Network Status Indicators
- **Size**: 4px-8px pulsing circles
- **Color**: Primary teal for "online"
- **Animation**: Subtle pulse to show real-time connection

### Data Visualizations
- **Lines**: Primary teal `#44DDC1`
- **Fill**: Translucent gradient below line
- **Grid**: Subtle outline variant lines

## File Structure

```
lib/core/theme/
├── app_colors.dart      # 50+ color tokens (Material 3 + semantic)
├── app_theme.dart       # Complete ThemeData configuration
├── app_spacing.dart     # 4px base unit + layout grid
└── app_radius.dart      # Border radius system + component shapes
```

## Design Principles

### Mission Control Aesthetic
- **High Information Density**: Utilitarian precision meets refined finish
- **Real-Time Responsiveness**: Visual cues emphasize connectivity
- **Reliability**: Absolute confidence in the UI through consistent design
- **Low Eye Strain**: Deep obsidian teal minimizes fatigue during monitoring

### Accessibility
- **High Contrast**: Text colors tinted with primary hue for legibility
- **Semantic Feedback**: Critical alerts pierce through dark interface immediately
- **Tabular Numerics**: Inter's tabular properties prevent layout shift during data updates
- **Functional Shapes**: Distinct radii help users scan and recognize components

## Usage Examples

### Colors
```dart
// Always reference AppColors, never hardcode hex
Container(
  color: AppColors.surfaceContainer,
  border: Border.all(color: AppColors.outlineVariant),
)
```

### Spacing
```dart
Padding(
  padding: EdgeInsets.all(AppSpacing.stackMd), // 16px
  child: ...
)
```

### Border Radius
```dart
// Cards: medium radius
Card(
  shape: RoundedRectangleBorder(
    borderRadius: AppRadius.cardRadius, // 12px
  ),
)

// Chips: pill shape
Chip(
  shape: RoundedRectangleBorder(
    borderRadius: AppRadius.chipBorderRadius, // 20px
  ),
)
```

### Typography
```dart
// Use TextStyle constants from AppTheme
Text(
  'Incident Report',
  style: AppTheme.headlineLarge,
)

// For custom styling, copy and modify
Text(
  'Active',
  style: AppTheme.labelLarge.copyWith(
    color: AppColors.statusActive,
  ),
)
```

## Notes

- All colors use Material 3 naming conventions for compatibility
- Typography scales to Inter font exclusively (installed as system font)
- Spacing is 4px-based for pixel-perfect alignment
- Border radius is component-aware (cards vs buttons vs chips)
- No shadows: depth via tonal layering + subtle glows
- Glow effects use primary teal with controlled opacity
- Responsive breakpoints are CSS-aligned (768px, 1024px)

---

**Design System Version**: 1.0.0  
**Based on**: Stitch SafeCity Mission Control (2026-06-19)  
**Updated**: 2026-06-19
