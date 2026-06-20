// ════════════════════════════════════════════════
// SAFECITY — COLOR USAGE RULES
// Read this before implementing any screen
// ════════════════════════════════════════════════

// BACKGROUNDS
// AppColors.background     → Scaffold background on ALL screens
// AppColors.surface        → All cards, bottom sheets, form cards
// AppColors.surfaceRaised  → Cards inside cards, elevated sections
// AppColors.surfaceOverlay → Drawers, modals, dialogs

// PRIMARY TEAL — USE SPARINGLY
// AppColors.primary        → Logo, active nav icons, focus rings,
//                            active tab underlines, links
// AppColors.primaryDark    → ALL buttons (Sign In, Submit,
//                            Acknowledge, Assign Now, Create)
// AppColors.primaryDarker  → Button pressed/splash state only
// AppColors.primaryGlow    → BoxShadow color on logo/shield only

// SEMANTIC COLORS — STATUS ONLY
// AppColors.danger         → ESCALATED chip, Critical priority chip,
//                            Sign Out button border+text,
//                            escalation card left border
// AppColors.dangerSurface  → Background of escalated/critical cards
// AppColors.warning        → HIGH priority chip, warning states,
//                            unacknowledged timer text
// AppColors.warningSurface → Background of high priority cards
// AppColors.success        → RESOLVED chip, Online status dot,
//                            Active responder chip
// AppColors.successSurface → Background of resolved cards
// AppColors.info           → ACKNOWLEDGED chip, info states

// TEXT
// AppColors.textPrimary    → ALL headlines, incident titles,
//                            card titles, page titles
// AppColors.textSecondary  → Labels, timestamps, location text,
//                            form field labels, metadata
// AppColors.textTertiary   → Placeholder text, disabled states,
//                            hint text in inputs
// AppColors.textInverse    → Text ON teal buttons (Sign In text,
//                            Acknowledge text, Submit text)

// BORDERS
// AppColors.border         → Default border on ALL cards and inputs
// AppColors.borderStrong   → Input border on FOCUS state only
// AppColors.divider        → Horizontal dividers between list items

// INCIDENT CATEGORY COLORS
// Use ONLY as left border accent (4px width) on incident cards:
// AppColors.fire           → Fire incident cards
// AppColors.security       → Security incident cards
// AppColors.medical        → Medical incident cards
// AppColors.electrical     → Electrical incident cards
// AppColors.roads          → Road incident cards
// AppColors.maintenance    → Maintenance request cards
// NEVER use these as backgrounds or text colors

// SIDEBAR (desktop roles only)
// AppColors.sidebarBg      → Sidebar container background
// AppColors.sidebarActive  → Active navigation item background
// AppColors.sidebarBadge   → Notification count badge background

// ════════════════════════════════════════════════
// RULES TO NEVER BREAK
// ════════════════════════════════════════════════
// 1. NEVER hardcode a hex value anywhere in the app
// 2. NEVER use AppColors.primary as a button color
//    (use AppColors.primaryDark for buttons)
// 3. NEVER use danger/warning/success for decoration
//    (only for actual status communication)
// 4. NEVER use incident category colors as text or bg
//    (only as 4px left border accents)
// 5. ALWAYS use AppColors.textInverse for text
//    that sits on a teal/primary background
// ════════════════════════════════════════════════
