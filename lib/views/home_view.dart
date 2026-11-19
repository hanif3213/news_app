import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../services/news_api_service.dart';
import '../widgets/news_future_list.dart';
import 'search_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final NewsApiService _service = NewsApiService();

  // Topik teknologi -> kata kunci GNews (/search mendukung AND, OR, NOT)
  static const Map<String, String> _topics = {
    'Terbaru': 'teknologi',
    'AI': 'kecerdasan buatan OR AI',
    'Gadget': 'smartphone OR gadget',
    'Startup': 'startup',
    'Keamanan Siber': 'keamanan siber',
    'Game': 'game OR esports',
  };

  String _selected = _topics.keys.first;

  /// Hemat kuota: satu Future per topik.
  final Map<String, Future<List<ArticleModel>>> _cache = {};
  late Future<List<ArticleModel>> _futureNews;

  @override
  void initState() {
    super.initState();
    _futureNews = _ambil(_selected);
  }

  Future<List<ArticleModel>> _ambil(String topic) =>
      _cache.putIfAbsent(topic, () => _fetch(topic));

  Future<List<ArticleModel>> _fetch(String topic) async {
    try {
      return await _service.searchNews(_topics[topic]!);
    } catch (_) {
      _cache.remove(topic); // hasil gagal tidak di-cache
      rethrow;
    }
  }

  void _muatUlang() {
    _cache.remove(_selected);
    setState(() {
      _futureNews = _ambil(_selected);
    });
  }

  void _gantiTopik(String topic) {
    if (topic == _selected) return;
    setState(() {
      _selected = topic;
      _futureNews = _ambil(topic);
    });
  }

  Future<void> _onRefresh() async {
    _muatUlang();
    try {
      await _futureNews;
    } catch (_) {/* error sudah ditampilkan FutureBuilder */}
  }

  Future<void> _dialogCari() async {
    final controller = TextEditingController();
    final keyword = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cari berita'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Kata kunci'),
          onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: const Text('Cari')),
        ],
      ),
    );
    if (keyword == null || keyword.isEmpty || !mounted) return;
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => SearchView(keyword: keyword)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Berita Teknologi'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: _dialogCari),
        ],
      ),
      body: Column(children: [
        SizedBox(
          height: 56,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              for (final t in _topics.keys)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: ChoiceChip(
                    label: Text(t),
                    selected: t == _selected,
                    onSelected: (_) => _gantiTopik(t),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: NewsFutureList(
            future: _futureNews,
            onRetry: _muatUlang,
            onRefresh: _onRefresh,
          ),
        ),
      ]),
    );
  }
}
