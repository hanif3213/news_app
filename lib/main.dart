import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'views/home_view.dart';
import 'config/env.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  debugPrint('KEY len=${Env.apiKey.length} valid=${RegExp(r'^[0-9a-f]{32}$').hasMatch(Env.apiKey)} base="${Env.baseUrl}"');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Berita Teknologi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HomeView(),
    );
  }
}
