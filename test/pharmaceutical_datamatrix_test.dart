import 'package:pharmaceutical_datamatrix/pharmaceutical_datamatrix.dart';
import 'package:test/test.dart';

void main() {
  test('null', () {
    expect(
      () => PharmaceuticalDatamatrix.fromDatamatrix(
        datamatrix: null,
      ),
      throwsA(isArgumentError),
    );
  });

  test('not valid', () {
    final datamatrixData = '0203400949497294170101120101121012lt';
    expect(
      () => PharmaceuticalDatamatrix.fromDatamatrix(
        datamatrix: datamatrixData,
      ),
      throwsA(isArgumentError),
    );
  });

  test('valid', () {
    final datamatrixData = '0103400949497294170101120101121012lt';
    final datamatrix = PharmaceuticalDatamatrix.fromDatamatrix(
      datamatrix: datamatrixData,
    );

    expect(datamatrix.cip13.toString(), '3400949497294');
  });
}
