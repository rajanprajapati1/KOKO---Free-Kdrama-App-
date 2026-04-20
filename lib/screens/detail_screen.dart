import 'package:flutter/material.dart';
import '../theme/koko_theme.dart';
import '../data/content_data.dart';
import '../widgets/content_poster.dart';
import '../data/api_service.dart';
import 'video_player_screen.dart';
import 'home_screen.dart' show openDetail;
import '../widgets/compact_poster.dart';

class DetailScreen extends StatefulWidget {
  final KDramaContent content;
  const DetailScreen({super.key, required this.content});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _inMyList = false;
  DramaDetail? _detailData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    final detail = await ApiService.getDramaDetails(widget.content.id);
    if (mounted) {
      setState(() {
        _detailData = detail;
        _isLoading = false;
      });
    }
  }

  Future<void> _playEpisode(Episode episode, String title) async {
    // Show loading overlay
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: KokoColors.primary),
      ),
    );

    try {
      final videos = await ApiService.getEpisodeVideo(episode.id);
      final subs = await ApiService.getEpisodeSubtitles(episode.id);

      if (!mounted) return;
      Navigator.pop(context); // Remove loading

      // Even if videos list is empty (because API response is encrypted hex),
      // we navigate to VideoPlayerScreen and pass the episode & dramaId.
      // VideoPlayerScreen will construct the video URL.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(
            title: title,
            videoUrl: videos.isNotEmpty ? videos.first.url : "",
            subtitles: subs,
            dramaId: widget.content.id,
            episode: episode,
          ),
        ),
      );
    } catch (e) {
      if (mounted) Navigator.pop(context);
      print('Error playing: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.content;
    return Scaffold(
      backgroundColor: KokoColors.background,
      body: Column(
        children: [
          // ── Hero banner ──
          Stack(
            children: [
              SizedBox(
                height: 260,
                width: double.infinity,
                child: Image.network(
                  c.backdropUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: KokoColors.surfaceVariant),
                ),
              ),
              // Fade to bottom
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, KokoColors.background],
                      stops: [0.55, 1.0],
                    ),
                  ),
                ),
              ),
              // Close button
              Positioned(
                top: 48,
                right: 14,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A).withOpacity(0.85),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
              // Volume icon
              Positioned(
                bottom: 14,
                right: 14,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white54),
                    ),
                    child: const Icon(
                      Icons.volume_up,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // ── Scrollable body ──
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand + Title
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [KokoColors.primary, KokoColors.secondary],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'KOKO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      c.title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          _detailData != null
                              ? _detailData!.releaseDate.split('-').first
                              : c.year,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white38),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            _detailData != null
                                ? _detailData!.status
                                : c.rating,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _detailData != null
                              ? '${_detailData!.episodes.length} Episodes'
                              : c.seasons,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white38),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: const Text(
                            'HD',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Resume button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_detailData != null &&
                              _detailData!.episodes.isNotEmpty) {
                            _playEpisode(_detailData!.episodes.first, c.title);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.play_arrow, size: 22),
                        label: const Text(
                          'Play',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Download button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2A2A2A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.download_outlined, size: 22),
                        label: const Text(
                          'Download',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Episode in progress
                    Text(
                      c.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: 0.45,
                        backgroundColor: KokoColors.surfaceVariant,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          KokoColors.primary,
                        ),
                        minHeight: 3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '28m remaining',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    // Description
                    _isLoading
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: KokoColors.primary,
                                ),
                              ),
                            ),
                          )
                        : Text(
                            _detailData?.description ?? c.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                    const SizedBox(height: 6),
                    Text(
                      'Cast: Hyun Bin, Son Ye-jin ... more',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Action icons row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _IconAction(
                          icon: _inMyList ? Icons.check : Icons.add,
                          label: 'My List',
                          onTap: () => setState(() => _inMyList = !_inMyList),
                          color: _inMyList ? KokoColors.primary : Colors.white,
                        ),
                        const _IconAction(
                          icon: Icons.thumb_up_outlined,
                          label: 'Rate',
                        ),
                        const _IconAction(
                          icon: Icons.send_outlined,
                          label: 'Share',
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Tabs
                    TabBar(
                      controller: _tabController,
                      indicatorColor: KokoColors.primary,
                      indicatorWeight: 2.5,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white38,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                      tabs: const [
                        Tab(text: 'Episodes'),
                        Tab(text: 'More Like This'),
                        Tab(text: 'Trailers & More'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Tab content preview
                    SizedBox(
                      height: 300, // Slightly taller since it scrolls
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: KokoColors.primary,
                                  ),
                                )
                              : _EpisodesTab(
                                  title: c.title,
                                  episodes: _detailData?.episodes ?? [],
                                  onEpisodeTap: (ep) =>
                                      _playEpisode(ep, c.title),
                                ),
                          _MoreLikeThis(
                            items: romancePicksContent,
                          ), // Still mocked for now
                          _TrailersTab(
                            trailerUrl: _detailData?.trailer,
                            thumbnail: _detailData?.thumbnail,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color color;
  const _IconAction({
    required this.icon,
    required this.label,
    this.onTap,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}

class _EpisodesTab extends StatelessWidget {
  final String title;
  final List<Episode> episodes;
  final Function(Episode) onEpisodeTap;

  const _EpisodesTab({
    required this.title,
    required this.episodes,
    required this.onEpisodeTap,
  });

  @override
  Widget build(BuildContext context) {
    if (episodes.isEmpty) {
      return const Center(
        child: Text(
          "No episodes found.",
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return Column(
      children: [
        // Season selector mock
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: KokoColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Text(
                    'Season 1',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: episodes.length,
            itemBuilder: (context, index) {
              // The API usually returns episodes randomly or descending, we sort or just display as is
              // For robustness, let's just use the returned list order
              final ep = episodes[index];
              final isSubbed = ep.sub > 0;
              return GestureDetector(
                onTap: () => onEpisodeTap(ep),
                child: _EpisodeItem(
                  title: '$title Ep. ${ep.number.toInt()}',
                  duration: isSubbed ? 'Subbed' : 'Raw',
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EpisodeItem extends StatelessWidget {
  final String title;
  final String duration;
  const _EpisodeItem({required this.title, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 60,
            decoration: BoxDecoration(
              color: KokoColors.surfaceVariant,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Icon(Icons.play_arrow, color: Colors.white54),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  duration,
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.download_outlined, color: Colors.white38, size: 20),
        ],
      ),
    );
  }
}

class _MoreLikeThis extends StatelessWidget {
  final List<KDramaContent> items;
  const _MoreLikeThis({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing:
            12, // slightly more spacing to match compact card design better
        mainAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: items.length,
      itemBuilder: (ctx, i) {
        return CompactPoster(content: items[i]);
      },
    );
  }
}

class _TrailersTab extends StatelessWidget {
  final String? trailerUrl;
  final String? thumbnail;
  const _TrailersTab({this.trailerUrl, this.thumbnail});

  @override
  Widget build(BuildContext context) {
    final hasTrailer = trailerUrl != null && trailerUrl!.isNotEmpty;

    return Column(
      children: [
        Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            color: KokoColors.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            image: thumbnail != null && thumbnail!.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(thumbnail!),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4),
                      BlendMode.darken,
                    ),
                  )
                : null,
          ),
          child: Center(
            child: IconButton(
              icon: Icon(
                hasTrailer ? Icons.play_circle_outline : Icons.block_flipped,
                color: Colors.white,
                size: 50,
              ),
              onPressed: () {
                if (hasTrailer) {
                  // For now, we reuse the VideoPlayerScreen if it's a direct link
                  // Most trailers in KissKH are direct links or YouTube
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(
                        title: "Trailer",
                        videoUrl: trailerUrl!,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          hasTrailer ? 'Official Trailer' : 'No Trailer Available',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        if (hasTrailer)
          const Text(
            'High Quality',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
      ],
    );
  }
}
