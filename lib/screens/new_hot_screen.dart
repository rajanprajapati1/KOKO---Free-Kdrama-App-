import 'package:flutter/material.dart';
import '../theme/koko_theme.dart';
import '../data/content_data.dart';
import '../widgets/content_poster.dart';
import 'home_screen.dart' show openDetail;

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
    return Scaffold(
      backgroundColor: KokoColors.background,
      body: SafeArea(child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Row(children: [
            const Expanded(
              child: Text(
                'New & Hot 🔥',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            ),
          ]),
        ),
        TabBar(
          controller: _tab,
          indicatorColor: KokoColors.primary,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white38,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700),
          tabs: const [Tab(text: 'Coming Soon'), Tab(text: 'Everyone\'s Watching')],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _ComingSoonList(),
              _EverythingWatchingList(),
            ],
          ),
        ),
      ])),
    );
  }
}

class _ComingSoonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = romancePicksContent;
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (ctx, i) {
        final c = items[i];
        return GestureDetector(
          onTap: () => openDetail(ctx, c),
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Poster thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(fit: StackFit.expand, children: [
                    Image.network(
                      c.backdropUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: KokoColors.surfaceVariant),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Row(children: [
                        const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
                        const SizedBox(width: 14),
                        const Icon(Icons.info_outline, color: Colors.white, size: 20),
                      ]),
                    ),
                    // "Coming" badge
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: KokoColors.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text('Coming Soon', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 10),
              Text(c.title,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text(c.genres.join(' • '),
                  style: const TextStyle(color: KokoColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(c.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white54, fontSize: 13, height: 1.5)),
            ]),
          ),
        );
      },
    );
  }
}

class _EverythingWatchingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [...trendingNow, ...newlyAddedContent];
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.65,
      ),
      itemCount: items.length,
      itemBuilder: (ctx, i) => GestureDetector(
        onTap: () => openDetail(ctx, items[i]),
        child: Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              items[i].posterUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, __, ___) => Container(color: KokoColors.surfaceVariant),
            ),
          ),
          if (items[i].topTenRank != null)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [KokoColors.primary, KokoColors.secondary]),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  '#${items[i].topTenRank}',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900),
                ),
              ),
            ),
          if (items[i].isNew)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: KokoColors.accent,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text('NEW', style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.w900)),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xDD000000)],
                ),
              ),
              child: Text(
                items[i].title,
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
