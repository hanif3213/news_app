import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(String iso) {
    final d = DateTime.tryParse(iso);
    if (d == null) return '-';
    return DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(d.toLocal());
  }
}
