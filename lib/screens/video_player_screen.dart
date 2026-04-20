import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../data/content_data.dart';
import '../theme/koko_theme.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String title;
  final String videoUrl;
  final List<SubtitleData> subtitles;
  final String? dramaId;
  final Episode? episode;

  const VideoPlayerScreen({
    super.key,
    required this.title,
    required this.videoUrl,
    this.subtitles = const [],
    this.dramaId,
    this.episode,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final Player player = Player();
  late final VideoController controller = VideoController(player);

  bool _showControls = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();

    // Force landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    String actualVideoUrl = widget.videoUrl;
    if (actualVideoUrl.isEmpty && widget.dramaId != null && widget.episode != null) {
      final epNum = widget.episode!.number.toInt();
      final sub = widget.episode!.sub;
      if (sub > 0) {
        actualVideoUrl = 'https://hls.cdnvideo11.shop/hls07/${widget.dramaId}/Ep$epNum.v${sub}_index.m3u8';
      } else {
        actualVideoUrl = 'https://hls.cdnvideo11.shop/hls07/${widget.dramaId}/Ep${epNum}_index.m3u8';
      }
    }

    // Initialize player with headers to bypass CDN protection
    player.open(
      Media(
        actualVideoUrl,
        httpHeaders: {
          'Origin': 'https://kisskh.nl',
          'Referer': 'https://kisskh.nl/',
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',
        },
      ),
    );

    // Load default subtitle if available
    _loadDefaultSubtitle();

    // Auto-hide controls
    _startHideTimer();
  }

  void _loadDefaultSubtitle() {
    if (widget.subtitles.isEmpty) return;
    
    // Find default or first subtitle
    final defaultSub = widget.subtitles.firstWhere(
      (s) => s.isDefault,
      orElse: () => widget.subtitles.first,
    );
    
    _applySubtitle(defaultSub.url, defaultSub.label);
  }

  void _applySubtitle(String? url, [String? title]) {
    if (url == null) {
      player.setSubtitleTrack(SubtitleTrack.no());
    } else {
      player.setSubtitleTrack(SubtitleTrack.uri(url, title: title));
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) _startHideTimer();
  }

  @override
  void dispose() {
    // Restore orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    
    _hideTimer?.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Video(controller: controller),
            
            // ── Controls Overlay ──
            if (_showControls)
              Positioned.fill(
                child: Container(
                  color: Colors.black26,
                  child: Column(
                    children: [
                      // Top bar
                      _buildTopBar(),
                      const Spacer(),
                      // Center Play/Pause
                      _buildCenterControls(),
                      const Spacer(),
                      // Bottom bar
                      _buildBottomBar(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black87, Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.subtitles_outlined, color: Colors.white),
            onPressed: _showSubtitleMenu,
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCenterControls() {
    return StreamBuilder<bool>(
      stream: player.stream.playing,
      builder: (context, snapshot) {
        final isPlaying = snapshot.data ?? false;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 48,
              icon: const Icon(Icons.replay_10, color: Colors.white),
              onPressed: () => player.seek(player.state.position - const Duration(seconds: 10)),
            ),
            const SizedBox(width: 48),
            IconButton(
              iconSize: 72,
              icon: Icon(
                isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                color: Colors.white,
              ),
              onPressed: isPlaying ? player.pause : player.play,
            ),
            const SizedBox(width: 48),
            IconButton(
              iconSize: 48,
              icon: const Icon(Icons.forward_10, color: Colors.white),
              onPressed: () => player.seek(player.state.position + const Duration(seconds: 10)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black87, Colors.transparent],
        ),
      ),
      child: Column(
        children: [
          // Seek bar
          _buildSeekBar(),
          Row(
            children: [
              StreamBuilder<Duration>(
                stream: player.stream.position,
                builder: (context, snapshot) {
                  final pos = snapshot.data ?? Duration.zero;
                  return Text(
                    _formatDuration(pos),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  );
                },
              ),
              const Spacer(),
              StreamBuilder<Duration>(
                stream: player.stream.duration,
                builder: (context, snapshot) {
                  final dur = snapshot.data ?? Duration.zero;
                  return Text(
                    _formatDuration(dur),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeekBar() {
    return StreamBuilder<Duration>(
      stream: player.stream.position,
      builder: (context, snapshotPos) {
        return StreamBuilder<Duration>(
          stream: player.stream.duration,
          builder: (context, snapshotDur) {
            final pos = snapshotPos.data ?? Duration.zero;
            final dur = snapshotDur.data ?? Duration.zero;
            final max = dur.inMilliseconds.toDouble();
            final current = pos.inMilliseconds.toDouble().clamp(0.0, max);
            
            return SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
                activeTrackColor: KokoColors.primary,
                inactiveTrackColor: Colors.white30,
                thumbColor: KokoColors.primary,
              ),
              child: Slider(
                value: current,
                max: max > 0 ? max : 1.0,
                onChanged: (v) {
                  player.seek(Duration(milliseconds: v.toInt()));
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showSubtitleMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: KokoColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subtitles',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.subtitles_off, color: Colors.white70),
                      title: const Text('None', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        _applySubtitle(null);
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(color: Colors.white10),
                    ...widget.subtitles.map((sub) => ListTile(
                          leading: const Icon(Icons.language, color: Colors.white70),
                          title: Text(sub.label, style: const TextStyle(color: Colors.white)),
                          onTap: () {
                            _applySubtitle(sub.url, sub.label);
                            Navigator.pop(context);
                          },
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    if (d.inHours > 0) {
      return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
