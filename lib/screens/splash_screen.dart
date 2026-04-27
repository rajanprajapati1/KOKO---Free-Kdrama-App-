import 'package:flutter/material.dart';
import '../theme/koko_theme.dart';
import '../data/content_data.dart';
import '../data/koko_profile.dart';
import 'nav_screen.dart';

// ══════════════════════════════════════════════════════════════════════════════
// Splash Screen
// ══════════════════════════════════════════════════════════════════════════════
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 2600), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const ProfileSelectionScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 700),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SizedBox.expand(
          child: Image.asset(
            'image.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Profile data model
// ══════════════════════════════════════════════════════════════════════════════
class _Profile {
  final String name;
  final String avatarUrl;
  final Color accentColor;

  const _Profile({
    required this.name,
    required this.avatarUrl,
    required this.accentColor,
  });
}

// ══════════════════════════════════════════════════════════════════════════════
// Who's Watching? — Netflix-style full-bleed profile picker
// ══════════════════════════════════════════════════════════════════════════════
class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({super.key});

  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  int? _selectedIndex;

  static const _profiles = [
    _Profile(
      name: 'Jungkook',
      avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/memojis/png/3d_4.png',
      accentColor: Color(0xFF87DCFF),
    ),
    _Profile(
      name: 'Mina',
      avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/memojis/png/vibrent_10.png',
      accentColor: Color(0xFFFF87B9),
    ),
    _Profile(
      name: 'Taehyung',
      avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/memojis/png/vibrent_6.png',
      accentColor: Color(0xFFB49EFF),
    ),
    _Profile(
      name: 'Chaeyoung',
      avatarUrl: 'https://cdn.jsdelivr.net/gh/alohe/memojis/png/vibrent_17.png',
      accentColor: Color(0xFFFFD87B),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  void _onProfileTap(int index) async {
    setState(() => _selectedIndex = index);
    await Future.delayed(const Duration(milliseconds: 380));
    if (!mounted) return;
    final p = _profiles[index];
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => NavScreen(
          selectedProfile: KokoProfile(
            name: p.name,
            avatarUrl: p.avatarUrl,
          ),
        ),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),

              // ── Title ──────────────────────────────────────────────────────
              _FadeSlideIn(
                controller: _entranceController,
                delay: 0.0,
                child: const Text(
                  "Who's watching?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── 2×2 Full-bleed Grid ────────────────────────────────────────
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: _profiles.length,
                  itemBuilder: (context, i) {
                    final delay = 0.08 + i * 0.1;
                    return _FadeSlideIn(
                      controller: _entranceController,
                      delay: delay.clamp(0.0, 0.8),
                      child: _NetflixProfileCard(
                        profile: _profiles[i],
                        isSelected: _selectedIndex == i,
                        onTap: () => _onProfileTap(i),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Netflix-style Profile Card
// Avatar image fills 100% of card. Name overlaid via bottom gradient scrim.
// ══════════════════════════════════════════════════════════════════════════════
class _NetflixProfileCard extends StatefulWidget {
  final _Profile profile;
  final bool isSelected;
  final VoidCallback onTap;

  const _NetflixProfileCard({
    required this.profile,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NetflixProfileCard> createState() => _NetflixProfileCardState();
}

class _NetflixProfileCardState extends State<_NetflixProfileCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  bool _pressing = false;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
      reverseDuration: const Duration(milliseconds: 220),
      lowerBound: 0.94,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isSelected || _pressing;

    return GestureDetector(
      onTapDown: (_) {
        _scaleCtrl.reverse();
        setState(() => _pressing = true);
      },
      onTapUp: (_) {
        _scaleCtrl.forward();
        setState(() => _pressing = false);
        widget.onTap();
      },
      onTapCancel: () {
        _scaleCtrl.forward();
        setState(() => _pressing = false);
      },
      child: ScaleTransition(
        scale: _scaleCtrl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ClipRect(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // ── Background gradient fill ────────────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            widget.profile.accentColor.withValues(alpha: 0.20),
                            const Color(0xFF0D0D0D),
                          ],
                        ),
                      ),
                    ),

                    // ── Avatar image: full-bleed ────────────────────────────────
                    Positioned.fill(
                      child: Image.network(
                        widget.profile.avatarUrl,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.person,
                          color: Colors.white30,
                          size: 80,
                        ),
                      ),
                    ),

                    // ── Selected checkmark badge ────────────────────────────────
                    if (widget.isSelected)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: widget.profile.accentColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.black,
                            size: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // ── Name below card ─────────────────────────────────────────────
            const SizedBox(height: 8),
            Text(
              widget.profile.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isActive ? widget.profile.accentColor : Colors.white70,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Add Profile — squared button at bottom
// ══════════════════════════════════════════════════════════════════════════════
class _AddProfileButton extends StatefulWidget {
  const _AddProfileButton();

  @override
  State<_AddProfileButton> createState() => _AddProfileButtonState();
}

class _AddProfileButtonState extends State<_AddProfileButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.91 : 1.0,
        duration: const Duration(milliseconds: 110),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: _pressed
                  ? KokoColors.primary
                  : Colors.white.withValues(alpha: 0.18),
              width: 1.8,
            ),
            color: _pressed
                ? KokoColors.primary.withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.05),
            boxShadow: _pressed
                ? [
                    BoxShadow(
                      color: KokoColors.primary.withValues(alpha: 0.38),
                      blurRadius: 22,
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Icon(
              Icons.add_rounded,
              color: _pressed ? KokoColors.primary : Colors.white54,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Fade + slide entrance animation helper
// ══════════════════════════════════════════════════════════════════════════════
class _FadeSlideIn extends StatelessWidget {
  final AnimationController controller;
  final double delay;
  final Widget child;

  const _FadeSlideIn({
    required this.controller,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final end = (delay + 0.45).clamp(0.0, 1.0);
    final curve = Interval(delay, end, curve: Curves.easeOutCubic);

    final fade = CurvedAnimation(parent: controller, curve: curve);
    final slide = Tween<Offset>(
      begin: const Offset(0, 0.14),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: curve));

    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: child),
    );
  }
}
