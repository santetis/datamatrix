import 'package:meta/meta.dart';

@immutable
class Cip7 {
  String data;

  Cip7._({@required this.data});

  factory Cip7.fromData({@required String data}) {
    if (data?.length != 7) {
      throw ArgumentError.value(data, 'cip7', 'length should be equal to 7');
    }
    return Cip7._(
      data: data,
    );
  }

  String toString() => data;
}
