import 'package:meta/meta.dart';
import 'package:pharmaceutical_datamatrix/src/cip13.dart';

class PharmaceuticalDatamatrix {
  final PharmaceuticalCip13 cip13;
  final DateTime manufactured;
  final DateTime expiration;
  final String lot;

  PharmaceuticalDatamatrix({
    @required this.cip13,
    @required this.manufactured,
    @required this.expiration,
    @required this.lot,
  });

  factory PharmaceuticalDatamatrix.fromDatamatrix(
      {@required String datamatrix}) {
    if (datamatrix == null) {
      throw ArgumentError.notNull('datamatrix');
    }
    final regExp =
        RegExp(r'^010(((\d{5})\d{7})\d)17(\d{6})(\d{6})?10([a-zA-Z0-9]+)$');
    if (!regExp.hasMatch(datamatrix)) {
      throw ArgumentError.value(datamatrix, 'datamatrix', 'is not valid');
    }

    final match = regExp.firstMatch(datamatrix);
    final cip13 = match.group(1);
    final created = match.group(4);
    final expiration = match.group(5);
    final lot = match.group(6);

    return PharmaceuticalDatamatrix(
      cip13: PharmaceuticalCip13.fromString(cip13),
      manufactured: _parseDate(created),
      expiration: _parseDate(expiration),
      lot: lot,
    );
  }

  String toString() {
    final sb = StringBuffer('010')
      ..write('$cip13')
      ..write('17')
      ..write('${_formatDate(manufactured)}');
    if (expiration != null) {
      sb.write('${_formatDate(expiration)}');
    }
    sb..write('10')..write('$lot');
    return sb.toString();
  }
}

String _formatDate(DateTime date) {
  final sb = StringBuffer()
    ..write('${date.day.toString().padLeft(2, '0')}')
    ..write('${date.month.toString().padLeft(2, '0')}')
    ..write('${(date.year - 2000).toString().padLeft(2, '0')}');
  return sb.toString();
}

DateTime _parseDate(String date) {
  if (date == null) {
    return null;
  }
  final day = int.tryParse(date.substring(0, 2));
  final month = int.tryParse(date.substring(2, 4));
  final year = int.tryParse(date.substring(4)) + 2000;
  return DateTime(year, month, day);
}
