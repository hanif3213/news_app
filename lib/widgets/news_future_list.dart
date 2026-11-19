import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../views/detail_view.dart';
import 'article_card.dart';
import 'error_view.dart';

/// FutureBuilder dengan empat state: loading, error, kosong, data.
/// Future-nya dimiliki dan disimpan oleh State pemanggil (bukan dibuat di build).
class NewsFutureList extends StatelessWidget {
  final Future<List<ArticleModel>> future;
  final VoidCallback onRetry;
  final Future<void> Function() onRefresh;
  const NewsFutureList({
    super.key,
    required this.future,
    required this.onRetry,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArticleModel>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator()); // loading
        }
        if (snapshot.hasError) {
          return ErrorView(
              message: snapshot.error.toString(), onRetry: onRetry); // error
        }
        final articles = snapshot.data ?? [];
        if (articles.isEmpty) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(children: const [
              SizedBox(height: 200),
              Center(child: Text('Belum ada berita untuk topik ini.')), // kosong
            ]),
          );
        }
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: articles.length,
            itemBuilder: (context, i) => ArticleCard(
              article: articles[i],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => DetailView(article: articles[i])),
              ),
            ),
          ),
        ); // data
      },
    );
  }
}
