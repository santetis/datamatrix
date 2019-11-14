import 'package:pharmaceutical_datamatrix/pharmaceutical_datamatrix.dart';
import 'package:test/test.dart';

void main() {
  test('parse datamatrix data', () {
    final datamatrixData = '0103400091111111170101120101121012lt';

    final pharmaceuticalDatamatrix = PharmaceuticalDatamatrix.fromDatamatrix(
      datamatrix: datamatrixData,
    );

    expect(pharmaceuticalDatamatrix.cip13.toString(), '3400091111111');
    expect(pharmaceuticalDatamatrix.lot, '12lt');
    expect(pharmaceuticalDatamatrix.created, DateTime(12, 01, 01));
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
