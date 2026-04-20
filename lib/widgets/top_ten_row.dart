import 'package:flutter/material.dart';
import '../theme/koko_theme.dart';
import '../data/content_data.dart';
import '../screens/home_screen.dart' show openDetail;
import 'compact_poster.dart';

class TopTenRow extends StatelessWidget {
  final List<KDramaContent> items;
  
  const TopTenRow({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, 
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        clipBehavior: Clip.none,
        itemBuilder: (ctx, i) {
          final content = items[i];
          final rankIndex = content.topTenRank?.toString() ?? '${i + 1}';
          
          return Container(
            width: 145, // Compact width
            margin: const EdgeInsets.only(right: 16),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                 // The Poster
                Positioned(
                  right: 0,
                  bottom: 12, 
                  top: 12,
                  width: 115,
                  child: CompactPoster(content: content),
                ),
                // The Number Outline
                Positioned(
                  left: -8,
                  bottom: -16, 
                  child: Text(
                    rankIndex,
                    style: TextStyle(
                      fontSize: 120, // Slightly more refined size
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Manrope', // Use the app's clean font
                      letterSpacing: -5,
                      height: 1.0,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4
                        ..color = Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
                // The Number Fill
                Positioned(
                  left: -8,
                  bottom: -16,
                  child: Text(
                    rankIndex,
                    style: TextStyle(
                      fontSize: 120,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Manrope',
                      letterSpacing: -5,
                      height: 1.0,
                      color: KokoColors.background, // Match background to simulate subtraction
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

