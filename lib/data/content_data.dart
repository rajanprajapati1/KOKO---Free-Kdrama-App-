// KDrama mock data — replace with real API later
class KDramaContent {
  final String id;
  final String title;
  final String posterUrl;
  final String backdropUrl;
  final String year;
  final String rating;
  final String seasons;
  final String description;
  final List<String> genres;
  final bool isNew;
  final int? topTenRank;

  const KDramaContent({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.backdropUrl,
    required this.year,
    required this.rating,
    required this.seasons,
    required this.description,
    required this.genres,
    this.isNew = false,
    this.topTenRank,
  });
}

class Episode {
  final int id;
  final double number;
  final int sub;

  Episode({required this.id, required this.number, required this.sub});

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      number: (json['number'] as num).toDouble(),
      sub: json['sub'] ?? 0,
    );
  }
}

class DramaDetail {
  final String description;
  final String releaseDate;
  final String status;
  final String type;
  final String country;
  final List<Episode> episodes;
  final String trailer;
  final String thumbnail;
  final int id;
  final String title;

  DramaDetail({
    required this.description,
    required this.releaseDate,
    required this.status,
    required this.type,
    required this.country,
    required this.episodes,
    required this.trailer,
    required this.thumbnail,
    required this.id,
    required this.title,
  });

  factory DramaDetail.fromJson(Map<String, dynamic> json) {
    return DramaDetail(
      description: json['description'] ?? '',
      releaseDate: json['releaseDate'] ?? '',
      trailer: json['trailer'] ?? '',
      country: json['country'] ?? '',
      status: json['status'] ?? '',
      episodes: (json['episodes'] as List?)
              ?.map((e) => Episode.fromJson(e))
              .toList() ??
          [],
      thumbnail: json['thumbnail'] ?? '',
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown',
      type: json['type'] ?? '',
    );
  }
}

class VideoData {
  final String url;
  final String label;

  VideoData({required this.url, required this.label});

  factory VideoData.fromJson(Map<String, dynamic> json) {
    return VideoData(
      url: json['src'] ?? json['video'] ?? '',
      label: json['label'] ?? 'Standard',
    );
  }
}

class SubtitleData {
  final String url;
  final String label;
  final String lang;
  final bool isDefault;

  SubtitleData({
    required this.url,
    required this.label,
    required this.lang,
    this.isDefault = false,
  });

  factory SubtitleData.fromJson(Map<String, dynamic> json) {
    return SubtitleData(
      url: json['src'] ?? '',
      label: json['label'] ?? 'Unknown',
      lang: json['lang'] ?? json['land'] ?? 'en',
      isDefault: json['default'] ?? false,
    );
  }
}

const heroContent = KDramaContent(
  id: '1',
  title: 'Crash Landing on You',
  posterUrl: 'https://image.tmdb.org/t/p/w500/vqzNJRH4YyquRiWxDTOz0CbPT1c.jpg',
  backdropUrl: 'https://image.tmdb.org/t/p/original/vqzNJRH4YyquRiWxDTOz0CbPT1c.jpg',
  year: '2019',
  rating: '16+',
  seasons: '2 Seasons',
  description: 'A paragliding mishap drops a South Korean heiress in North Korea — and into the life of an army officer, who decides to help her hide.',
  genres: ['Romantic', 'Drama', 'Heartfelt'],
);

const List<KDramaContent> trendingNow = [
  KDramaContent(
    id: '2',
    title: 'Vincenzo',
    posterUrl: 'https://image.tmdb.org/t/p/w500/A1TWxEGqS3V1kI8T8X04bI2W9Sg.jpg',
    backdropUrl: 'https://image.tmdb.org/t/p/original/A1TWxEGqS3V1kI8T8X04bI2W9Sg.jpg',
    year: '2021', rating: '16+', seasons: '1 Season',
    description: 'An Italian mafia consigliere returns to South Korea, where he reunites with a spirited lawyer to take on a powerful conglomerate.',
    genres: ['Action', 'Crime', 'Comedy'],
    topTenRank: 1,
  ),
  KDramaContent(
    id: '3',
    title: 'Squid Game',
    posterUrl: 'https://image.tmdb.org/t/p/w500/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg',
    backdropUrl: 'https://image.tmdb.org/t/p/original/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg',
    year: '2021', rating: 'MA-17', seasons: '2 Seasons',
    description: 'Hundreds of cash-strapped players accept a strange invitation to compete in children\'s games. Inside: a tempting prize awaits.',
    genres: ['Thriller', 'Drama', 'Survival'],
    topTenRank: 2,
    isNew: true,
  ),
  KDramaContent(
    id: '4',
    title: 'My Mister',
    posterUrl: 'https://image.tmdb.org/t/p/w500/cml6ibm0nCxAFrqx2H0w8LqJMjT.jpg',
    backdropUrl: 'https://image.tmdb.org/t/p/original/cml6ibm0nCxAFrqx2H0w8LqJMjT.jpg',
    year: '2018', rating: '15+', seasons: '1 Season',
    description: 'Three middle-aged brothers struggle each in their own way, and a young woman toughened up by life watches and silently roots for them.',
    genres: ['Drama', 'Slice of Life'],
    topTenRank: 3,
  ),
  KDramaContent(
    id: '5',
    title: 'Itaewon Class',
    posterUrl: 'https://image.tmdb.org/t/p/w500/pHv4xovXAZpM1Zz0x5Ry6FnKETf.jpg',
    backdropUrl: 'https://image.tmdb.org/t/p/original/pHv4xovXAZpM1Zz0x5Ry6FnKETf.jpg',
    year: '2020', rating: '15+', seasons: '1 Season',
    description: 'A man who was wrongfully imprisoned fights back using his small bar as the starting point for a new business empire.',
    genres: ['Drama', 'Romance', 'Revenge'],
    topTenRank: 4,
  ),
];

const List<KDramaContent> romancePicksContent = [
  KDramaContent(
    id: '6',
    title: 'Business Proposal',
    posterUrl: 'https://image.tmdb.org/t/p/w500/bDVEEdqjGmHPLKKJJ8JW3qlIxp0.jpg',
    backdropUrl: 'https://image.tmdb.org/t/p/original/bDVEEdqjGmHPLKKJJ8JW3qlIxp0.jpg',
    year: '2022', rating: '12+', seasons: '1 Season',
    description: 'A woman on a blind date discovers her date is her cold boss — and realizes their fake relationship has become all too real.',
    genres: ['Rom-Com', 'Office Romance'],
    isNew: true,
  ),
  KDramaContent(
    id: '7',
    title: 'Goblin',
    posterUrl: 'https://image.tmdb.org/t/p/w500/b1xrw0sG8oA50A19hA74Z1d2d0z.jpg',
    backdropUrl: 'https://image.tmdb.org/t/p/original/b1xrw0sG8oA50A19hA74Z1d2d0z.jpg',
    year: '2016', rating: '12+', seasons: '1 Season',
    description: 'A 939-year-old goblin seeks to end his immortal life by finding his human bride, who can remove the sword from his chest.',
    genres: ['Fantasy', 'Romance'],
  ),
  KDramaContent(
    id: '8',
    title: 'My Love from the Star',
    posterUrl: 'https://image.tmdb.org/t/p/w500/3AYo4rIGEn84VyxBV8aKoZ7kqVN.jpg',
    backdropUrl: 'https://image.tmdb.org/t/p/original/3AYo4rIGEn84VyxBV8aKoZ7kqVN.jpg',
    year: '2013', rating: '12+', seasons: '1 Season',
    description: 'An alien who landed in Joseon Dynasty falls in love with an actress 400 years later, just before his scheduled departure.',
    genres: ['Fantasy', 'Romance', 'Sci-Fi'],
  ),
  KDramaContent(
    id: '9',
    title: 'Strong Woman Bong-soon',
    posterUrl: 'https://image.tmdb.org/t/p/w500/dqSQucQtnlb5hcxAh7Jl7WXHVBV.jpg',
    backdropUrl: 'https://image.tmdb.org/t/p/original/dqSQucQtnlb5hcxAh7Jl7WXHVBV.jpg',
    year: '2017', rating: '15+', seasons: '1 Season',
    description: 'A woman gifted with superhuman strength hides her ability and works for a gaming company CEO, protecting him from danger.',
    genres: ['Rom-Com', 'Action'],
  ),
];

const List<KDramaContent> newlyAddedContent = [
  KDramaContent(
    id: '10',
    title: 'Moving',
    posterUrl: 'https://image.tmdb.org/t/p/w500/4BNbp1KcHfnH0U0PuqnhHWlpLqH.jpg',
    backdropUrl: 'https://image.tmdb.org/t/p/original/4BNbp1KcHfnH0U0PuqnhHWlpLqH.jpg',
    year: '2023', rating: '15+', seasons: '1 Season',
    description: 'Three families with secrets meet as their children with superpowers start high school and face threats from corrupt government agents.',
    genres: ['Action', 'Superhero', 'Family'],
    isNew: true,
  ),
  KDramaContent(
    id: '11',
    title: 'All of Us Are Dead',
    posterUrl: 'https://image.tmdb.org/t/p/w500/cml6ibm0nCxAFrqx2H0w8LqJMjT.jpg',
    backdropUrl: 'https://image.tmdb.org/t/p/original/cml6ibm0nCxAFrqx2H0w8LqJMjT.jpg',
    year: '2022', rating: 'MA-17', seasons: '1 Season',
    description: 'A zombie virus breaks out in a high school, and students fight to survive and escape while trapped inside the school.',
    genres: ['Horror', 'Thriller', 'Action'],
    isNew: true,
  ),
  heroContent,
];
