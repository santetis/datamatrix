import 'package:pharmaceutical_datamatrix/pharmaceutical_datamatrix.dart';
import 'package:test/test.dart';

void main() {
  test('bad length', () {
    expect(
      () => Cip7(
        data: '111111',
      ),
      throwsA(isArgumentError),
    );
  });

  test('valid', () {
    expect(
      () => Cip7(
        data: '111111',
      ),
      throwsA(isArgumentError),
    );
  });
}
