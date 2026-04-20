import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../theme/koko_theme.dart';
import '../data/content_data.dart';
import '../data/api_service.dart';
import '../widgets/content_poster.dart';
import '../widgets/top_ten_row.dart';
import '../widgets/compact_poster.dart';
import 'detail_screen.dart';
import 'search_screen.dart';
import 'package:material_symbols_icons/symbols.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  
  bool _isLoading = true;
  KDramaContent? _heroContent;
  List<KDramaContent> _trendingList = [];
  List<KDramaContent> _newlyAddedList = [];
  List<KDramaContent> _topRatingList = [];
  List<KDramaContent> _animateList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final futures = await Future.wait([
      ApiService.getLastUpdate(),
      ApiService.getMostViewedC2(),
      ApiService.getMostViewedC1(),
      ApiService.getTopRating(),
      ApiService.getAnimate(),
    ]);

    if (mounted) {
      setState(() {
        _newlyAddedList = futures[0];
        _trendingList = futures[1];
        
        final c1List = futures[2];
        if (c1List.isNotEmpty) {
          _heroContent = c1List.first;
        } else {
          _heroContent = heroContent;
        }

        _topRatingList = futures[3];
        _animateList = futures[4];
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Top-level Scaffold with no app bar, gradient background
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4F6D6D), // Teal gray start
              Color(0xFF0F1A1A), // Dark bottom
            ],
            stops: [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // 1. Header (For You + Icons)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "For You",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Symbols.download, color: Colors.white, size: 28),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) => const SearchScreen(),
                                      transitionsBuilder: (_, anim, __, child) =>
                                          FadeTransition(opacity: anim, child: child),
                                      transitionDuration: const Duration(milliseconds: 250),
                                    ),
                                  );
                                },
                                child: const Icon(Symbols.search, color: Colors.white, size: 28),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  // 2. Filter Chips
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: const [
                          _FilterChip(label: "Series"),
                          SizedBox(width: 12),
                          _FilterChip(label: "Films"),
                          SizedBox(width: 12),
                          _FilterChip(label: "Categories", hasDropdown: true),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // 3. Featured Main Hero Card
                  if (_heroContent != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _HeroCard(content: _heroContent!),
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),

                  // 4. Section: Top 10 Today
                  if (_trendingList.isNotEmpty) ...[
                    const SliverToBoxAdapter(
                      child: _SectionTitle("Top 10 K-Dramas Today"),
                    ),
                    SliverToBoxAdapter(
                      child: TopTenRow(items: _trendingList.take(10).toList()),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],

                  // 5. Section: Newly Added
                  if (_newlyAddedList.isNotEmpty) ...[
                    const SliverToBoxAdapter(
                      child: _SectionTitle("Newly Added"),
                    ),
                    SliverToBoxAdapter(
                      child: _PosterCarousel(items: _newlyAddedList),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],

                  // 6. Section: Top Rated
                  if (_topRatingList.isNotEmpty) ...[
                    const SliverToBoxAdapter(
                      child: _SectionTitle("Top Rated Masterpieces"),
                    ),
                    SliverToBoxAdapter(
                      child: _PosterCarousel(items: _topRatingList),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],

                  // 7. Section: Anime
                  if (_animateList.isNotEmpty) ...[
                    const SliverToBoxAdapter(
                      child: _SectionTitle("Anime Hits"),
                    ),
                    SliverToBoxAdapter(
                      child: _PosterCarousel(items: _animateList),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],

                  const SliverToBoxAdapter(child: SizedBox(height: 90)),
                ],
              ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// UI Components Based on Prompt
// ─────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool hasDropdown;

  const _FilterChip({required this.label, this.hasDropdown = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            if (hasDropdown) ...[
              const SizedBox(width: 4),
              const Icon(Symbols.keyboard_arrow_down, size: 16, color: Colors.white),
            ]
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final KDramaContent content;
  const _HeroCard({required this.content});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openDetail(context, content),
      child: Container(
        width: double.infinity,
        height: 460, // Slightly taller for more immersive feel
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // Subtle, ultra-thin border for a clean edge on dark backgrounds
          border: Border.all(
            color: Colors.white.withOpacity(0.12),
            width: 0.5,
          ),
          boxShadow: [
            // Deep ambient shadow
            BoxShadow(
              color: Colors.black.withOpacity(0.7),
              blurRadius: 40,
              spreadRadius: -10,
              offset: const Offset(0, 20),
            ),
            // Sharp close shadow
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(19.5), // Accounts for 0.5px border
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. IMAGE
              Image.network(
                content.backdropUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2A2A2A), Color(0xFF111111)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              // 2. DARK OVERLAY (BOTTOM FADE)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.95),
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.3, 0.6, 1.0],
                  ),
                ),
              ),
              // 3. LOGO (TOP LEFT)
              const Positioned(
                top: 16,
                left: 16,
                child: Text(
                  "K",
                  style: TextStyle(
                    color: Color(0xFFFF87B9), // Pastel Pink Koko accent
                    fontWeight: FontWeight.w900,
                    fontSize: 26,
                    letterSpacing: -1,
                  ),
                ),
              ),
              // 4. TITLE TEXT (CENTER BOTTOM)
              Positioned(
                bottom: 120,
                left: 20,
                right: 20,
                child: Text(
                  content.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              // 5. TAGLINE
              Positioned(
                bottom: 90,
                left: 0,
                right: 0,
                child: Text(
                  "Streaming Now • HD • Hit Series",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              // 6. ACTION BUTTONS
              Positioned(
                bottom: 24,
                left: 20,
                right: 20,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Symbols.play_arrow, color: Colors.black, size: 28),
                            SizedBox(width: 6),
                            Text("Play", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15), // Slightly cleaner button transparency
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1), // Crisp edge for button
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Symbols.add, color: Colors.white),
                            SizedBox(width: 6),
                            Text("My List", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}

class _PosterCarousel extends StatelessWidget {
  final List<KDramaContent> items;
  const _PosterCarousel({required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (ctx, i) {
          final content = items[i];
          return SizedBox(
            width: 110,
            child: CompactPoster(
              content: content,
              showNewBadge: i < 3, // Optional logic: Show "New" badge for first 3 items
            ),
          );
        },
      ),
    );
  }
}

void openDetail(BuildContext context, KDramaContent content) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => DetailScreen(content: content),
      transitionsBuilder: (_, anim, __, child) =>
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
            child: child,
          ),
      transitionDuration: const Duration(milliseconds: 350),
    ),
  );
}
