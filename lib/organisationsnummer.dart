import 'package:personnummer/personnummer.dart';

class OrganisationsnummerException implements Exception {
  String cause;
  OrganisationsnummerException(
      [this.cause = 'Invalid Swedish organization number']);
}

class Organisationsnummer {
  /// The organization number.
  String number = '';

  /// Personnummer instance.
  Personnummer? _personnummer = null;

  /// Organisationsnummer constructor.
  Organisationsnummer(String org) {
    _parse(org);
  }

  /// Luhn/mod10 algorithm. Used to calculate a checksum from the passed value
  /// The checksum is returned and tested against the control number
  /// in the organization number to make sure that it is a valid number.
  bool _luhn(String str) {
    var v = 0;
    var sum = 0;

    for (var i = 0, l = str.length; i < l; i++) {
      v = int.parse(str[i]);
      v *= 2 - (i % 2);
      if (v > 9) {
        v -= 9;
      }
      sum += v;
    }

    return sum % 10 == 0;
  }

  /// Parse Swedish organization numbers and set properties.
  void _parse(String org) {
    if (org.length < 10 || org.length > 13) {
      throw OrganisationsnummerException();
    }

    var reg =
        RegExp(r'^(\d{2}){0,1}(\d{2})(\d{2})(\d{2})([\+\-]?)(\d{3})(\d)$');
    var match;

    try {
      number = org.replaceAll('-', '');
      match = reg.firstMatch(number);

      if (match == null) {
        throw OrganisationsnummerException();
      }

      // May only be prefixed with 16.
      if (match[1] != null) {
        if (int.parse(match[1]) != 16) {
          throw OrganisationsnummerException();
        } else {
          number = number.substring(2);
        }
      }

      // Third digit bust be more than 20.
      if (int.parse(match[3]) < 20) {
        throw OrganisationsnummerException();
      }

      // May not start with leading 0.
      if (int.parse(match[2]) < 10) {
        throw OrganisationsnummerException();
      }

      if (!_luhn(number)) {
        throw OrganisationsnummerException();
      }
    } catch (e) {
      try {
        this._personnummer = Personnummer.parse(org);
      } catch (_) {
        throw e;
      }
    }
  }

  /// Format Swedish organization numbers to official format.
  String format([bool separator = true]) {
    var _number = number;

    if (this.isPersonnummer()) {
      return this
          ._personnummer!
          .format(!separator)
          .substring(!separator ? 2 : 0);
    }

    return separator
        ? _number.substring(0, 6) + '-' + _number.substring(6)
        : _number;
  }

  /// Get Personnummer instance.
  Personnummer? personnummer() {
    return this._personnummer;
  }

  /// Determine if personnummer or not.
  bool isPersonnummer() {
    return this._personnummer != null;
  }

  /// Get the organization type.
  String type() {
    if (this.isPersonnummer()) {
      return 'Enskild firma';
    }

    var unkown = 'Okänt';
    var types = {
      1: 'Dödsbon',
      2: 'Stat, landsting, kommun eller församling',
      3: 'Utländska företag som bedriver näringsverksamhet eller äger fastigheter i Sverige',
      5: 'Aktiebolag',
      6: 'Enkelt bolag',
      7: 'Ekonomisk förening eller bostadsrättsförening',
      8: 'Ideella förening och stiftelse',
      9: 'Handelsbolag, kommanditbolag och enkelt bolag',
    };

    return types[int.parse(this.number[0])] ?? unkown;
  }

  /// Get vat number for a organization number.
  String vatNumber() {
    return "SE${format(false)}01";
  }

  /// Parse Swedish organization numbers.
  /// Returns `Organisationsnummer` class.
  static Organisationsnummer parse(String org) {
    return Organisationsnummer(org);
  }

  /// Validates Swedish organization numbers.
  /// Returns `true` if the org value is a valid Swedish organization number
  static bool valid(String org) {
    try {
      parse(org);
      return true;
    } catch (e) {
      return false;
    }
  }
}
