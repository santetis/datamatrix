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
    final sb = StringBuffer('010');

    return sb.toString();
  }
}

DateTime _parseDate(String date) {
  final day = int.tryParse(date.substring(0, 2));
  final month = int.tryParse(date.substring(2, 4));
  final year = int.tryParse(date.substring(4));
  return DateTime(year, month, day);
}
