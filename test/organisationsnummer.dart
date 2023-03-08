import 'package:test/test.dart';
import 'package:organisationsnummer/organisationsnummer.dart';
import 'package:personnummer/personnummer.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

Future<String> fetchUrlBodyAsString(String url) async {
  var request = await HttpClient().getUrl(Uri.parse(url));
  var response = await request.close();
  return response.transform(utf8.decoder).join();
}

void main() async {
  final url =
      'https://raw.githubusercontent.com/organisationsnummer/meta/main/testdata/list.json';
  String body = await fetchUrlBodyAsString(url);
  List<dynamic> list = jsonDecode(body);
  runTests(list);
}

void runTests(List<dynamic> list) {
  test('should validate valid organization numbers', () {
    list.where((item) => item['valid']).forEach(
        (item) => expect(Organisationsnummer.valid(item['input']), true));
  });

  test('should validate invalid organization numbers', () {
    list.where((item) => !item['valid']).forEach(
        (item) => expect(Organisationsnummer.valid(item['input']), false));
  });

  test('should format organization numbers without separator', () {
    list.where((item) => item['valid']).forEach((item) => expect(
        Organisationsnummer.parse(item['input']).format(false),
        item['short_format']));
  });

  test('should format organization numbers with separator', () {
    list.where((item) => item['valid']).forEach((item) => expect(
        Organisationsnummer.parse(item['input']).format(),
        item['long_format']));
  });

  test('should get type from organization numbers', () {
    list.where((item) => item['valid']).forEach((item) =>
        expect(Organisationsnummer.parse(item['input']).type(), item['type']));
  });

  test('should get vat number for organization numbers', () {
    list.where((item) => item['valid']).forEach((item) => expect(
        Organisationsnummer.parse(item['input']).vatNumber(),
        item['vat_number']));
  });

  test('should work with personal identity numbers', () {
    list
        .where((item) => item['valid'] && item['type'] == 'Enskild firma')
        .forEach((item) {
      expect(Organisationsnummer.valid(item['long_format']), true);
      expect(Organisationsnummer.valid(item['input']), true);
      var org = Organisationsnummer.parse(item['input']);
      expect(org.format(false), item['short_format']);
      expect(org.format(true), item['long_format']);
      expect(org.type(), item['type']);
      expect(org.isPersonnummer(), true);
      expect(org.personnummer().runtimeType, Personnummer);
      expect(org.vatNumber(), item['vat_number']);
    });
  });
}
