import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/koko_theme.dart';

/// A smart network image widget with:
///   • CachedNetworkImage for fast disk + memory caching
///   • Shimmer-style placeholder while loading
///   • "image copy.png" as fallback when URL is null / fails
///   • Optional border radius clipping
class KokoImage extends StatelessWidget {
  final String? url;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;

  const KokoImage({
    super.key,
    this.url,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.width,
    this.height,
  });

  // ── Fallback ─────────────────────────────────────────────────────────────
  static Widget fallback({BoxFit fit = BoxFit.cover}) {
    return Image.asset(
      'image copy.png',
      fit: fit,
    );
  }

  // ── Shimmer-style placeholder ─────────────────────────────────────────────
  static Widget _shimmer() {
    return _ShimmerBox();
  }

  @override
  Widget build(BuildContext context) {
    Widget img;

    if (url == null || url!.isEmpty) {
      img = fallback(fit: fit);
    } else {
      img = CachedNetworkImage(
        imageUrl: url!,
        fit: fit,
        width: width,
        height: height,
        placeholder: (_, __) => _shimmer(),
        errorWidget: (_, __, ___) => fallback(fit: fit),
        fadeInDuration: const Duration(milliseconds: 250),
        fadeOutDuration: const Duration(milliseconds: 100),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: img);
    }
    return img;
  }
}

// ── Simple shimmer box ────────────────────────────────────────────────────────
class _ShimmerBox extends StatefulWidget {
  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 0.9).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        color: KokoColors.surfaceVariant.withOpacity(_anim.value),
      ),
    );
  }
}
