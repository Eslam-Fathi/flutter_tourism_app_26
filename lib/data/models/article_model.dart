class HistoricArticle {
  final String id;
  final String title;
  final String excerpt;
  final String imageUrl;
  final String author;
  final DateTime publishedAt;

  HistoricArticle({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.imageUrl,
    required this.author,
    required this.publishedAt,
  });
}
