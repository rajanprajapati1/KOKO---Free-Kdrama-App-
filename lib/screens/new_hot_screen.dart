import 'package:flutter/material.dart';
import '../theme/koko_theme.dart';
import '../data/content_data.dart';
import '../data/api_service.dart';
import 'home_screen.dart' show openDetail;
import '../widgets/compact_poster.dart';

class NewHotScreen extends StatefulWidget {
  const NewHotScreen({super.key});

  @override
  State<NewHotScreen> createState() => _NewHotScreenState();
}

class _NewHotScreenState extends State<NewHotScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? KokoColors.background : KokoColors.lightBackground;
    final titleColor = isDark ? Colors.white : KokoColors.lightTextPrimary;
    final iconColor = isDark ? Colors.white : KokoColors.lightTextPrimary;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'New & Hot 🔥',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: titleColor,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.notifications_outlined, color: iconColor),
                  ),
                ],
              ),
            ),
            TabBar(
              controller: _tab,
              indicatorColor: KokoColors.primary,
              labelColor: isDark ? Colors.white : KokoColors.lightTextPrimary,
              unselectedLabelColor:
                  isDark ? Colors.white38 : KokoColors.lightTextSecondary,
              labelStyle: const TextStyle(fontWeight: FontWeight.w700),
              tabs: const [
                Tab(text: 'Coming Soon'),
                Tab(text: "Everyone's Watching"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: const [
                  _ComingSoonList(),
                  _EverythingWatchingList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Coming Soon ────────────────────────────────────────────────────────────────
class _ComingSoonList extends StatefulWidget {
  const _ComingSoonList();

  @override
  State<_ComingSoonList> createState() => _ComingSoonListState();
}

class _ComingSoonListState extends State<_ComingSoonList>
    with AutomaticKeepAliveClientMixin {
  List<KDramaContent> _items = [];
  bool _loading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ApiService.getUpcoming();
    if (mounted) setState(() { _items = data; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : KokoColors.lightTextPrimary;

    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: KokoColors.primary),
      );
    }

    if (_items.isEmpty) {
      return Center(
        child: Text(
          'Nothing upcoming right now',
          style: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
        ),
      );
    }

    return RefreshIndicator(
      color: KokoColors.primary,
      onRefresh: () async {
        ApiService.clearCache();
        await _load();
      },
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        itemBuilder: (ctx, i) {
          final c = _items[i];
          // c.year holds the label e.g. "Coming Apr 27"
          final label = c.year.isNotEmpty ? c.year : 'Coming Soon';

          return GestureDetector(
            onTap: () => openDetail(ctx, c),
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Banner image ──────────────────────────────────────────
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            c.backdropUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(color: KokoColors.surfaceVariant),
                          ),
                          // ── Action icons ──────────────────────────────────
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Row(
                              children: const [
                                Icon(Icons.notifications_outlined,
                                    color: Colors.white, size: 20),
                                SizedBox(width: 14),
                                Icon(Icons.info_outline,
                                    color: Colors.white, size: 20),
                              ],
                            ),
                          ),
                          // ── "Coming Apr 27" label badge ───────────────────
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: KokoColors.primary,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    c.title,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    c.seasons,
                    style: const TextStyle(
                      color: KokoColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Everyone's Watching ────────────────────────────────────────────────────────
class _EverythingWatchingList extends StatefulWidget {
  const _EverythingWatchingList();

  @override
  State<_EverythingWatchingList> createState() =>
      _EverythingWatchingListState();
}

class _EverythingWatchingListState extends State<_EverythingWatchingList>
    with AutomaticKeepAliveClientMixin {
  List<KDramaContent> _items = [];
  bool _loading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ApiService.getMostViewedMobile();
    if (mounted) setState(() { _items = data; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: KokoColors.primary),
      );
    }

    if (_items.isEmpty) {
      return const Center(
        child: Text("No data", style: TextStyle(color: Colors.white38)),
      );
    }

    return RefreshIndicator(
      color: KokoColors.primary,
      onRefresh: () async {
        ApiService.clearCache();
        await _load();
      },
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.65,
        ),
        itemCount: _items.length,
        itemBuilder: (ctx, i) {
          final c = _items[i];
          return GestureDetector(
            onTap: () => openDetail(ctx, c),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    c.posterUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) =>
                        Container(color: KokoColors.surfaceVariant),
                  ),
                ),
                // ── Rank badge ──────────────────────────────────────────────
                if (c.topTenRank != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [KokoColors.primary, KokoColors.secondary]),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '#${c.topTenRank}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                // ── Title gradient scrim ────────────────────────────────────
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xDD000000)],
                      ),
                    ),
                    child: Text(
                      c.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
