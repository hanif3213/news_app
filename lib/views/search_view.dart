import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../services/news_api_service.dart';
import '../widgets/news_future_list.dart';

class SearchView extends StatefulWidget {
  final String keyword;
  const SearchView({super.key, required this.keyword});
  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final NewsApiService _service = NewsApiService();
  late Future<List<ArticleModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.searchNews(widget.keyword);
  }

  void _muatUlang() {
    setState(() {
      _future = _service.searchNews(widget.keyword);
    });
  }

  Future<void> _onRefresh() async {
    _muatUlang();
    try {
      await _future;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hasil: ${widget.keyword}')),
      body: NewsFutureList(
          future: _future, onRetry: _muatUlang, onRefresh: _onRefresh),
    );
  }
}
