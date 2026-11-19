import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../utils/date_formatter.dart';
import 'news_image.dart';

class ArticleCard extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback onTap;
  const ArticleCard({super.key, required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final meta = Theme.of(context).textTheme.bodySmall;
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (article.urlToImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: NewsImage(url: article.urlToImage!, height: 220),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(article.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold)),
              if (article.description != null) ...[
                const SizedBox(height: 8),
                Text(article.description!,
                    maxLines: 3, overflow: TextOverflow.ellipsis),
              ],
              const SizedBox(height: 12),
              Row(children: [
                if (article.author != null) ...[
                  const Icon(Icons.newspaper, size: 16),
                  const SizedBox(width: 4),
                  Flexible(
                      child: Text(article.author!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: meta)),
                  const SizedBox(width: 12),
                ],
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 4),
                Text(DateFormatter.formatDate(article.publishedAt), style: meta),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}
