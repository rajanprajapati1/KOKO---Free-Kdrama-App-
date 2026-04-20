import 'package:flutter/material.dart';
import '../theme/koko_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KokoColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Koko',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                const SizedBox(height: 24),
                // Profile avatar
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            colors: [KokoColors.primary, KokoColors.secondary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: KokoColors.primary.withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Y',
                            style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('You', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Switch Profiles',
                          style: TextStyle(color: KokoColors.primary, fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                // Stats row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatBox(value: '12', label: 'My List'),
                    _StatBox(value: '38', label: 'Watched'),
                    _StatBox(value: '5', label: 'Downloads'),
                  ],
                ),
                const SizedBox(height: 28),
                // Settings sections
                _SettingsSection(title: 'Account', items: const [
                  _SettingItem(icon: Icons.person_outline, label: 'Manage Profile'),
                  _SettingItem(icon: Icons.notifications_outlined, label: 'Notifications'),
                  _SettingItem(icon: Icons.language, label: 'Language Preferences'),
                  _SettingItem(icon: Icons.closed_caption_outlined, label: 'Subtitle Settings'),
                ]),
                const SizedBox(height: 16),
                _SettingsSection(title: 'Playback', items: const [
                  _SettingItem(icon: Icons.high_quality_outlined, label: 'Video Quality'),
                  _SettingItem(icon: Icons.download_outlined, label: 'Download Quality'),
                  _SettingItem(icon: Icons.wifi_outlined, label: 'Data Usage'),
                ]),
                const SizedBox(height: 16),
                _SettingsSection(title: 'Support', items: const [
                  _SettingItem(icon: Icons.help_outline, label: 'Help & FAQ'),
                  _SettingItem(icon: Icons.privacy_tip_outlined, label: 'Privacy Policy'),
                  _SettingItem(icon: Icons.article_outlined, label: 'Terms of Use'),
                ]),
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: KokoColors.border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.white54, fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text('Koko v1.0.0', style: TextStyle(color: Colors.white24, fontSize: 12)),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  const _StatBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 72,
      decoration: BoxDecoration(
        color: KokoColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: const TextStyle(
                  color: KokoColors.primary, fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(color: Colors.white54, fontSize: 11)),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingItem> items;
  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: KokoColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: List.generate(items.length, (i) {
              return Column(
                children: [
                  items[i],
                  if (i < items.length - 1)
                    const Divider(color: Color(0xFF2A2A2A), height: 1, indent: 48),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SettingItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.white54, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
            ),
            const Icon(Icons.chevron_right, color: Colors.white24, size: 20),
          ],
        ),
      ),
    );
  }
}
