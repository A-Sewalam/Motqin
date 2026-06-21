/// Single source of truth for all SharedPreferences keys used in the
/// Block Distractions feature. Import this instead of hardcoding strings.
class BlockPrefsKeys {
  BlockPrefsKeys._();

  // ── Block session (used by TimedBlockService) ──────────────────────
  static const blockIsActive  = 'block_is_active';
  static const blockStartTime = 'block_start_time';
  static const blockEndTime   = 'block_end_time';
  static const blockMode      = 'block_mode';

  // ── App selection (used by RestrictAppUsageWidget) ─────────────────
  static const allowedPackages = 'allowed_packages_during_block';

  // ── One-time permission flags (used by BlockDistractionsScreen) ────
  static const accessibilityAsked = 'accessibility_permission_asked';
  static const deviceAdminAsked   = 'device_admin_asked';
  static const overlayAsked       = 'overlay_permission_asked';
}
