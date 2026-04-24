import 'dart:convert';
import 'package:http/http.dart' as http;
import 'content_data.dart';

/// Simple in-memory cache entry
class _CacheEntry {
  final dynamic data;
  final DateTime expiresAt;
  _CacheEntry(this.data, this.expiresAt);
  bool get isValid => DateTime.now().isBefore(expiresAt);
}

class ApiService {
  static const Map<String, String> headers = {
    "Accept": "application/json, text/plain, */*",
    "Accept-Language": "en-US,en;q=0.8",
    "Connection": "keep-alive",
    "Cookie": "g_state={\"i_l\":0,\"i_ll\":1776495839374,\"i_b\":\"1LGHZrUonLEZApjuweodx1sTPQqUgy2pDjF1DUV1rnY\",\"i_e\":{\"enable_itp_optimization\":1},\"i_et\":1776494687546}",
    "Origin": "https://kisskh.nl",
    "Referer": "https://kisskh.nl/",
    "Sec-Fetch-Dest": "empty",
    "Sec-Fetch-Mode": "cors",
    "Sec-Fetch-Site": "cross-site",
    "Sec-GPC": "1",
    "User-Agent": "Mozilla/5.0 (Linux; Android 8.1.0; Vivo 1807) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36",
    "sec-ch-ua": "\"Not:A-Brand\";v=\"99\", \"Chromium\";v=\"120\"",
    "sec-ch-ua-mobile": "?1",
    "sec-ch-ua-platform": "\"Android\""
  };

  // Static kkey from user snippet — if this expires, it will need to be refreshed
  static const String currentKKey =
      "A5DED09895A15AAE237CDCFD8E51DCBA4DFC2F969404D8EE5BF299076E969ED6F972A3B12EBFE741AB510352F7A29ABF87A5DE6E1AA7761992B0378895204355D0BC854706CC1A30AC7D7766296BAFFB50C175348DB88AFED66EFEF89333E81130614D97BAF04DAD9C87E03ABBA3D6864E5928144403FB4C56BCDE99E27306A7";

  // ─── Cache storage ───────────────────────────────────────────
  static final Map<String, _CacheEntry> _cache = {};
  static const Duration _cacheDuration = Duration(minutes: 5);

  /// Clears the entire in-memory cache (e.g., for pull-to-refresh)
  static void clearCache() => _cache.clear();

  // ─── Core fetch with caching ─────────────────────────────────
  static Future<List<KDramaContent>> fetchDramaList(
    String endpoint, {
    int? topTenStartRank,
    bool isNew = false,
  }) async {
    // Return cached response if still valid
    final cached = _cache[endpoint];
    if (cached != null && cached.isValid) {
      final rawList = cached.data as List<dynamic>;
      return _mapToContent(rawList, topTenStartRank: topTenStartRank, isNew: isNew);
    }

    try {
      final response = await http.get(Uri.parse(endpoint), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Store raw decoded JSON in cache
        _cache[endpoint] = _CacheEntry(
          data,
          DateTime.now().add(_cacheDuration),
        );
        return _mapToContent(data, topTenStartRank: topTenStartRank, isNew: isNew);
      }
    } catch (e) {
      print('Error fetching $endpoint: $e');
    }
    return [];
  }

  static List<KDramaContent> _mapToContent(
    List<dynamic> data, {
    int? topTenStartRank,
    bool isNew = false,
  }) {
    List<KDramaContent> contents = [];
    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      contents.add(KDramaContent(
        id: item['id'].toString(),
        title: item['title'] ?? 'Unknown',
        posterUrl: item['thumbnail'] ?? '',
        backdropUrl: item['thumbnail'] ?? '',
        year: '',
        rating: '16+',
        seasons: '${item['episodesCount'] ?? 1} Episodes',
        description: '',
        genres: [],
        isNew: isNew,
        topTenRank: topTenStartRank != null ? topTenStartRank + i : null,
      ));
    }
    return contents;
  }

  // ─── Endpoint wrappers ────────────────────────────────────────
  static Future<List<KDramaContent>> getLastUpdate() {
    return fetchDramaList(
      'https://kisskh.nl/api/DramaList/LastUpdate?ispc=true',
      isNew: true,
    );
  }

  static Future<List<KDramaContent>> getMostViewedC2() {
    return fetchDramaList(
      'https://kisskh.nl/api/DramaList/MostView?ispc=true&c=2',
      topTenStartRank: 1,
    );
  }

  static Future<List<KDramaContent>> getMostViewedC1() {
    return fetchDramaList(
      'https://kisskh.nl/api/DramaList/MostView?ispc=true&c=1',
    );
  }

  static Future<List<KDramaContent>> getTopRating() {
    return fetchDramaList('https://kisskh.nl/api/DramaList/TopRating?ispc=true');
  }

  static Future<List<KDramaContent>> getAnimate() {
    return fetchDramaList('https://kisskh.nl/api/DramaList/Animate?ispc=true');
  }

  static Future<List<KDramaContent>> getMostSearch() {
    return fetchDramaList('https://kisskh.nl/api/DramaList/MostSearch?ispc=false');
  }

  // ─── Search (not cached — always fresh) ──────────────────────
  static Future<List<KDramaContent>> searchContent(String query) {
    if (query.trim().isEmpty) return Future.value([]);
    final encodedQuery = Uri.encodeComponent(query.trim());
    return fetchDramaList(
      'https://kisskh.nl/api/DramaList/Search?q=$encodedQuery&type=0',
    );
  }

  // ─── Detail & Video (not cached — detail pages need fresh data) ─
  static Future<DramaDetail?> getDramaDetails(String id) async {
    try {
      final response = await http.get(
        Uri.parse('https://kisskh.nl/api/DramaList/Drama/$id?isq=false'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return DramaDetail.fromJson(json.decode(response.body));
      }
    } catch (e) {
      print('Error fetching detail: $e');
    }
    return null;
  }

  static Future<List<VideoData>> getEpisodeVideo(int episodeId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://kisskh.nl/api/DramaList/Episode/$episodeId.png?isq=false'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((v) => VideoData.fromJson(v)).toList();
      }
    } catch (e) {
      print('Error fetching video: $e');
    }
    return [];
  }

  static Future<List<SubtitleData>> getEpisodeSubtitles(int episodeId) async {
    try {
      final response = await http.get(
        Uri.parse('https://kisskh.nl/api/Sub/$episodeId?kkey=$currentKKey'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((s) => SubtitleData.fromJson(s)).toList();
      }
    } catch (e) {
      print('Error fetching subtitles: $e');
    }
    return [];
  }
}
