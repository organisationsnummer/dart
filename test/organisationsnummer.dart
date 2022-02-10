import 'package:test/test.dart';
import 'package:organisationsnummer/organisationsnummer.dart';
import 'package:personnummer/personnummer.dart';

void main() {
  test('should validate valid organization numbers', () {
    var numbers = ['556016-0680', '556103-4249', '5561034249'];

    numbers
        .forEach((number) => expect(Organisationsnummer.valid(number), true));
  });

  test('should validate invalid organization numbers', () {
    var numbers = ['556016-0681', '556103-4250', '5561034250'];

    numbers
        .forEach((number) => expect(Organisationsnummer.valid(number), false));
  });

  test('should format organization numbers without separator', () {
    var numbers = {
      '556016-0680': '5560160680',
      '556103-4249': '5561034249',
      '5561034249': '5561034249',
    };

    numbers.forEach((input, output) =>
        expect(Organisationsnummer.parse(input).format(false), output));
  });

  test('should format organization numbers with separator', () {
    var numbers = {
      '556016-0680': '556016-0680',
      '556103-4249': '556103-4249',
      '5561034249': '556103-4249',
    };

    numbers.forEach((input, output) =>
        expect(Organisationsnummer.parse(input).format(), output));
  });

  test('should get type from organization numbers', () {
    var numbers = {
      '556016-0680': 'Aktiebolag',
      '556103-4249': 'Aktiebolag',
      '5561034249': 'Aktiebolag',
    };

    numbers.forEach((input, output) =>
        expect(Organisationsnummer.parse(input).type(), output));
  });

  test('should get vat number for organization numbers', () {
    var numbers = {
      '556016-0680': 'SE556016068001',
      '556103-4249': 'SE556103424901',
      '5561034249': 'SE556103424901',
    };

    numbers.forEach((input, output) =>
        expect(Organisationsnummer.parse(input).vatNumber(), output));
  });

  test('should work with personal identity numbers', () {
    const type = 'Enskild firma';
    const numbers = {'121212121212': '121212-1212'};

    numbers.forEach((input, output) {
      expect(Organisationsnummer.valid(output), true);
      expect(Organisationsnummer.valid(input), true);
      var org = Organisationsnummer.parse(input);
      expect(org.format(false), output.replaceAll('-', ''));
      expect(org.format(true), output);
      expect(org.type(), type);
      expect(org.isPersonnummer(), true);
      expect(org.personnummer().runtimeType, Personnummer);
      // expect(org.personnummer().constructor.name).toBe('Personnummer');
    });
  });

  test('should get vat number for personal identity numbers', () {
    const numbers = {
      '121212121212': 'SE121212121201',
      '12121212-1212': 'SE121212121201',
    };

    numbers.forEach((input, output) {
      expect(Organisationsnummer.parse(input).vatNumber(), output);
    });
  });
}
