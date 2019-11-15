import 'package:meta/meta.dart';

class Cip7 {
  final String data;

  Cip7({@required this.data}) {
    if (data?.length != 7) {
      throw ArgumentError.value(data, 'cip7', 'length should be equal to 7');
    }
  }

  String toString() => data;
}

enum PharmaceuticalType {
  speciality,
  product,
}

const _pharmaceuticalTypeMap = {
  '00': PharmaceuticalType.speciality,
};

enum PharmaceuticalClassification {
  allopathy,
}

const _pharmaceuticalClassificationMap = {
  '9': PharmaceuticalClassification.allopathy,
};

int _sumFor(String cip13, {bool even = true}) {
  int result = 0;
  for (int i = even ? 0 : 1; i < cip13.length; i += 2) {
    result += int.tryParse(cip13[i]);
  }
  return result;
}

int _calculateCip13Crc(String data) {
  final odd = _sumFor(data, even: false) * 3;
  final even = _sumFor(data);
  final result = odd + even;
  return 9 - ((result - 1) % 10);
}

class PharmaceuticalCip13 {
  final String prefix;
  final PharmaceuticalType type;
  final PharmaceuticalClassification classification;
  final Cip7 cip7;
  final String crc;

  PharmaceuticalCip13._({
    @required this.prefix,
    @required this.type,
    @required this.classification,
    @required this.cip7,
    @required this.crc,
  }) {
    if (prefix?.length != 2) {
      throw ArgumentError.value(
          prefix, 'prefix', 'length should be equal to 2');
    } else if (prefix != '34') {
      throw ArgumentError.value(prefix, 'prefix', 'should be equal to 34');
    } else if (type == null) {
      throw ArgumentError.notNull('type');
    } else if (classification == null) {
      throw ArgumentError.notNull('classification');
    }
  }

  factory PharmaceuticalCip13.fromString(String cip13) {
    if (cip13.length != 13) {
      throw ArgumentError.value(cip13, 'cip13', 'length should be equal to 13');
    } else if (cip13.substring(2, 4) != '00' && cip13.substring(2, 4) != '01') {
      throw ArgumentError.value(
          cip13.substring(2, 4), 'type', 'valid value are 00, 01');
    } else if (!RegExp(r'\d').hasMatch(cip13.substring(4, 5))) {
      throw ArgumentError.value(
          cip13.substring(4, 5), 'classification', 'should be a number');
    }
    final data = cip13.substring(0, cip13.length - 1);
    final crc = _calculateCip13Crc(data);
    if ('$crc' != cip13.substring(cip13.length - 1)) {
      throw ArgumentError.value(crc, 'crc', 'is not correct');
    }
    return PharmaceuticalCip13._(
      prefix: cip13.substring(0, 2),
      type: _pharmaceuticalTypeMap[cip13.substring(2, 4)],
      classification: _pharmaceuticalClassificationMap[cip13.substring(4, 5)],
      cip7: Cip7(data: cip13.substring(5, cip13.length - 1)),
      crc: cip13.substring(cip13.length - 1),
    );
  }

  String toString() {
    final sb = StringBuffer(prefix);
    final _type = _pharmaceuticalTypeMap.entries
        .firstWhere((entry) => entry.value == type, orElse: () => null)
        ?.key;
    sb.write(_type);
    final _classification = _pharmaceuticalClassificationMap.entries
        .firstWhere((entry) => entry.value == classification,
            orElse: () => null)
        ?.key;
    sb.write(_classification);
    sb.write('$cip7$crc');
    return sb.toString();
  }
}

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
