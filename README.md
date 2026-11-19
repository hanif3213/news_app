# Berita Teknologi Indonesia (Flutter + GNews + Dio)

News App bertema teknologi Indonesia memakai endpoint `/search` GNews.

## Fitur
- Daftar berita dengan `FutureBuilder` (loading, error, kosong, data)
- Chip topik: Terbaru, AI, Gadget, Startup, Keamanan Siber, Game
- Cari kata kunci (ikon di AppBar -> dialog -> halaman hasil)
- Cache `Map<String, Future<List<ArticleModel>>>` per topik (hemat kuota)
- Halaman detail, pull-to-refresh, tombol Coba Lagi
- `ApiException` dengan banyak pesan error berbeda

## Menjalankan
```bash
flutter create .            # sekali saja, membuat folder android/ios/web
flutter pub get
cp config/env.example.json config/env.json   # isi API key GNews Anda
flutter run --dart-define-from-file=config/env.json
```
`config/env.json` ada di `.gitignore`; jangan di-commit.

## Screenshot skenario error
| Tidak ada internet | API key salah (401) |
|---|---|
| ![](screenshots/error_internet.png) | ![](screenshots/error_apikey.png) |
