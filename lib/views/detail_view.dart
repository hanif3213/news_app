import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article_model.dart';
import '../utils/date_formatter.dart';
import '../widgets/news_image.dart';

class DetailView extends StatelessWidget {
  final ArticleModel article;
  const DetailView({super.key, required this.article});

  Future<void> _bukaLink(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    final berhasil =
        uri != null && await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!berhasil && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak bisa membuka link berita.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final meta = Theme.of(context).textTheme.bodySmall;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Berita')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (article.urlToImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: NewsImage(url: article.urlToImage!, height: 220),
            ),
          const SizedBox(height: 16),
          Text(article.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
              '${article.author ?? '-'} • ${DateFormatter.formatDate(article.publishedAt)}',
              style: meta),
          const SizedBox(height: 16),
          Text(article.content ?? article.description ?? 'Tidak ada isi berita.',
              style: const TextStyle(fontSize: 16, height: 1.5)),
          if (article.url != null) ...[
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _bukaLink(context, article.url!),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Baca selengkapnya'),
            ),
          ],
        ]),
      ),
    );
  }
}