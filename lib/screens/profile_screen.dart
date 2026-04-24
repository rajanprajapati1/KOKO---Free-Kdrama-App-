import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../theme/koko_theme.dart';
import '../data/koko_profile.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  final KokoProfile? profile;
  const ProfileScreen({super.key, this.profile});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _backgroundPlay = true;
  bool _downloadWifi = false;
  bool _autoplay = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Adaptive colors
    final bg = isDark ? KokoColors.background : KokoColors.lightBackground;
    final cardBg = isDark ? KokoColors.surface : KokoColors.lightSurface;
    final labelColor = isDark ? Colors.white54 : KokoColors.lightTextSecondary;
    final titleColor = isDark ? Colors.white : KokoColors.lightTextPrimary;
    final subtitleColor = isDark ? Colors.white54 : KokoColors.lightTextSecondary;
    final dividerColor = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF3F4F6);
    final chevronColor = isDark ? Colors.white24 : const Color(0xFFD1D5DB);
    final cardShadow = isDark
        ? <BoxShadow>[]
        : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))];

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── App Bar ───────────────────────────────────────────
          SliverAppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            pinned: true,
            forceMaterialTransparency: true,
            leading: GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: Icon(Icons.chevron_left, color: titleColor, size: 30),
            ),
            actions: [
              TextButton(
                onPressed: () {},
                child: Text(
                  'Logout',
                  style: TextStyle(color: titleColor, fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
            ],
            title: const SizedBox.shrink(),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 8),

                // ─── Avatar + Name + Email ─────────────────────
                Column(
                  children: [
                    // Avatar — shows selected profile image or fallback
                    Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: widget.profile?.avatarUrl == null
                            ? const LinearGradient(
                                colors: [Color(0xFFFFB3D1), Color(0xFFFF87B9)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: KokoColors.primary.withOpacity(0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: widget.profile != null
                          ? ClipOval(
                              child: Image.network(
                                widget.profile!.avatarUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Text('😊', style: TextStyle(fontSize: 38)),
                                ),
                              ),
                            )
                          : const Center(
                              child: Text('😊', style: TextStyle(fontSize: 38)),
                            ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      widget.profile?.name ?? 'Ryan Schnetzer',
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ryansc@acme.co',
                      style: TextStyle(color: subtitleColor, fontSize: 14),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ─── Edit Profile Button ───────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withOpacity(0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Edit profile',
                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.chevron_right, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ─── Content Section ───────────────────────────
                _SectionLabel(label: 'Content', color: labelColor),
                _Card(bg: cardBg, shadow: cardShadow, children: [
                  _NavRow(
                    icon: Icons.add,
                    iconBg: isDark ? const Color(0xFF1A3A2A) : const Color(0xFFDCFCE7),
                    iconColor: const Color(0xFF16A34A),
                    label: 'Favorites',
                    titleColor: titleColor,
                    chevronColor: chevronColor,
                    onTap: () {},
                  ),
                  _Divider(color: dividerColor),
                  _NavRow(
                    icon: Icons.arrow_downward_rounded,
                    iconBg: isDark ? const Color(0xFF1A1A3A) : const Color(0xFFE0E7FF),
                    iconColor: const Color(0xFF4F46E5),
                    label: 'Downloads',
                    titleColor: titleColor,
                    chevronColor: chevronColor,
                    onTap: () {},
                  ),
                ]),

                const SizedBox(height: 24),

                // ─── Preferences Section ───────────────────────
                _SectionLabel(label: 'Preferences', color: labelColor),
                _Card(bg: cardBg, shadow: cardShadow, children: [
                  _NavRow(
                    icon: Icons.translate_rounded,
                    iconBg: isDark ? const Color(0xFF3A3010) : const Color(0xFFFEF9C3),
                    iconColor: const Color(0xFFCA8A04),
                    label: 'Language',
                    titleColor: titleColor,
                    chevronColor: chevronColor,
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text('English', style: TextStyle(color: subtitleColor, fontSize: 14)),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right, color: chevronColor, size: 20),
                    ]),
                    onTap: () {},
                  ),
                  _Divider(color: dividerColor),
                  _NavRow(
                    icon: Icons.notifications_outlined,
                    iconBg: isDark ? const Color(0xFF3A1010) : const Color(0xFFFEE2E2),
                    iconColor: const Color(0xFFDC2626),
                    label: 'Notifications',
                    titleColor: titleColor,
                    chevronColor: chevronColor,
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text('Enabled', style: TextStyle(color: subtitleColor, fontSize: 14)),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right, color: chevronColor, size: 20),
                    ]),
                    onTap: () {},
                  ),
                  _Divider(color: dividerColor),
                  // ── Theme Toggle Row ────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 34, height: 34,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2A1A3A) : const Color(0xFFF3E8FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.palette_outlined, color: Color(0xFF9333EA), size: 18),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Theme',
                            style: TextStyle(color: titleColor, fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                        // Dark / Light switcher pill
                        GestureDetector(
                          onTap: () {
                            final app = KokoApp.of(context);
                            app.setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            height: 32,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF252525) : const Color(0xFFE5E7EB),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _ThemePill(
                                  icon: Icons.dark_mode_rounded,
                                  label: 'Dark',
                                  isActive: isDark,
                                  activeColor: KokoColors.primary,
                                ),
                                const SizedBox(width: 4),
                                _ThemePill(
                                  icon: Icons.light_mode_rounded,
                                  label: 'Light',
                                  isActive: !isDark,
                                  activeColor: const Color(0xFF2563EB),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),

                const SizedBox(height: 24),

                // ─── Playback Section ─────────────────────────
                _SectionLabel(label: 'Playback', color: labelColor),
                _Card(bg: cardBg, shadow: cardShadow, children: [
                  _ToggleRow(
                    icon: Icons.pause_circle_outline_rounded,
                    iconBg: isDark ? const Color(0xFF0A2030) : const Color(0xFFE0F2FE),
                    iconColor: const Color(0xFF0284C7),
                    label: 'Background play',
                    titleColor: titleColor,
                    value: _backgroundPlay,
                    onChanged: (v) => setState(() => _backgroundPlay = v),
                  ),
                  _Divider(color: dividerColor),
                  _ToggleRow(
                    icon: Icons.wifi_rounded,
                    iconBg: isDark ? const Color(0xFF0A2A1A) : const Color(0xFFDCFCE7),
                    iconColor: const Color(0xFF16A34A),
                    label: 'Download via WiFi only',
                    titleColor: titleColor,
                    value: _downloadWifi,
                    onChanged: (v) => setState(() => _downloadWifi = v),
                  ),
                  _Divider(color: dividerColor),
                  _ToggleRow(
                    icon: Icons.replay_circle_filled_outlined,
                    iconBg: isDark ? const Color(0xFF2A1A00) : const Color(0xFFFEF3C7),
                    iconColor: const Color(0xFFD97706),
                    label: 'Autoplay',
                    titleColor: titleColor,
                    value: _autoplay,
                    onChanged: (v) => setState(() => _autoplay = v),
                  ),
                ]),

                const SizedBox(height: 36),
                Text(
                  'Koko v1.0.0',
                  style: TextStyle(color: subtitleColor, fontSize: 12),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Local Widgets ─────────────────────────────────────────────────────────────

class _ThemePill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;
  const _ThemePill({required this.icon, required this.label, required this.isActive, required this.activeColor});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isActive ? activeColor : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: isActive ? Colors.white : const Color(0xFF9CA3AF)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.3),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Color bg;
  final List<BoxShadow> shadow;
  final List<Widget> children;
  const _Card({required this.bg, required this.shadow, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: shadow,
        ),
        child: Column(children: children),
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final Color titleColor;
  final Color chevronColor;
  final Widget? trailing;
  final VoidCallback onTap;

  const _NavRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.titleColor,
    required this.chevronColor,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: titleColor, fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            trailing ?? Icon(Icons.chevron_right, color: chevronColor, size: 20),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final Color titleColor;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.titleColor,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: titleColor, fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF2563EB),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final Color color;
  const _Divider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 64),
      child: Divider(height: 1, color: color),
    );
  }
}
