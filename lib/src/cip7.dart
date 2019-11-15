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
