import 'package:flutter/material.dart';
import '../theme/koko_theme.dart';
import '../data/content_data.dart';
import '../screens/home_screen.dart' show openDetail;

class CompactPoster extends StatelessWidget {
  final KDramaContent content;
  final bool showNewBadge;

  const CompactPoster({
    super.key,
    required this.content,
    this.showNewBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openDetail(context, content),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                content.posterUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: KokoColors.surfaceVariant,
                  child: const Center(
                    child: Icon(Icons.movie, color: Colors.white30),
                  ),
                ),
              ),
              if (showNewBadge)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: KokoColors.primary,
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              // Subtle gradient at the bottom for text readability if we add text later, 
              // but keeping it very clean for now.
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.0, 0.6, 0.8, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 6,
                left: 6,
                right: 6,
                child: Text(
                  content.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
