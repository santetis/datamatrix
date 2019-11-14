import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class Cip7 {
  final String cip7;

  const Cip7({@required this.cip7});

  String toString() => cip7;
}

class Cip13 {
  final String prefix;
  final Cip7 cip7;

  const Cip13({@required this.prefix, @required this.cip7});

  factory Cip13.fromCip13(String cip13) {
    return Cip13(
      prefix: cip13.substring(0, 6),
      cip7: Cip7(cip7: cip13.substring(6)),
    );
  }

  String toString() => '$prefix$cip7';
}

class PharmaceuticalDatamatrix {
  final Cip13 cip13;
  final DateTime created;
  final DateTime expiration;
  final String lot;

  const PharmaceuticalDatamatrix({
    @required this.cip13,
    @required this.created,
    @required this.expiration,
    @required this.lot,
  });

  factory PharmaceuticalDatamatrix.fromDatamatrix(
      {@required String datamatrix}) {
    if (datamatrix == null) {
      throw ArgumentError.notNull('datamatrix');
    }
    final regExp =
        RegExp(r'^010((\d{6})\d{7})17(\d{6})(\d{6})?10([a-zA-Z0-9]+)$');
    if (!regExp.hasMatch(datamatrix)) {
      throw ArgumentError.value(datamatrix, 'datamatrix', 'is not valid');
    }

    final match = regExp.firstMatch(datamatrix);
    final cip13 = match.group(1);
    final created = match.group(3);
    final expiration = match.group(4);
    final lot = match.group(5);

    return PharmaceuticalDatamatrix(
      cip13: Cip13.fromCip13(cip13),
      created: _parseDate(created),
      expiration: _parseDate(expiration),
      lot: lot,
    );
  }
}

DateTime _parseDate(String date) {
  final day = int.tryParse(date.substring(0, 2));
  final month = int.tryParse(date.substring(2, 4));
  final year = int.tryParse(date.substring(4));
  return DateTime(year, month, day);
}
