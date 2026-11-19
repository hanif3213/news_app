class ArticleModel {
  final String title;
  final String? description;
  final String? content;
  final String? url;
  final String? urlToImage;
  final String? author; // nama media
  final String publishedAt;

  ArticleModel({
    required this.title,
    this.description,
    this.content,
    this.url,
    this.urlToImage,
    this.author,
    required this.publishedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final source = json['source'];
    return ArticleModel(
      author: source is Map ? source['name'] as String? : null,
      title: json['title'] as String? ?? 'Tanpa Judul',
      description: json['description'] as String?,
      url: json['url'] as String?,
      urlToImage: json['image'] as String?,
      publishedAt: json['publishedAt'] as String? ?? '',
      content: _rapikan(json['content'] as String?),
    );
  }

  static String? _rapikan(String? c) {
    if (c == null) return null;
    final bersih = c
        .replaceAll(RegExp(r'\s*\[\d+ chars\]$'), '')
        .replaceAll(RegExp(r'[.…]+$'), '')
        .trimRight();
    return '$bersih...';
  }
}
