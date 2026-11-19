import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NewsImage extends StatelessWidget {
  final String url;
  final double height;
  const NewsImage({super.key, required this.url, this.height = 180});

  @override
  Widget build(BuildContext context) {
    final placeholder = SizedBox(
      height: height,
      child: const Center(child: CircularProgressIndicator()),
    );
    final error = SizedBox(
      height: height,
      child: const Center(child: Icon(Icons.image_not_supported, size: 48)),
    );

    if (kIsWeb) {
      return Image.network(
        url,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        // Bila ditolak CORS, Flutter memakai elemen <img> HTML
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
        loadingBuilder: (context, child, progress) =>
        progress == null ? child : placeholder,
        errorBuilder: (context, e, st) => error,
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => placeholder,
      errorWidget: (context, url, e) => error,
    );
  }
}