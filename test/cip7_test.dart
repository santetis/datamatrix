import 'package:pharmaceutical_datamatrix/pharmaceutical_datamatrix.dart';
import 'package:test/test.dart';

void main() {
  test('bad length', () {
    expect(
      () => Cip7.fromData(
        data: '111111',
      ),
      throwsA(isArgumentError),
    );
  });

  test('valid', () {
    final cip7 = Cip7.fromData(data: '1111111');
    expect(cip7.data, '1111111');
  });
}
