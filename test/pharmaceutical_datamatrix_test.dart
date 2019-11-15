import 'package:pharmaceutical_datamatrix/pharmaceutical_datamatrix.dart';
import 'package:test/test.dart';

void main() {
  test('invalid cip7', () {
    expect(
      () => Cip7(
        data: '111111',
      ),
      throwsA(isArgumentError),
    );
  });

  test('valid cip7', () {
    final cip7 = Cip7(
      data: '1111111',
    );

    expect(cip7.data, '1111111');
  });

  test('cip13 from invalid String', () {
    expect(
      () => PharmaceuticalCip13.fromString('123123'),
      throwsA(isArgumentError),
    );
  });

  test('cip13 from String', () {
    final cip13 = PharmaceuticalCip13.fromString('3400935510259');
    expect(cip13.prefix, '34');
    expect(cip13.cip7.toString(), '3551025');
  });

  test('parse datamatrix data', () {
    final datamatrixData = '0103400949497294170101120101121012lt';

    final pharmaceuticalDatamatrix = PharmaceuticalDatamatrix.fromDatamatrix(
      datamatrix: datamatrixData,
    );

    expect(pharmaceuticalDatamatrix.cip13.toString(), '3400949497294');
    expect(pharmaceuticalDatamatrix.lot, '12lt');
    expect(pharmaceuticalDatamatrix.manufactured, DateTime(12, 01, 01));
    expect(pharmaceuticalDatamatrix.expiration, DateTime(12, 01, 01));
  });

  test('bad formatted datamatrix data', () {
    final datamatrixData = 'r03hth34t01tih301ghjfqiogh31gh';

    expect(
      () => PharmaceuticalDatamatrix.fromDatamatrix(
        datamatrix: datamatrixData,
      ),
      throwsA(isArgumentError),
    );
  });

  test('null datamatrix', () {
    expect(
      () => PharmaceuticalDatamatrix.fromDatamatrix(
        datamatrix: null,
      ),
      throwsA(isArgumentError),
    );
  });
}
