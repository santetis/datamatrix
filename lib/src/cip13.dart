import 'package:meta/meta.dart';
import 'package:pharmaceutical_datamatrix/pharmaceutical_datamatrix.dart';
import 'package:pharmaceutical_datamatrix/src/cip7.dart';

enum PharmaceuticalType {
  speciality,
  product,
}

const _pharmaceuticalTypeMap = {
  '00': PharmaceuticalType.speciality,
  '01': PharmaceuticalType.product,
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
    if (prefix != '34') {
      throw ArgumentError.value(prefix, 'prefix', 'should be equal to 34');
    } else if (classification == null) {
      throw ArgumentError.notNull('classification');
    }
  }

  factory PharmaceuticalCip13.fromString(String cip13) {
    if (cip13.length != 13) {
      throw ArgumentError.value(cip13, 'cip13', 'length should be equal to 13');
    }
    final type = cip13.substring(2, 4);
    if (!_pharmaceuticalTypeMap.keys.contains(type)) {
      throw ArgumentError.value(type, 'type', 'valid value are 00, 01');
    }
    final classification = cip13.substring(4, 5);
    if (!RegExp(r'\d').hasMatch(classification)) {
      throw ArgumentError.value(
          classification, 'classification', 'should be a number');
    }
    final data = cip13.substring(0, cip13.length - 1);
    final crc = _calculateCip13Crc(data);
    if ('$crc' != cip13.substring(cip13.length - 1)) {
      throw ArgumentError.value(crc, 'crc', 'is not correct');
    }
    return PharmaceuticalCip13._(
      prefix: cip13.substring(0, 2),
      type: _pharmaceuticalTypeMap[type],
      classification: _pharmaceuticalClassificationMap[classification],
      cip7: Cip7(data: cip13.substring(5, cip13.length - 1)),
      crc: '$crc',
    );
  }

  String toString() {
    final sb = StringBuffer(prefix);
    final _type = _pharmaceuticalTypeMap.entries
        .firstWhere(
          (entry) => entry.value == type,
        )
        ?.key;
    sb.write(_type);
    final _classification = _pharmaceuticalClassificationMap.entries
        .firstWhere(
          (entry) => entry.value == classification,
        )
        ?.key;
    sb.write(_classification);
    sb.write('$cip7$crc');
    return sb.toString();
  }
}
